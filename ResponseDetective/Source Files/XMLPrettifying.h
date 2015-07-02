//
//  XMLPrettifying.h
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

@import Foundation;

/// Actually prettifies the XML string.
///
/// @param string The XML string to prettify.
///
/// @returns The prettified XML string.
extern NSString * __nullable rdv_prettifyXMLString(NSString * __nonnull string);
