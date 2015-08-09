//
//  Protocol.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

@objc(RDVIntercetingProtocol) public final class InterceptingProtocol: NSURLProtocol, NSURLSessionDataDelegate, NSURLSessionTaskDelegate {

	/// Request interceptors store.
	public private(set) static var requestInterceptors = [RequestInterceptorType]()

	/// Response interceptors store.
	public private(set) static var responseInterceptors = [ResponseInterceptorType]()
	
	/// Error interceptors store.
	public private(set) static var errorInterceptors = [ErrorInterceptorType]()

	/// Private under-the-hood session object.
	private var session: NSURLSession!

	/// Private under-the-hood session task.
	private var sessionTask: NSURLSessionDataTask!
	
	/// Private under-the-hood response object
	private var response: NSHTTPURLResponse?
	
	/// Private under-the-hood response data object.
	private lazy var responseData = NSMutableData()

	// MARK: Interceptor registration

	/// Registers a new request interceptor.
	///
	/// :param: interceptor The new interceptor instance to register.
	///
	/// :returns: A unique token which can be used for removing that request
	/// interceptor.
	public static func registerRequestInterceptor(interceptor: RequestInterceptorType) {
		requestInterceptors.append(interceptor)
	}

	/// Registers a new response interceptor.
	///
	/// :param: interceptor The new response interceptor instance to register.
	///
	/// :returns: A unique token which can be used for removing that response
	/// interceptor.
	public static func registerResponseInterceptor(interceptor: ResponseInterceptorType) {
		responseInterceptors.append(interceptor)
	}
	
	/// Registers a new error interceptor.
	///
	/// :param: interceptor The new error interceptor instance to register.
	///
	/// :returns: A unique token which can be used for removing that error
	/// interceptor.
	public static func registerErrorInterceptor(interceptor: ErrorInterceptorType) {
		errorInterceptors.append(interceptor)
	}

	/// Unregisters the previously registered request interceptor.
	///
	/// :param: removalToken The removal token obtained when registering the
	/// request interceptor.
	public static func unregisterRequestInterceptor(interceptor: RequestInterceptorType) {
		requestInterceptors = filter(requestInterceptors, { $0 !== interceptor })
	}

	/// Unregisters the previously registered response interceptor.
	///
	/// :param: removalToken The removal token obtained when registering the
	/// response interceptor.
	public static func unregisterResponseInterceptor(interceptor: ResponseInterceptorType) {
		responseInterceptors = filter(responseInterceptors, { $0 !== interceptor })
	}
	
	/// Unregisters the previously registered error interceptor.
	///
	/// :param: removalToken The removal token obtained when registering the
	/// error interceptor.
	public static func unregisterErrorInterceptor(interceptor: ErrorInterceptorType) {
		errorInterceptors = filter(errorInterceptors, { $0 !== interceptor })
	}

	// MARK: Propagation helpers

	/// Propagates the request interception.
	///
	/// :param: request The intercepted request.
	private func propagateRequestInterception(request: NSURLRequest) {
		if let representation = RequestRepresentation(request) {
			for interceptor in InterceptingProtocol.requestInterceptors {
				if interceptor.canInterceptRequest(representation) {
					interceptor.interceptRequest(representation)
				}
			}
		}
	}

	/// Propagates the request interception.
	///
	/// :param: request The intercepted response.
	/// :param: data The intercepted response data.
	private func propagateResponseInterception(response: NSHTTPURLResponse, _ data: NSData) {
		if let representation = ResponseRepresentation(response, data) {
			for interceptor in InterceptingProtocol.responseInterceptors {
				if interceptor.canInterceptResponse(representation) {
					interceptor.interceptResponse(representation)
				}
			}
		}
	}

	/// Propagates the error interception.
	///
	/// :param: error The intercepted response error.
	/// :param: response The intercepted response (if any).
	/// :param: error The error which occured during the request.
	private func propagateResponseErrorInterception(response: NSHTTPURLResponse?, _ data: NSData?, _ error: NSError) {
		if let response = response, representation = ResponseRepresentation(response, data) {
			for interceptor in InterceptingProtocol.errorInterceptors {
				interceptor.interceptError(error, representation)
			}
		}
	}

	// MARK: NSURLProtocol overrides
	
	public override init(request: NSURLRequest, cachedResponse: NSCachedURLResponse?, client: NSURLProtocolClient?) {
		super.init(request: request, cachedResponse: cachedResponse, client: client)
		session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration(), delegate: self, delegateQueue: nil)
		sessionTask = session.dataTaskWithRequest(request)
	}

	public override static func canInitWithRequest(request: NSURLRequest) -> Bool {
		return true
	}

	public override static func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
		return request
	}

	public override func startLoading() {
		propagateRequestInterception(request)
		sessionTask.resume()
	}

	public override func stopLoading() {
		sessionTask.cancel()
	}

	// MARK: NSURLSessionDataDelegate methods
	
	public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
		client?.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy:NSURLCacheStoragePolicy.Allowed)
		completionHandler(.Allow)
		if let response = response as? NSHTTPURLResponse {
			self.response = response
		}
	}
	
	public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
		client?.URLProtocol(self, didLoadData: data)
		responseData.appendData(data)
	}

	// MARK: NSURLSessionTaskDelegate methods
	
	public func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
		if let error = error {
			client?.URLProtocol(self, didFailWithError: error)
			propagateResponseErrorInterception(response, responseData, error)
		}
		client?.URLProtocolDidFinishLoading(self)
		if let response = self.response {
			propagateResponseInterception(response, responseData)
		}
	}
}

// MARK: -

public extension InterceptingProtocol {
	
	static func unregisterAllRequestInterceptors() {
		requestInterceptors.removeAll(keepCapacity: false)
	}
	
	static func unregisterAllResponseInterceptors() {
		responseInterceptors.removeAll(keepCapacity: false)
	}
	
	static func unregisterAllErrorInterceptors() {
		errorInterceptors.removeAll(keepCapacity: false)
	}
}
