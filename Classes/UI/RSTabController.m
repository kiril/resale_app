//
//  RSTabController.m
//  Resale
//
//  Created by A Jesse Jiryu Davis on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RSTabController.h"
#import "Three20UI/UITabBarControllerAdditions.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RSTabController

- (void)viewDidLoad {
	[self setTabURLs:[NSArray arrayWithObjects:
										@"resale://create_post",
										// TODO: next version
										//@"resale://search_posts",
										@"resale://user_posts",
										// TODO: next version
										//@"resale://tabs/chat",
										nil]];
}

@end

