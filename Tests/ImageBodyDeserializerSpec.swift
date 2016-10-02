//
// ImageBodyDeserializerSpec.swift
//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation
import Nimble
import ResponseDetective
import Quick

internal final class ImageBodyDeserializerSpec: QuickSpec {

	override func spec() {

		describe("ImageBodyDeserializer") {

			let sut = ImageBodyDeserializer()

			it("should correctly deserialize image data") {
				let source = swatchImage(size: (width: 100, height: 200))
				let data = imageData(image: source)
				let expected = "100px × 200px image"
				expect { sut.deserializeBody(data) }.to(equal(expected))
			}

		}

	}
	
}

// MARK: -

#if os(iOS) || os(tvOS) || os(watchOS)
	import UIKit
	private typealias Image = UIImage
#elseif os(OSX)
	import AppKit
	private typealias Image = NSImage
#endif

private func swatchImage(size size: (width: Int, height: Int)) -> Image {
	#if os(iOS) || os(tvOS) || os(watchOS)
		let rect = CGRect(x: 0, y: 0, width: CGFloat(size.width), height: CGFloat(size.height))
		UIGraphicsBeginImageContext(rect.size)
		let context = UIGraphicsGetCurrentContext()!
		CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
		CGContextFillRect(context, rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return image.imageWithRenderingMode(.AlwaysOriginal)
	#elseif os(OSX)
		let rect = NSMakeRect(0, 0, CGFloat(size.width), CGFloat(size.height))
		let image = NSImage(size: rect.size)
		image.lockFocus()
		NSColor.blackColor().drawSwatchInRect(rect)
		image.unlockFocus()
		return image
	#endif
}

private func imageData(image image: Image) -> NSData {
	#if os(iOS) || os(tvOS) || os(watchOS)
		return UIImageJPEGRepresentation(image, 1)!
	#elseif os(OSX)
		return NSBitmapImageRep(data: image.TIFFRepresentation!)!.representationUsingType(.JPEG, properties: [NSImageCompressionFactor: 1])!
	#endif
}
