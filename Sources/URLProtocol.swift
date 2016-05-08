//
// URLProtocol.swift
//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation

/// The intercepting URL protocol.
@objc(RDTURLProtocol) internal final class URLProtocol: NSURLProtocol, NSURLSessionTaskDelegate, NSURLSessionDataDelegate {
	
	/// Internal session object used to perform the request.
	private var internalSession: NSURLSession!
	
	/// Internal session data dark responsible for request execution.
	private var internalTask: NSURLSessionDataTask!
	
	/// Internal task response storage.
	private var internalResponse: NSHTTPURLResponse?
	
	/// Internal response data storage.
	private lazy var internalResponseData = NSMutableData()

	/// A unique identifier of the request. Currently its address.
	private var requestIdentifier: String {
		return String(unsafeAddressOf(internalTask.originalRequest!))
	}
	
	// MARK: Interceptors
	
	/// Incercepts the given request and passes it to the ResponseDetective
	/// instance.
	///
	/// - Parameter request: The intercepted request.
	private func interceptRequest(request: NSURLRequest) {
		let deserializedBody = request.HTTPBody.flatMap { data in
			ResponseDetective.deserializeBody(data, contentType: request.valueForHTTPHeaderField("Content-Type") ?? "application/octet-stream")
		}
		let requestRepresentation = RequestRepresentation(identifier: requestIdentifier, request: request, deserializedBody: deserializedBody)
		ResponseDetective.outputFacility.outputRequestRepresentation(requestRepresentation)
	}
	
	/// Incercepts the given response and passes it to the ResponseDetective
	/// instance.
	///
	/// - Parameters:
	///     - response: The intercepted response.
	///     - data: The intercepted response data.
	private func interceptResponse(response: NSHTTPURLResponse, data: NSData?) {
		let deserializedBody = data.flatMap { data in
			ResponseDetective.deserializeBody(data, contentType: (response.allHeaderFields["Content-Type"] as? String) ?? "application/octet-stream")
		}
		let responseRepresentation = ResponseRepresentation(requestIdentifier: requestIdentifier, response: response, body: data, deserializedBody: deserializedBody)
		ResponseDetective.outputFacility.outputResponseRepresentation(responseRepresentation)
	}
	
	/// Incercepts the given error and passes it to the ResponseDetective
	/// instance.
	///
	/// - Parameters:
	///     - error: The intercepted request.
	///     - response: The intercepted response.
	///     - data: The intercepted response data.
	private func interceptError(error: NSError, response: NSHTTPURLResponse?, data: NSData?) {
		let deserializedBody = response.flatMap { response in
			return data.flatMap { data in
				ResponseDetective.deserializeBody(data, contentType: (response.allHeaderFields["Content-Type"] as? String) ?? "application/octet-stream")
			}
		}
		let responseRepresentation = response.flatMap { response in
			ResponseRepresentation(requestIdentifier: requestIdentifier, response: response, body: data, deserializedBody: deserializedBody)
		}
		let errorRepresentation = ErrorRepresentation(response: responseRepresentation, error: error, requestIdentifier: requestIdentifier)
		ResponseDetective.outputFacility.outputErrorRepresentation(errorRepresentation)
	}
	
	// MARK: NSURLProtocol
	
	internal override init(request: NSURLRequest, cachedResponse: NSCachedURLResponse?, client: NSURLProtocolClient?) {
		super.init(request: request, cachedResponse: cachedResponse, client: client)
		internalSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
		internalTask = internalSession.dataTaskWithRequest(request)
	}
	
	internal override static func canInitWithRequest(request: NSURLRequest) -> Bool {
		return ResponseDetective.canIncerceptRequest(request)
	}
	
	internal override static func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
		return request
	}
	
	internal override func startLoading() {
		interceptRequest(request)
		internalTask.resume()
	}
	
	internal override func stopLoading() {
		internalTask.cancel()
	}
	
	// MARK: NSURLSessionTaskDelegate

	internal func URLSession(session: NSURLSession, task: NSURLSessionTask, willPerformHTTPRedirection response: NSHTTPURLResponse, newRequest request: NSURLRequest, completionHandler: (NSURLRequest?) -> Void) {
		client?.URLProtocol(self, wasRedirectedToRequest: request, redirectResponse: response)
	}
	
	internal func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
		client?.URLProtocol(self, didReceiveAuthenticationChallenge: challenge)
		completionHandler(.PerformDefaultHandling, nil)
	}
	
	internal func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
		if let error = error {
			interceptError(error, response: internalResponse, data: internalResponseData)
			client?.URLProtocol(self, didFailWithError: error)
		} else if let response = internalResponse {
			interceptResponse(response, data: internalResponseData)
			client?.URLProtocolDidFinishLoading(self)
		}
	}
	
	// MARK: NSURLSessionDataDelegate
	
	internal func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
		internalResponse = response as? NSHTTPURLResponse
		completionHandler(.Allow)
		client?.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .Allowed)
	}
	
	internal func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
		internalResponseData.appendData(data)
		client?.URLProtocol(self, didLoadData: data)
	}
	
}
