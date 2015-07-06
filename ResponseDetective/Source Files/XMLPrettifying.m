//
//  XMLPrettifying.m
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import <libxml/tree.h>
#import "XMLPrettifying.h"

NSString * __nullable rdv_prettifyXMLString(NSString * __nonnull string) {
	const char *memory = string.UTF8String;
	xmlDocPtr document = xmlReadMemory(memory, ((int)(strlen(memory))), NULL, NULL, XML_PARSE_NOCDATA | XML_PARSE_NOBLANKS);
	xmlChar *buffer = NULL;
	int bufferLength = 0;
	xmlDocDumpFormatMemory(document, &buffer, &bufferLength, 1);
	NSString *result = [[NSString alloc] initWithBytes:buffer length:bufferLength encoding:NSUTF8StringEncoding];
	xmlFree(buffer);
	return result;
}
