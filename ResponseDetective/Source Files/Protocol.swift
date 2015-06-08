//
//  Protocol.swift
//  ResponseDetective
//
//  Created by Aleksander Popko on 08.06.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

public final class InterceptingProtocol: NSURLProtocol {
    
    private static var requestInterceptors: [RequestInterceptorType] = []
    private static var responseInterceptors: [ResponseInterceptorType] = []
    
    override init(request: NSURLRequest, cachedResponse: NSCachedURLResponse?, client: NSURLProtocolClient?) {
        super.init(request: request, cachedResponse: cachedResponse, client: client)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                //TODO - log error
            } else {
                //TODO - intercept response
            }})
        task.resume()
    }

    override public func startLoading() {
        for requestInterceptor in InterceptingProtocol.requestInterceptors {
            if requestInterceptor.canInterceptRequest(request){
                requestInterceptor.interceptRequest(request)
            }
        }
    }

    class func registerRequestInterceptor(interceptor: RequestInterceptorType) {
        requestInterceptors.append(interceptor)
    }
   
    class func registerResponseInterceptor(interceptor: ResponseInterceptorType) {
        responseInterceptors.append(interceptor)
    }
    
    class func unregisterRequestInterceptor(interceptor: RequestInterceptorType) {
        //TODO - implementation
    }
    
    class func unregisterResponseInterceptor(interceptor: ResponseInterceptorType) {
        //TODO - implementation
    }
}
