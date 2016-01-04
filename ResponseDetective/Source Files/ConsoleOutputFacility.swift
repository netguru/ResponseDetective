//
//  ConsoleOutputFacility.swift
//
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//
//  Licensed under the MIT License.
//

import Foundation

/// An output facility which outputs requests, responses and errors to console.
@objc(RDVConsoleOutputFacility) public final class ConsoleOutputFacility: NSObject, OutputFacility {
	
	/// Prints the request in the following format:
	///
	///     <0xbadf00d> [REQUEST] POST https://httpbin.org/post
	///      ├─ Headers
	///      │ Content-Type: application/json
	///      │ Content-Length: 14
	///      ├─ Body
	///      │ {
	///      │   "foo": "bar"
	///      │ }
	///
	/// - Parameters:
	///     - request: The request to print.
	public func outputRequestRepresentation(request: RequestRepresentation) {
		printBoxString(title: "<\(request.identifier)> [REQUEST] \(request.method) \(request.URLString)", sections: [
			"Headers": request.headers.reduce([]) {
				return $0 + ["\($1.0): \($1.1)"]
			}
		])
	}
	
	/// Prints the response in the following format:
	///
	///     <0xbadf00d> [RESPONSE] 200 (NO ERROR) https://httpbin.org/post
	///      ├─ Headers
	///      │ Content-Type: application/json
	///      │ Content-Length: 24
	///      ├─ Body
	///      │ {
	///      │   "args": {},
	///      │   "headers": {}
	///      │ }
	///
	/// - Parameters:
	///     - response: The response to print.
	public func outputResponseRepresentation(response: ResponseRepresentation) {
		printBoxString(title: "<\(response.requestIdentifier)> [RESPONSE] \(response.statusCode) (\(response.statusString.uppercaseString)) \(response.URLString)", sections: [
			"Headers": response.headers.reduce([]) {
				return $0 + ["\($1.0): \($1.1)"]
			}
		])
	}
	
	/// Prints the error in the following format:
	///
	///     <0xbadf00d> [ERROR] NSURLErrorDomain -1009
	///      ├─ User Info
	///      │ NSLocalizedDescriptionKey: The device is not connected to the internet.
	///      │ NSURLErrorKey: https://httpbin.org/post
	///
	/// - Parameters:
	///     - response: The response to print.
	public func outputErrorRepresentation(error: ErrorRepresentation) {
		printBoxString(title: "<\(error.requestIdentifier)> [ERROR] \(error.domain) \(error.code)", sections: [
			"User Info": error.userInfo.reduce([]) {
				return $0 + ["\($1.0): \($1.1)"]
			}
		])
	}
	
	/// Composes a box string in the following format:
	///
	///     box title
	///      ├─ section title
	///      │ section
	///      │ contents
	///
	///
	/// - Parameters:
	///     - title: The title of the box
	///     - sections: A dictionary with section titles as keys and content
	///       lines as values.
	///
	/// - Returns: A composed box string.
	private func composeBoxString(title title: String, sections: [String: [String]]) -> String {
		return "\(title)\n" + sections.reduce("") {
			return "\($0) ├─ \($1.0)\n" + $1.1.reduce("") {
				return "\($0) │ \($1)\n"
			}
		}
	}
	
	/// Composes and prints the box sting in the console.
	///
	/// - Parameters:
	///     - title: The title of the box
	///     - sections: A dictionary with section titles as keys and content
	///       lines as values.
	private func printBoxString(title title: String, sections: [String: [String]]) {
		print(composeBoxString(title: title, sections: sections))
	}
	
}
