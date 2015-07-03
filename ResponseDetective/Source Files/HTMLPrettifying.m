//
//  HTMLPrettifying.m
//
//  Created by Adrian Kashivskyy on 03.07.2015.
//

#import <libxml/tree.h>
#import <libxml/HTMLparser.h>
#import <libxml/HTMLtree.h>
#import "XMLPrettifying.h"

NSString * __nullable rdv_prettifyHTMLString(NSString * __nonnull string) {
	const char *memory = string.UTF8String;
	htmlDocPtr document = htmlReadMemory(memory, ((int)(strlen(memory))), NULL, NULL, HTML_PARSE_NOBLANKS);
	xmlChar *buffer = NULL; int bufferSize = 0;
	htmlDocDumpMemoryFormat(document, &buffer, &bufferSize, 1);
	NSString *result = [[NSString alloc] initWithBytes:buffer length:bufferSize encoding:NSUTF8StringEncoding];
	xmlFree(buffer);
	return result;
}
