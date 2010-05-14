//
//  RSTabController.m
//  Resale
//
//  Created by A Jesse Jiryu Davis on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RSTabController.h"



///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RSTabController

- (id) init {
	if (self = [super init]) {
		[self setTabURLs:[NSArray arrayWithObjects:
						   @"resale://create_post",
						   @"resale://search_posts",
						   @"resale://user_posts",
						   // TODO: next version
						   //@"resale://tabs/chat",
						   nil]];
		 }
	
	return self;
}

@end

