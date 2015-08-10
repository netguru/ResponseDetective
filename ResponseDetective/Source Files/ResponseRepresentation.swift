//
//  ResponseRepresentation.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/// Represents a response.
@objc(RDVResponseRepresentation) public final class ResponseRepresentation {

	/// Response status code.
	public let statusCode: Int

	/// Response status string.
	public var statusString: String {
		return NSHTTPURLResponse.localizedStringForStatusCode(statusCode).uppercaseString as String
	}

	/// Response URL.
	public let url: String

	/// Response headers
	public let headers: [String: String]

	/// Response content type.
	public var contentType: String? {
		return map(map(headers["Content-Type"], {
			$0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
		}), {
			$0.substringToIndex($0.rangeOfString(";")?.endIndex ?? $0.endIndex)
		})
	}

	/// Response body data.
	public let bodyData: NSData?

	/// Response body UTF-8 string.
	public var bodyUTF8String: String? {
		return flatMap(bodyData) { NSString(data: $0, encoding: NSUTF8StringEncoding) } as String?
	}

	/// Initializes the receiver with an instance of NSHTTPURLResponse.
	///
	/// :param: response The foundation NSHTTPURLResponse object.
	/// :param: data The data associated with the response.
	///
	/// :returns: An initialized receiver or nil if an instance should not be
	/// created using the given response.
	public init?(_ response: NSHTTPURLResponse, _ data: NSData?) {
		if let url = response.URL?.absoluteString {
			self.statusCode = response.statusCode
			self.url = url
			self.headers = reduce(response.allHeaderFields, [:]) { (var initial, element) in
				if let key = element.0 as? String, value = element.1 as? String {
					initial[key] = value
				}
				return initial
			}
			self.bodyData = data
		} else {
			self.statusCode = Int()
			self.url = String()
			self.headers = Dictionary()
			self.bodyData = nil
			return nil
		}
	}

}

// MARK: -

extension ResponseRepresentation: Printable {

	public var description: String {
		return "\(statusCode) \(statusString)"
	}

}
