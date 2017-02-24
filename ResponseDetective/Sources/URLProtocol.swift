//
// URLProtocol.swift
//
// Copyright © 2016-2017 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation

/// The intercepting URL protocol.
@objc(RDTURLProtocol) internal final class URLProtocol: Foundation.URLProtocol, URLSessionTaskDelegate, URLSessionDataDelegate {

	// MARK: Initialization

	/// - SeeAlso: Foundation.URLProtocol.canInit(with:)
	internal override static func canInit(with request: URLRequest) -> Bool {
		guard let URL = request.url, let scheme = URL.scheme else { return false }
		return ["http", "https"].contains(scheme) && ResponseDetective.canIncercept(request: request)
	}

	/// - SeeAlso: Foundation.URLProtocol.init(request:cachedResponse:client:)
	internal override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
		super.init(request: request, cachedResponse: cachedResponse, client: client)
		internalSession = Foundation.URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
		internalTask = internalSession.dataTask(with: request)
	}

	// MARK: Properties
	
	/// Internal session object used to perform the request.
	private var internalSession: Foundation.URLSession!
	
	/// Internal session data dark responsible for request execution.
	private var internalTask: URLSessionDataTask!
	
	/// Internal task response storage.
	private var internalResponse: HTTPURLResponse?
	
	/// Internal response data storage.
	private lazy var internalResponseData = Data()

	/// A unique identifier of the request. Currently its address.
	private lazy var requestIdentifier: String = String(describing: Unmanaged<AnyObject>.passUnretained(self.internalTask.originalRequest! as AnyObject).toOpaque())

	// MARK: URLProtocol

	/// - SeeAlso: Foundation.URLProtocol.canonicalRequest(for:)
	internal override static func canonicalRequest(for request: URLRequest) -> URLRequest {
		return request
	}

	/// - SeeAlso: Foundation.URLProtocol.startLoading()
	internal override func startLoading() {
		intercept(request: request)
		internalTask.resume()
	}

	/// - SeeAlso: Foundation.URLProtocol.stopLoading()
	internal override func stopLoading() {
		internalSession.invalidateAndCancel()
	}

	// MARK: URLSessionTaskDelegate

	/// - SeeAlso: URLSessionTaskDelegate.urlSession(_:task:willPerformHTTPRedirection:newRequest:completionHandler:)
	internal func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
		client?.urlProtocol(self, wasRedirectedTo: request, redirectResponse: response)
	}

	/// - SeeAlso: URLSessionTaskDelegate.urlSession(_:task:didCompleteWithError:)
	internal func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		if let error = error {
			intercept(error: error as NSError, response: internalResponse, data: internalResponseData)
			client?.urlProtocol(self, didFailWithError: error)
		} else if let response = internalResponse {
			intercept(response: response, data: internalResponseData)
			client?.urlProtocolDidFinishLoading(self)
		}
		internalSession.finishTasksAndInvalidate()
	}
	
	// MARK: URLSessionDataDelegate

	/// - SeeAlso: URLSessionDataDelegate.urlSession(_:dataTask:didReceive:completionHandler:)
	internal func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
		internalResponse = response as? HTTPURLResponse
		completionHandler(.allow)
		client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
	}

	/// - SeeAlso: URLSessionDataDelegate.urlSession(_:dataTask:didReceive:)
	internal func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
		internalResponseData.append(data)
		client?.urlProtocol(self, didLoad: data)
	}

	// MARK: Interception
	
	/// Incercepts the given request and passes it to the ResponseDetective
	/// instance.
	///
	/// - Parameter request: The intercepted request.
	private func intercept(request: URLRequest) {
		let deserializedBody = standardizedData(of: request).flatMap { data in
			ResponseDetective.deserialize(body: data, contentType: request.value(forHTTPHeaderField: "Content-Type") ?? "application/octet-stream")
		}
		let requestRepresentation = RequestRepresentation(identifier: requestIdentifier, request: request, deserializedBody: deserializedBody)
		ResponseDetective.outputFacility.output(requestRepresentation: requestRepresentation)
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
	private func intercept(error: NSError, response: HTTPURLResponse?, data: Data?) {
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

	// MARK: Private
	
	/// Extracts and standardizes data of a request.
	///
	/// - Parameters:
	///     - request: The request which data should be standardized.
	///
	/// - Returns: Data of the `request`.
	private func standardizedData(of request: URLRequest) -> Data? {
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
	
}
