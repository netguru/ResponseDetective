//
// ResponseDetective.swift
//
// Copyright © 2016-2017 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation

/// ResponseDetective configuration cluster class that defines the behavior
/// of request interception and logging.
@objc(RDTResponseDetective) public final class ResponseDetective: NSObject {

	// MARK: Properties
	
	/// An output facility for reporting requests, responses and errors.
	public static var outputFacility: OutputFacility = ConsoleOutputFacility()
	
	/// A class of the URL protocol used to intercept requests.
	public static let URLProtocolClass: Foundation.URLProtocol.Type = URLProtocol.self
	
	/// A storage for request predicates.
	private static var requestPredicates: [NSPredicate] = []

	/// Body deserializers stored by a supported content type.
	private static var customBodyDeserializers: [String: BodyDeserializer] = [:]

	/// Default body deserializers provided by ResponseDetective.
	private static let defaultBodyDeserializers: [String: BodyDeserializer] = [
		"*/json": JSONBodyDeserializer(),
		"*/xml": XMLBodyDeserializer(),
		"*/html": HTMLBodyDeserializer(),
		"*/x-www-form-urlencoded": URLEncodedBodyDeserializer(),
		"image/*": ImageBodyDeserializer(),
		"text/*": PlaintextBodyDeserializer(),
	]

	// MARK: Configuration
	
	/// Resets the ResponseDetective mutable state.
	public static func reset() {
		outputFacility = ConsoleOutputFacility()
		requestPredicates = []
		customBodyDeserializers = [:]
	}

	/// Enables ResponseDetective in an URL session configuration.
	///
	/// - Parameters:
	///     - configuration: The URL session configuration to enable the
	///       session in.
	@objc(enableInConfiguration:) public static func enable(inConfiguration configuration: URLSessionConfiguration) {
		configuration.protocolClasses?.insert(URLProtocolClass, at: 0)
	}
	
	/// Ignores requests matching the given predicate. The predicate will be
	/// evaluated with an instance of NSURLRequest.
	///
	/// - Parameters:
	///     - predicate: A predicate for matching a request. If the
	///       predicate evaluates to `false`, the request is not intercepted.
	@objc(ignoreRequestsMatchingPredicate:) public static func ignoreRequests(matchingPredicate predicate: NSPredicate) {
		requestPredicates.append(predicate)
	}

	/// Checks whether the given request can be incercepted.
	///
	/// - Parameters:
	///     - request: The request to check.
	///
	/// - Returns: `true` if request can be intercepted, `false` otherwise.
	@objc(canInterceptRequest:) public static func canIncercept(request: URLRequest) -> Bool {
		return requestPredicates.reduce(true) {
			return $0 && !$1.evaluate(with: request)
		}
	}

	// MARK: Deserialization

	/// Registers a body deserializer.
	///
	/// - Parameters:
	///     - deserializer: The deserializer to register.
	///     - contentType: The supported content type.
	@objc(registerBodyDeserializer:forContentType:) public static func registerBodyDeserializer(_ deserializer: BodyDeserializer, forContentType contentType: String) {
		customBodyDeserializers[contentType] = deserializer
	}
	
	/// Registers a body deserializer.
	///
	/// - Parameters:
	///     - deserializer: The deserializer to register.
	///     - contentTypes: The supported content types.
	@objc(registerBodyDeserializer:forContentTypes:) public static func registerBodyDeserializer(_ deserializer: BodyDeserializer, forContentTypes contentTypes: [String]) {
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
	///   deserializing body with the given content type.
	@objc(deserializeBody:contentType:) public static func deserialize(body: Data, contentType: String) -> String? {
		if let deserializer = findBodyDeserializer(forContentType: contentType) {
			return deserializer.deserialize(body: body)
		} else {
			return nil
		}
	}

	/// Finds a body deserializer by pattern.
	///
	/// - Parameters:
	///     - contentType: The content type to find a deserializer for.
	///
	/// - Returns: A body deserializer for given `contentType` or `nil`.
	@objc(findBodyDeserializerForContentType:) private static func findBodyDeserializer(forContentType contentType: String) -> BodyDeserializer? {
		guard let trimmedContentType = contentType.components(separatedBy: ";").first?.trimmingCharacters(in: .whitespaces) else {
			return nil
		}
		for (pattern, deserializer) in defaultBodyDeserializers.appending(elementsOf: customBodyDeserializers) {
			let patternParts = pattern.components(separatedBy: "/")
			let actualParts = trimmedContentType.components(separatedBy: "/")
			guard patternParts.count == 2 && actualParts.count == 2 else {
				return nil
			}
			if ["*" , actualParts[0]].contains(patternParts[0]) && ["*" , actualParts[1]].contains(patternParts[1]) {
				return deserializer
			}
		}
		return nil
	}

}
