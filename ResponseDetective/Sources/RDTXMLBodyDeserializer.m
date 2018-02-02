//
// RDTXMLBodyDeserializer.m
//
// Copyright © 2016-2017 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

#import <libxml/tree.h>
#import <libxml/parser.h>
#import "RDTXMLBodyDeserializer.h"

@implementation RDTXMLBodyDeserializer

// MARK: RDTBodyDeserializer

- (nullable NSString *)deserializeBody:(nonnull NSData *)body {
	NSString *string = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
	const char *memory = string.UTF8String;
	xmlDocPtr document = xmlReadMemory(memory, ((int)(strlen(memory))), NULL, NULL, XML_PARSE_NOCDATA | XML_PARSE_NOBLANKS);
	xmlChar *buffer = NULL;
	int bufferLength = 0;
	xmlDocDumpFormatMemory(document, &buffer, &bufferLength, 1);
	NSString *result = [[NSString alloc] initWithBytes:buffer length:bufferLength encoding:NSUTF8StringEncoding];
	xmlFree(buffer);
	return [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
