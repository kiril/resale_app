//
//  UIView+AJJD.h
//  Star
//
//  Created by A Jesse Jiryu Davis on 2/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIView (AJJD)

// Traverse all subviews and return an array of them
- (NSArray*)allSubviews;
- (void)makeSubviewsPerformSelector:(SEL)aSelector;

@end
