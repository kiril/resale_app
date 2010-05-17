//
//  RSStylesheet.m
//  Resale
//
//  Created by A Jesse Jiryu Davis on 5/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RSStylesheet.h"
#import "Constants.h"

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation RSStylesheet

@synthesize imageStyle=_imageStyle;

- (id)init {
	if (self = [super init]) {
		_imageStyle = [[TTImageStyle styleWithImage:nil
									   defaultImage:TTIMAGE(@"bundle://photo_placeholder.png")
										contentMode:UIViewContentModeScaleAspectFill
											   size:CGSizeMake(320, imageHeightFull)
											   next:nil] retain];
	}
	
	return self;
}

#pragma mark -

- (void)dealloc {
	TT_RELEASE_SAFELY(_imageStyle);
	[super dealloc];
}

@end