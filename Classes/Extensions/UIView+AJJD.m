//
//  UIView+AJJD.m
//  Star
//
//  Created by A Jesse Jiryu Davis on 2/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIView+AJJD.h"

@implementation UIView (AJJD)

- (void)addSubviewsToArray:(NSMutableArray*)array {
	for (UIView* subview in self.subviews) {
		// Depth first search
		[array addObject:subview];
		[subview addSubviewsToArray:array];
	}
}

// Traverse all subviews and return an array of them
- (NSArray*)allSubviews {
	NSMutableArray* rv = [NSMutableArray array];
	[self addSubviewsToArray:rv];
	return rv;
}

- (void)makeSubviewsPerformSelector:(SEL)aSelector {
	for (UIView* subview in self.allSubviews) {
		[subview performSelector:aSelector];
	}
}
@end
