//
//  NSDictionary+CGI.m
//  Resale
//  Format dictionary as CGI parameters
//  Adapted from http://stackoverflow.com/questions/718429/creating-url-query-parameters-from-nsdictionary-objects-in-objectivec
//
//  Created by A Jesse Jiryu Davis on 5/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+CGI.h"


// helper function: get the string form of any object
static NSString *toString(id object) {
	return [NSString stringWithFormat: @"%@", object];
}

// helper function: get the url encoded string form of any object
static NSString *urlEncode(id object) {
	NSString *string = toString(object);
	return [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}

@implementation NSDictionary (CGI)

- (NSString*)urlEncodedString {
	NSMutableArray *parts = [NSMutableArray array];
	for (id key in self) {
		id value = [self objectForKey: key];
		NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
		[parts addObject: part];
	}
	return [parts componentsJoinedByString: @"&"];
}

@end
