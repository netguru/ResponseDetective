//
// ConsoleOutputFacility.swift
//
// Copyright © 2016-2017 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation

/// An output facility which outputs requests, responses and errors to console.
@objc(RDTConsoleOutputFacility) public final class ConsoleOutputFacility: NSObject, OutputFacility {

	// MARK: Initializers
	
	/// Initializes the receiver with default print closure.
	public convenience override init() {
		self.init(printClosure: { print($0) })
	}

	/// Initializes the receiver.
	///
	/// - Parameters:
	///     - printClosure: The print closure used to output strings into the
	///       console.
	@objc(initWithPrintBlock:) public init(printClosure: @escaping @convention(block) (String) -> Void) {
		self.printClosure = printClosure
	}

	// MARK: Properties

	/// Print closure used to output strings into the console.
	private let printClosure: @convention(block) (String) -> Void

	// MARK: OutputFacility

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
	/// - SeeAlso: OutputFacility.output(requestRepresentation:)
	public func output(requestRepresentation request: RequestRepresentation) {
		let headers = request.headers.reduce([]) {
			$0 + ["\($1.0): \($1.1)"]
		}
		let body = request.deserializedBody.map {
			#if swift(>=3.2)
				return $0.split { $0 == "\n" }.map(String.init)
			#else
				return $0.characters.split { $0 == "\n" }.map(String.init)
			#endif
		} ?? ["<none>"]
		printBoxString(title: "<\(request.identifier)> [REQUEST] \(request.method) \(request.urlString)", sections: [
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
	/// - SeeAlso: OutputFacility.output(responseRepresentation:)
	public func output(responseRepresentation response: ResponseRepresentation) {
		let headers = response.headers.reduce([]) {
			$0 + ["\($1.0): \($1.1)"]
		}
		let body = response.deserializedBody.map {
			#if swift(>=3.2)
				return $0.split { $0 == "\n" }.map(String.init)
			#else
				return $0.characters.split { $0 == "\n" }.map(String.init)
			#endif
		} ?? ["<none>"]
		printBoxString(title: "<\(response.requestIdentifier)> [RESPONSE] \(response.statusCode) (\(response.statusString.uppercased())) \(response.urlString)", sections: [
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
	/// - SeeAlso: OutputFacility.output(errorRepresentation:)
	public func output(errorRepresentation error: ErrorRepresentation) {
		let userInfo = error.userInfo.reduce([]) {
			$0 + ["\($1.0): \($1.1)"]
		}
		printBoxString(title: "<\(error.requestIdentifier)> [ERROR] \(error.domain) \(error.code)", sections: [
			("User Info", userInfo),
		])
	}

	// MARK: Printing boxes
	
	/// Composes a box string in the following format:
	///
	///     box title
	///      ├─ section title
	///      │ section
	///      │ contents
	///
	/// - Parameters:
	///     - title: The title of the box
	///     - sections: A dictionary with section titles as keys and content
	///       lines as values.
	///
	/// - Returns: A composed box string.
	private func composeBoxString(title: String, sections: [(String, [String])]) -> String {
		return "\(title)\n" + sections.reduce("") {
			"\($0) ├─ \($1.0)\n" + $1.1.reduce("") {
				"\($0) │ \($1)\n"
			}
		}
	}
	
	/// Composes and prints the box sting in the console.
	///
	/// - Parameters:
	///     - title: The title of the box
	///     - sections: A dictionary with section titles as keys and content
	///       lines as values.
	private func printBoxString(title: String, sections: [(String, [String])]) {
		printClosure(composeBoxString(title: title, sections: sections))
	}
	
}
