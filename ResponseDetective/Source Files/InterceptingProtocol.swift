//
//  Protocol.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

public final class InterceptingProtocol: NSURLProtocol {

	/// The interceptor removal token type.
	public typealias InterceptorRemovalToken = UInt

	/// The last registered removal token.
	private static var lastRemovalToken: InterceptorRemovalToken = 0

	/// Private request interceptors store.
	private static var requestInterceptors = [InterceptorRemovalToken: RequestInterceptorType]()

	/// Private response interceptors store.
	private static var responseInterceptors = [InterceptorRemovalToken: ResponseInterceptorType]()

	/// Private under-the-hood session object.
	private let session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())

	/// Private under-the-hood session task.
	private lazy var sessionTask = NSURLSessionDataTask()

	// MARK: Interceptor registration

	/// Registers a new request interceptor.
	///
	/// :param: interceptor The new interceptor instance to register.
	///
	/// :returns: A unique token which can be used for removing that request
	/// incerceptor.
	public static func registerRequestInterceptor(interceptor: RequestInterceptorType) -> InterceptorRemovalToken {
		requestInterceptors[++lastRemovalToken] = interceptor
		return lastRemovalToken
	}

	/// Registers a new response interceptor.
	///
	/// :param: interceptor The new response interceptor instance to register.
	///
	/// :returns: A unique token which can be used for removing that response
	/// incerceptor.
	public static func registerResponseInterceptor(interceptor: ResponseInterceptorType) -> InterceptorRemovalToken {
		responseInterceptors[++lastRemovalToken] = interceptor
		return lastRemovalToken
	}

	/// Unregisters the previously registered request incerceptor.
	///
	/// :param: removalToken The removal token obtained when registering the
	/// request interceptor.
	public static func unregisterRequestInterceptor(removalToken: InterceptorRemovalToken) {
		requestInterceptors[removalToken] = nil
	}

	/// Unregisters the previously registered response incerceptor.
	///
	/// :param: removalToken The removal token obtained when registering the
	/// response interceptor.
	public static func unregisterResponseInterceptor(removalToken: InterceptorRemovalToken) {
		responseInterceptors[removalToken] = nil
	}

	// MARK: NSURLProtocol Overrides
	
	public override init(request: NSURLRequest, cachedResponse: NSCachedURLResponse?, client: NSURLProtocolClient?) {
		super.init(request: request, cachedResponse: cachedResponse, client: client)
		
		sessionTask = session.dataTaskWithRequest(request) { [weak self] (data, response, error) in
			if let error = error {
				self?.propagateResponseErrorInterception((response as? NSHTTPURLResponse), error)
			} else if let response = response as? NSHTTPURLResponse, let data = data {
				self?.propagateResponseInterception(response, data)
			}
		}
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

	// MARK: Propagation helpers

	/// Propagates the request interception.
	///
	/// :param: request The intercepted request.
	private func propagateRequestInterception(request: NSURLRequest) {
		if let representation = RequestRepresentation(request) {
			for (_, interceptor) in InterceptingProtocol.requestInterceptors {
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
			for (_, interceptor) in InterceptingProtocol.responseInterceptors {
				if interceptor.canInterceptResponse(representation) {
					interceptor.interceptResponse(representation)
				}
			}
		}
	}

	/// Propagates the request interception.
	///
	/// :param: response The intercepted response (if any).
	/// :param: error The intercepted response error.
	private func propagateResponseErrorInterception(response: NSHTTPURLResponse?, _ error: NSError) {
		// TODO
	}
}

extension InterceptingProtocol: NSURLSessionDataDelegate {
	
	public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
		self.client!.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy:NSURLCacheStoragePolicy.Allowed)
	}
	
	public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
		self.client!.URLProtocol(self, didLoadData: data)
	}
}

extension InterceptingProtocol: NSURLSessionTaskDelegate {

	public func URLSession(session: NSURLSession, task: NSURLSessionTask, willPerformHTTPRedirection response: NSHTTPURLResponse, newRequest request: NSURLRequest, completionHandler: (NSURLRequest!) -> Void) {
		self.client!.URLProtocol(self, wasRedirectedToRequest: request, redirectResponse: response)
	}
	
	public func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
		self.client!.URLProtocol(self, didReceiveAuthenticationChallenge: challenge)
	}
	
	public func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
		if let error = error {
			self.client!.URLProtocol(self, didFailWithError: error)
		}
	}
}
