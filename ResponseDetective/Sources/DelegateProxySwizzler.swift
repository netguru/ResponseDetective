//
// DelegateProxySwizzler.swift
//
// Copyright © 2017 Netguru. All rights reserved.
// Licensed under the MIT License.
//
// Inspired by ReactiveCocoa.
//

import Foundation
import ObjectiveC

/// A singleton object that manages swizzling of `URLSession.delegate` on
/// concrete instances or whole classes of `URLSession`.
internal final class DelegateProxySwizzler {

    // MARK: Initializers

    /// A global instance of `DelegateProxySwizzler`.
    internal static let global = DelegateProxySwizzler()

    /// Initialize an instance.
    private init() {}

}
