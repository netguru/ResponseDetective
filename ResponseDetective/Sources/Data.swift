//
// Data.swift
//
// Copyright © 2016-2018 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import UIKit

internal extension Data {
	
	/// A human-readable description for the data.
	internal var description: String {
		if let image = UIImage(data: self) {
			return "\(Int(image.size.width))px × \(Int(image.size.height))px image"
		} else {
			return "unrecognizable \(count) bytes"
		}
	}
	
}
