//
//  ResponseDetective.swift
//
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//
//  Licensed under the MIT License.
//

import Foundation

@objc(RDVResponseDetective) public final class ResponseDetective: NSObject {
	
	/// Whether ResponseDetective is enabled.
	public static var enabled: Bool = false {
		didSet {
			if enabled {
				NSURLProtocol.registerClass(URLProtocolClass)
			} else {
				NSURLProtocol.unregisterClass(URLProtocolClass)
			}
		}
	}
	
	/// An output facility for reporting requests, responses and errors.
	public static var outputFacility: OutputFacility = ConsoleOutputFacility()
	
	/// A class of the URL protocol used to intercept requests.
	public static let URLProtocolClass: AnyClass = URLProtocol.self
	
	/// A storage for request predicates.
	private static var requestPredicates: [NSPredicate] = []
	
	/// Body deserializers stored by a supported content type.
	private static var bodyDeserializers: [String: BodyDeserializer] = [
		"application/json": JSONBodyDeserializer()
	]
	
	/// Resets the ResponseDetective mutable state.
	public static func reset() {
		enabled = false
		outputFacility = ConsoleOutputFacility()
		requestPredicates = []
	}
	
	/// Ignores requests matching the given predicate. The predicate will be
	/// evaluated with an instance of NSURLRequest.
	///
	/// - Parameters:
	///     - predicate: A predicate for matching a request. If the predicate
	///     evaluates to `false`, the request is not intercepted.
	public static func ignoreRequestsMatchingPredicate(predicate: NSPredicate) {
		requestPredicates.append(predicate)
	}
	
	/// Checks whether the given request can be incercepted.
	///
	/// - Parameters:
	///     - request: The request to check.
	///
	/// - Returns: `true` if request can be intercepted, `false` otherwise.
	public static func canIncerceptRequest(request: NSURLRequest) -> Bool {
		return enabled && requestPredicates.reduce(true) {
			return $0 && !$1.evaluateWithObject(request)
		}
	}
	
	/// Registers a body deserializer.
	///
	/// - Parameters:
	///     - deserializer: The deserializer to register.
	///     - contentType: The supported content type.
	public static func registerBodyDeserializer(deserializer: BodyDeserializer, forContentType contentType: String) {
		bodyDeserializers[contentType] = deserializer
	}
	
	/// Registers a body deserializer.
	///
	/// - Parameters:
	///     - deserializer: The deserializer to register.
	///     - contentTypes: The supported content types.
	public static func registerBodyDeserializer(deserializer: BodyDeserializer, forContentTypes contentTypes: [String]) {
		for contentType in contentTypes {
			registerBodyDeserializer(deserializer, forContentType: contentType)
		}
	}
	
	/// Deserializes a HTTP body into a string.
	///
	/// - Parameters:
	///     - body: The body to deserialize.
	///     - contentType: The content type of the body.
	///
	/// - Returns: A deserialized body or `nil` if no serializer is capable of
	/// deserializing body with the given content type.
	public static func deserializeBody(body: NSData, contentType: String) -> String? {
		if let deserializer = bodyDeserializers[contentType] {
			return deserializer.deserializeBody(body)
		} else {
			return nil
		}
	}
	
}
