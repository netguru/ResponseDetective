//
//  Protocol.swift
//  ResponseDetective
//
//  Created by Aleksander Popko on 08.06.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

typealias RemovalToken = Int

public final class InterceptingProtocol: NSURLProtocol {
    
    private static var requestInterceptors: [RemovalToken : RequestInterceptorType] = [:]
    private static var responseInterceptors: [RemovalToken : ResponseInterceptorType] = [:]
    
    private var session = NSURLSession.sharedSession()

    override public func startLoading() {
        
        for (removalToken,requestInterceptor) in InterceptingProtocol.requestInterceptors {
            if requestInterceptor.canInterceptRequest(request) {
                requestInterceptor.interceptRequest(request)
            }
        }
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                if let httpResponse = response as? NSHTTPURLResponse {
                    for (removalToken,responseInterceptor) in InterceptingProtocol.responseInterceptors {
                        if responseInterceptor.canInterceptResponse(httpResponse){
                            responseInterceptor.interceptResponseError(error)
                        }
                    }
                }
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    for (removalToken,responseInterceptor) in InterceptingProtocol.responseInterceptors {
                        if responseInterceptor.canInterceptResponse(httpResponse){
                            responseInterceptor.interceptResponse(httpResponse, data)
                        }
                    }
                }}})
        
        task.resume()
        
        for (removalToken,requestInterceptor) in InterceptingProtocol.requestInterceptors {
            if requestInterceptor.canInterceptRequest(request) {
                requestInterceptor.interceptRequest(request)
            }
        }
    }

    class func registerRequestInterceptorWithRemovalToken(interceptor: RequestInterceptorType, token: RemovalToken) {
        requestInterceptors[token] = interceptor
    }
   
    class func registerResponseInterceptorWithRemovalToken(interceptor: ResponseInterceptorType, token: RemovalToken) {
        responseInterceptors[token] = interceptor
    }
    
    class func unregisterRequestInterceptorAtToken(token: RemovalToken) {
        responseInterceptors[token] = nil
    }
    
    class func unregisterResponseInterceptorAtToken(token: RemovalToken) {
        responseInterceptors[token] = nil
    }
}
