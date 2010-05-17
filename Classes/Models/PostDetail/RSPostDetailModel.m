//
//  RSPostDetailModel.m
//  Resale
//  Adapted from http://github.com/klazuka/TTRemoteExamples
//
//  Created by A Jesse Jiryu Davis on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RSPostDetailModel.h"
#import "AppDelegate.h"


@interface RSPostDetailModel (private)

- (void)asyncGetPost;
- (void)didGetPost;

@end


@implementation RSPostDetailModel

@synthesize post=_post;

- (id)initWithShortCode:(NSString*)theShortCode {
	if (self = [super init]) {
		shortCode = [theShortCode retain];
	}
	
	return self;
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)ignored
{
	_loading = YES;
	[self didStartLoad];
	[self performSelectorInBackground:@selector(asyncGetPost) withObject:nil];
}

#pragma mark overrides

- (BOOL)isLoaded {
	return _loaded;
}

- (BOOL)isLoading {
	return _loading;
}

#pragma mark private
	 
- (void)asyncGetPost {
	NSAutoreleasePool* pool = [NSAutoreleasePool new];
	AppDelegate* appdel = (AppDelegate*)[UIApplication sharedApplication].delegate;
	self.post = [[appdel postForShortCode:shortCode] autorelease];
	[self performSelectorOnMainThread:@selector(didGetPost) withObject:nil waitUntilDone:NO];
	TT_RELEASE_SAFELY(pool);
}

- (void)didGetPost {
	_loading = NO;
	_loaded = YES;
	if (self.post) [self didFinishLoad];
	else {
		// TODO: use an error subclass whose localizedDescription is "Couldn't find post for shortCode"
		[self didFailLoadWithError:[NSError errorWithDomain:@"API" code:0 userInfo:nil]];
	}
}

	
#pragma mark -

- (void)dealloc {
	self.post = nil;
	TT_RELEASE_SAFELY(shortCode);
	[super dealloc];
}

@end
