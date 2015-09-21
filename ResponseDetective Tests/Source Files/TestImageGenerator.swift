//
//  TestImageGenerator.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

#if os(iOS)
	import UIKit
	private typealias OSImage = UIImage
#else
	import AppKit
	private typealias OSImage = NSImage
#endif

/// Generates test images.
internal struct TestImageGenerator {

	/// The image MIME type.
	internal enum TestImageType {
		case PNG
	}

	/// Platform-agnostic image size type.
	internal typealias TestImageSize = (width: Int, height: Int)

	/// Generates image data.
	///
	/// - parameter type: The type of the image.
	/// - parameter size: The image size.
	///
	/// - returns: Image data.
	internal static func generateImageData(type type: TestImageType, size: TestImageSize) -> NSData {
		#if os(iOS)
			switch type {
				case .PNG:
					return UIImagePNGRepresentation(generateImage(size: size))!
			}
		#else
			return Optional(generateImage(size: size)).flatMap({
				$0.TIFFRepresentation
			}).flatMap({
				NSBitmapImageRep(data: $0)
			}).flatMap({
				switch type {
					case .PNG:
						return $0.representationUsingType(NSBitmapImageFileType.NSPNGFileType, properties: [
							NSImageCompressionFactor: 1
						])
				}
			})!
		#endif
	}

	/// Creates an image with a black background.
	///
	/// - parameter size: The size of the image.
	///
	/// - returns: The generated image.
	private static func generateImage(size size: TestImageSize) -> OSImage {
		#if os(iOS)
			let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
			UIGraphicsBeginImageContext(bounds.size)
			let context = UIGraphicsGetCurrentContext()
			CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
			CGContextFillRect(context, bounds)
			let image = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			return image
		#else
			let bounds = NSRect(x: 0, y: 0, width: size.width, height: size.height)
			let image = NSImage(size: bounds.size)
			image.lockFocus()
			NSColor.blackColor().drawSwatchInRect(bounds)
			image.unlockFocus()
			return image
		#endif
	}

}
