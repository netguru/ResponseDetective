//
//  RequestRepresentation.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/// Represents a request.
public struct RequestRepresentation {

	/// Request method.
	public let method: String

	/// Request URL string.
	public let url: String

	/// Request headers, represented by strings.
	public let headers: [String: String]

	/// Request content type.
	public var contentType: String? {
		return headers["Content-Type"]
	}

	/// Request body data.
	public let body: NSData?

	/// Request body UTF-8 string.
	public var bodyUTF8String: String? {
		return flatMap(body) { NSString(data: $0, encoding: NSUTF8StringEncoding) } as String?
	}

	/// Initializes the receiver with an instance of NSURLRequest.
	///
	/// :param: request The foundation NSSURLRequest object.
	///
	/// :returns: An initialized receiver or nil if an instance should not be
	/// created using the given request.
	public init?(request: NSURLRequest) {
		if let method = request.HTTPMethod, let url = request.URL?.absoluteString {
			self.method = method
			self.url = url
			self.headers = map(request.allHTTPHeaderFields) { headers in
				reduce(headers, [:]) { (var initial, element) in
					if let key = element.0 as? String, value = element.1 as? String {
						initial[key] = value
					}
					return initial
				}
			} ?? [:]
			self.body = request.HTTPBody?.copy() as! NSData?
		} else {
			return nil
		}
	}

}
