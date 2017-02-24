//
// ImageBodyDeserializer.swift
//
// Copyright © 2016-2017 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

#if os(iOS) || os(tvOS) || os(watchOS)
	import UIKit
#elseif os(OSX)
	import AppKit
#endif

/// Deserializes image bodies.
@objc(RDTImageBodyDeserializer) public final class ImageBodyDeserializer: NSObject, BodyDeserializer {

	// MARK: Nested types

	#if os(iOS) || os(tvOS) || os(watchOS)
		private typealias Image = UIImage
	#elseif os(OSX)
		private typealias Image = NSImage
	#endif

	// MARK: BodyDeserializer
	
	/// Deserializes image data into a pretty-printed string.
	public func deserialize(body: Data) -> String? {
		return Image(data: body).map { "\(Int($0.size.width))px × \(Int($0.size.height))px image" }
	}
	
}
