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

#if os(iOS) || os(tvOS) || os(watchOS)
	import UIKit
	typealias Image = UIImage
#elseif os(OSX)
	import AppKit
	typealias Image = NSImage
#endif

final class ImageBodyDeserializerSpec: QuickSpec {

	override func spec() {

		describe("ImageBodyDeserializer") {

			#if os(iOS) || os(tvOS) || os(watchOS)
				typealias Image = UIImage
			#elseif os(OSX)
				typealias Image = NSImage
			#endif

			func swatchImage(size size: (width: Int, height: Int)) -> Image {
				#if os(iOS) || os(tvOS) || os(watchOS)
					let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
					UIGraphicsBeginImageContext(rect.size)
					let context = UIGraphicsGetCurrentContext()
					CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
					CGContextFillRect(context, rect)
					let image = UIGraphicsGetImageFromCurrentImageContext()
					UIGraphicsEndImageContext()
					let renderedImage = image.imageWithRenderingMode(.AlwaysOriginal)
					return UIImage(data: UIImagePNGRepresentation(renderedImage)!)!
				#elseif os(OSX)
					let image = NSImage(size: NSMakeSize(CGFloat(size.width), CGFloat(size.height)))
					image.lockFocus()
					NSColor.blackColor().drawSwatchInRect(NSMakeRect(0, 0, CGFloat(size.width), CGFloat(size.height)))
					image.unlockFocus()
					return image
				#endif
			}

			func imageData(image image: Image) -> NSData {
				#if os(iOS) || os(tvOS) || os(watchOS)
					return UIImageJPEGRepresentation(image, 1)!
				#elseif os(OSX)
					return NSBitmapImageRep(data: image.TIFFRepresentation!)!.representationUsingType(.NSJPEGFileType, properties: [NSImageCompressionFactor: 1])!
				#endif
			}

			var sut: ImageBodyDeserializer! = nil

			beforeEach {
				sut = ImageBodyDeserializer()
			}

			it("should correctly deserialize image data") {
				let source = swatchImage(size: (width: 100, height: 200))
				let data = imageData(image: source)
				let expected = "100px × 200px image"
				expect { sut.deserializeBody(data) }.to(equal(expected))
			}

		}

	}
	
}
