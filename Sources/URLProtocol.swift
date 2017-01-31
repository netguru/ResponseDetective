//
// URLProtocol.swift
//
// Copyright (c) 2016-2017 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation

/// The intercepting URL protocol.
@objc(RDTURLProtocol) internal final class URLProtocol: Foundation.URLProtocol, URLSessionTaskDelegate, URLSessionDataDelegate {
	
	/// Internal session object used to perform the request.
	private var internalSession: Foundation.URLSession!
	
	/// Internal session data dark responsible for request execution.
	private var internalTask: URLSessionDataTask!
	
	/// Internal task response storage.
	private var internalResponse: HTTPURLResponse?
	
	/// Internal response data storage.
	private lazy var internalResponseData = Data()

	/// A unique identifier of the request. Currently its address.
	private var requestIdentifier: String {
		return String(describing: Unmanaged<AnyObject>.passUnretained(internalTask.originalRequest! as AnyObject).toOpaque())
	}
	
	// MARK: Interceptors
	
	/// Incercepts the given request and passes it to the ResponseDetective
	/// instance.
	///
	/// - Parameter request: The intercepted request.
	private func intercept(request: URLRequest) {
		let deserializedBody = standardizedDataOfRequest(request).flatMap { data in
			ResponseDetective.deserialize(body: data, contentType: request.value(forHTTPHeaderField: "Content-Type") ?? "application/octet-stream")
		}
		let requestRepresentation = RequestRepresentation(identifier: requestIdentifier, request: request, deserializedBody: deserializedBody)
		ResponseDetective.outputFacility.output(requestRepresentation: requestRepresentation)
	}


	/// Extracts and standardizes data of a request.
	///
	/// - Parameter request: The request which data should be standardized.
	///
	/// - Returns: Data of the `request`.
	private func standardizedDataOfRequest(_ request: URLRequest) -> Data? {
		return request.httpBody ?? request.httpBodyStream.flatMap { stream in
			let data = NSMutableData()
			stream.open()
			while stream.hasBytesAvailable {
				var buffer = [UInt8](repeating: 0, count: 1024)
				let length = stream.read(&buffer, maxLength: buffer.count)
				data.append(buffer, length: length)
			}
			stream.close()
			return data as Data
		}
	}

	/// Incercepts the given response and passes it to the ResponseDetective
	/// instance.
	///
	/// - Parameters:
	///     - response: The intercepted response.
	///     - data: The intercepted response data.
	private func intercept(response: HTTPURLResponse, data: Data?) {
		let deserializedBody = data.flatMap { data in
			ResponseDetective.deserialize(body: data, contentType: (response.allHeaderFields["Content-Type"] as? String) ?? "application/octet-stream")
		}
		let responseRepresentation = ResponseRepresentation(requestIdentifier: requestIdentifier, response: response, body: data, deserializedBody: deserializedBody)
		ResponseDetective.outputFacility.output(responseRepresentation: responseRepresentation)
	}
	
	/// Incercepts the given error and passes it to the ResponseDetective
	/// instance.
	///
	/// - Parameters:
	///     - error: The intercepted request.
	///     - response: The intercepted response.
	///     - data: The intercepted response data.
	private func interceptError(_ error: NSError, response: HTTPURLResponse?, data: Data?) {
		let deserializedBody = response.flatMap { response in
			return data.flatMap { data in
				ResponseDetective.deserialize(body: data, contentType: (response.allHeaderFields["Content-Type"] as? String) ?? "application/octet-stream")
			}
		}
		let responseRepresentation = response.flatMap { response in
			ResponseRepresentation(requestIdentifier: requestIdentifier, response: response, body: data, deserializedBody: deserializedBody)
		}
		let errorRepresentation = ErrorRepresentation(requestIdentifier: requestIdentifier, error: error, response: responseRepresentation)
		ResponseDetective.outputFacility.output(errorRepresentation: errorRepresentation)
	}
	
	// MARK: NSURLProtocol
	
	internal override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
		super.init(request: request, cachedResponse: cachedResponse, client: client)
		internalSession = Foundation.URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
		internalTask = internalSession.dataTask(with: request)
	}
	
	internal override static func canInit(with request: URLRequest) -> Bool {
		guard let URL = request.url, let scheme = URL.scheme else { return false }
		return ["http", "https"].contains(scheme) && ResponseDetective.canIncercept(request: request)
	}
	
	internal override static func canonicalRequest(for request: URLRequest) -> URLRequest {
		return request
	}
	
	internal override func startLoading() {
		intercept(request: request)
		internalTask.resume()
	}
	
	internal override func stopLoading() {
		internalSession.invalidateAndCancel()
	}
	
	// MARK: NSURLSessionTaskDelegate

	internal func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
		client?.urlProtocol(self, wasRedirectedTo: request, redirectResponse: response)
	}
	
	internal func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		if let error = error {
			interceptError(error as NSError, response: internalResponse, data: internalResponseData)
			client?.urlProtocol(self, didFailWithError: error)
		} else if let response = internalResponse {
			intercept(response: response, data: internalResponseData)
			client?.urlProtocolDidFinishLoading(self)
		}
		internalSession.finishTasksAndInvalidate()
	}
	
	// MARK: NSURLSessionDataDelegate
	
	internal func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
		internalResponse = response as? HTTPURLResponse
		completionHandler(.allow)
		client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
	}
	
	internal func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
		internalResponseData.append(data)
		client?.urlProtocol(self, didLoad: data)
	}
	
}
