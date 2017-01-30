//
// ImageBodyDeserializer.swift
//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

#if os(iOS) || os(tvOS) || os(watchOS)
	import UIKit
#elseif os(OSX)
	import AppKit
#endif

/// Deserializes image bodies.
@objc(RDTImageBodyDeserializer) public final class ImageBodyDeserializer: NSObject, BodyDeserializer {

	#if os(iOS) || os(tvOS) || os(watchOS)
		private typealias Image = UIImage
	#elseif os(OSX)
		private typealias Image = NSImage
	#endif
	
	/// Deserializes image data into a pretty-printed string.
	public func deserializeBody(_ body: Data) -> String? {
		return Image(data: body).map { "\(Int($0.size.width))px × \(Int($0.size.height))px image" }
	}
	
}
