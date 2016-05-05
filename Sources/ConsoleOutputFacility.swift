//
// ConsoleOutputFacility.swift
//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation

/// An output facility which outputs requests, responses and errors to console.
@objc(RDTConsoleOutputFacility) public final class ConsoleOutputFacility: NSObject, OutputFacility {
	
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
	/// - SeeAlso: OutputFacility.outputRequestRepresentation
	public func outputRequestRepresentation(request: RequestRepresentation) {
		let headers = request.headers.reduce([]) {
			return $0 + ["\($1.0): \($1.1)"]
		}
		let body = request.deserializedBody.map {
			$0.characters.split { $0 == "\n" }.map(String.init)
		} ?? ["<none>"]
		printBoxString(title: "<\(request.identifier)> [REQUEST] \(request.method) \(request.URLString)", sections: [
			("Headers", headers),
			("Body", body),
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
	/// - SeeAlso: OutputFacility.outputResponseRepresentation
	public func outputResponseRepresentation(response: ResponseRepresentation) {
		let headers = response.headers.reduce([]) {
			return $0 + ["\($1.0): \($1.1)"]
		}
		let body = response.deserializedBody.map {
			$0.characters.split { $0 == "\n" }.map(String.init)
		} ?? ["<none>"]
		printBoxString(title: "<\(response.requestIdentifier)> [RESPONSE] \(response.statusCode) (\(response.statusString.uppercaseString)) \(response.URLString)", sections: [
			("Headers", headers),
			("Body", body),
		])
	}
	
	/// Prints the error in the following format:
	///
	///     <0xbadf00d> [ERROR] NSURLErrorDomain -1009
	///      ├─ User Info
	///      │ NSLocalizedDescriptionKey: The device is not connected to the internet.
	///      │ NSURLErrorKey: https://httpbin.org/post
	///
	/// - SeeAlso: OutputFacility.outputErrorRepresentation
	public func outputErrorRepresentation(error: ErrorRepresentation) {
		let userInfo = error.userInfo.reduce([]) {
			return $0 + ["\($1.0): \($1.1)"]
		}
		printBoxString(title: "<\(error.requestIdentifier)> [ERROR] \(error.domain) \(error.code)", sections: [
			("User Info", userInfo),
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
	private func composeBoxString(title title: String, sections: [(String, [String])]) -> String {
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
	private func printBoxString(title title: String, sections: [(String, [String])]) {
		print(composeBoxString(title: title, sections: sections))
	}
	
}
