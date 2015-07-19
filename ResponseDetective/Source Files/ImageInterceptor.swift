//
//  ImageInterceptor.swift
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

/// Intercepts image responses.
public final class ImageInterceptor {

	/// The output stream used by the interceptor.
	public private(set) var outputStream: OutputStreamType

	// MARK: Initialization

	/// Initializes the interceptor with a output stream.
	///
	/// :param: outputStream The output stream to be used.
	public init(outputStream: OutputStreamType) {
		self.outputStream = outputStream
	}

	/// Initializes the interceptor with a Println output stream.
	public convenience init() {
		self.init(outputStream: PrintlnOutputStream())
	}

	// MARK: Metadata extraction

	/// Extracts the metadata out of the image.
	///
	/// :param: image An image from which to extract metadata.
	///
	/// :returns: A metadata string.
	private func extractMetadataFromImage(contentType: String, _ image: OSImage) -> String {
		return "\(contentType) (\(Int(image.size.width))px × \(Int(image.size.height))px)"
	}

	/// Extracts the metadata out of the image data.
	///
	/// :param: data Image data from which to extract metadata.
	///
	/// :returns: A metadata string.
	private func extractMetadataFromImageData(contentType: String, _ data: NSData) -> String? {
		return map(flatMap(data, {
			#if os(iOS)
				return UIImage(data: $0)
			#else
				return NSImage(data: $0)
			#endif
		}), {
			return self.extractMetadataFromImage(contentType, $0)
		})
	}

}

// MARK: -

extension ImageInterceptor: ResponseInterceptorType {

	// MARK: ResponseInterceptorType implementation

	public func canInterceptResponse(response: ResponseRepresentation) -> Bool {
		return map(response.contentType) {
			(($0 as NSString).substringToIndex(6) as String) == "image/"
		} ?? false
	}

	public func interceptResponse(response: ResponseRepresentation) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			if let contentType = response.contentType, metadataString = flatMap(response.bodyData, {
				self.extractMetadataFromImageData(contentType, $0)
		    }) {
				dispatch_async(dispatch_get_main_queue()) {
					self.outputStream.write(metadataString)
				}
			}
		}
	}
	
}
