//
//  HTMLPrettifying.h
//  
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

@import Foundation;

/// Actually prettifies the HTML string.
///
/// @param string The HTML string to prettify.
///
/// @returns The prettified HTML string.
extern NSString * __nullable rdv_prettifyHTMLString(NSString * __nonnull string);
