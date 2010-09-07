//
//  RSAPI.m
//  Resale
//
//  Created by A Jesse Jiryu Davis on 9/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RSAPI.h"
#import "extThree20JSON/NSObject+SBJSON.h"
#import "extThree20JSON/TTURLJSONResponse.h"


@implementation RSAPI

+ (NSURL*)APIURLWithPath:(NSString*)path {
	NSString* serverURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"resale_api_server_url"]; 
	return [[[NSURL alloc] initWithScheme:@"http" host:serverURL path:path] autorelease];
}

+ (TTURLRequest*)APIRequestWithPath:(NSString*)path delegate:(id)delegate {
	NSURL* url = [self APIURLWithPath:path];
	TTURLRequest* rv = [[[TTURLRequest alloc] initWithURL:url.absoluteString delegate:delegate] autorelease];
	rv.response = [[TTURLJSONResponse new] autorelease];
	return rv;
}

+ (TTURLRequest*)getAPIRequestWithPath:(NSString*)path delegate:(id)delegate {
	TTURLRequest* rv = [self APIRequestWithPath:path delegate:delegate];
	rv.httpMethod = @"GET";
	[rv send];
	return rv;	
}

+ (TTURLRequest*)postAPIRequestWithPath:(NSString*)path json:(NSDictionary*)json delegate:(id)delegate {
	TTURLRequest* rv = [self APIRequestWithPath:path delegate:delegate];
	NSString* jsonString = [json JSONRepresentation];
	rv.httpMethod = @"POST";
	[rv.parameters setObject:jsonString forKey:@"json"];
	[rv send];
	return rv;
}

@end
