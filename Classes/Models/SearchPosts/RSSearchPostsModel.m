//
//  RSSearchPostsModel.m
//  Resale
//  Adapted from http://github.com/klazuka/TTRemoteExamples
//
//  Created by A Jesse Jiryu Davis on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RSSearchPostsModel.h"
#import "extThree20JSON/TTURLJSONResponse.h"
#import "NSDictionary+CGI.h"
#import "AppDelegate.h"

@interface RSSearchPostsModel (private)

- (void)cachePostsByShortCode;

@end


@implementation RSSearchPostsModel

@synthesize results=_results;

- (id)initWithLocation:(CLLocationCoordinate2D)coordinate query:(NSString*)query {
	if (self = [super init]) {
		_coordinate = coordinate;
		_query = [query retain];
	}
	
	return self;
}



- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
	// TODO: respect 'more' argument
	_loading = YES;
	
	TTURLRequest *request =
	[TTURLRequest requestWithURL:@"http://localhost:8001/post/search?" delegate:self];
	
	// TTURLRequest claims to use its 'parameters' property for CGI parameters in
	// a GET request, but in fact they only work for POST
	NSMutableDictionary* cgiParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									  [NSNumber numberWithFloat:_coordinate.latitude], @"lat",
									  [NSNumber numberWithFloat:_coordinate.longitude], @"long",
									  nil];
	
	if (_query) [cgiParams setObject:_query forKey:@"query"];
	
	request.urlPath = [request.urlPath stringByAppendingString:[cgiParams urlEncodedString]];
	// TODO: nicely manage cache policy
	request.cachePolicy = TTURLRequestCachePolicyNoCache;
	request.response = [[[TTURLJSONResponse alloc] init] autorelease];
	request.httpMethod = @"GET";
	[request send];
}


- (void)reset {
	self.results = nil;
	TT_RELEASE_SAFELY(_query);
	_coordinate.latitude = _coordinate.longitude = 0;
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
	TTURLJSONResponse *response = request.response;
	NSDictionary* rootObject = response.rootObject;
	
	// TODO: refactor error handling
	if ( ! [[rootObject objectForKey:@"result"] isEqualToString:@"OK"]) {
		TTAlert([NSString stringWithFormat:@"Server error: %@", [rootObject objectForKey:@"message"]]);
		return;
	}
	
	self.results = [rootObject objectForKey:@"posts"];
	
	_loading = NO;
	_loaded = YES;  
	
	[self cachePostsByShortCode];
	[super requestDidFinishLoad:request];
}

#pragma mark private

- (void)cachePostsByShortCode {
	AppDelegate* appdel = (AppDelegate*)[UIApplication sharedApplication].delegate;
	for (id post in self.results) {
		if ([post isKindOfClass:[NSDictionary class]]) {
			NSString* shortCode = [post objectForKey:@"short_code"];
			[appdel cachePost:post forShortCode:shortCode];
		}
	}
}
	
#pragma mark -

- (void)dealloc {
	self.results = nil;
	TT_RELEASE_SAFELY(_query);
	[super dealloc];
}

@end
