//
// RDTBodyDeserializer.h
//
// Copyright © 2016-2017 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//
// This has been implemented as native Objective-C protocol instead of a Swift
// protocol bridged to Objective-C because Swift protocol definition cannot be
// imported in Objective-C header since it causes include cycle in the umbrella
// header.

@import Foundation;

/// Represents a body deserializer which is able to deserialize raw body data
/// into a human-readable string which will be logged as the request's or
/// response's body.
NS_SWIFT_NAME(BodyDeserializer) @protocol RDTBodyDeserializer

@required

/// Deserializes the body.
///
/// @param body The HTTP body.
///
/// @return A deserialized representation of the body.
- (nullable NSString *)deserializeBody:(nonnull NSData *)body NS_SWIFT_NAME(deserialize(body:));

@end
