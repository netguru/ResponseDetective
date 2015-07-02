//
//  XMLPrettifying.m
//
//  Created by Adrian Kashivskyy on 02.07.2015.
//

#import <libxml/tree.h>
#import "XMLPrettifying.h"

NSString * __nullable rdv_prettifyXMLString(NSString * __nonnull string) {
	xmlNodePtr rootNode = ^{
		const char *cString = string.UTF8String;
		xmlDocPtr document = xmlReadMemory(cString, ((int)(strlen(cString))), NULL, NULL, XML_PARSE_NOCDATA | XML_PARSE_NOBLANKS);
		xmlNodePtr rootNode = xmlDocGetRootElement(document);
		xmlNodePtr recursiveRootNode = xmlCopyNode(rootNode, 1);
		xmlFreeDoc(document);
		return recursiveRootNode;
	}();
	xmlBufferPtr buffer = xmlBufferCreate();
	int result = xmlNodeDump(buffer, NULL, rootNode, 0, 1);
	NSString *prettyString = (result > -1) ? ^{
		return [[NSString alloc]
			initWithBytes:xmlBufferContent(buffer)
			length:((NSUInteger)(xmlBufferLength(buffer)))
			encoding:NSUTF8StringEncoding
		];
	}() : nil;
	xmlBufferFree(buffer);
	return [prettyString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
