//
// ImageBodyDeserializer.swift
//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

#if os(iOS) || os(tvOS) || os(watchOS)
	import UIKit
	private typealias PlatformImage = UIImage
#elseif os(OSX)
	import AppKit
	private typealias PlatformImage = NSImage
#else
	// Is this carOS? :trollface:
#endif

/// Deserializes image bodies.
@objc(RDTImageBodyDeserializer) public final class ImageBodyDeserializer: NSObject, BodyDeserializer {
	
	/// Deserializes image data into a pretty-printed string.
	public func deserializeBody(body: NSData) -> String? {
		return PlatformImage(data: body).map { "(\($0.size.width)px × \($0.size.height)px" }
	}
	
}
