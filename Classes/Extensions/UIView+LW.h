//
//  UIView+LW.h
//  Christies
//
//  Created by Lawrence Wang on 5/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIView (LW)

- (void)placeAfterView:(UIView*)prev offset:(CGPoint)offset;
- (void)reposition:(CGPoint)newOrigin;
- (void)centerInSuperview;
- (void)move:(CGPoint)delta;
- (void)resize:(CGSize)newSize;
- (void)resizeToFitLastSubview:(UIView*)subview padding:(CGSize)padding;
- (void)addSubviewsAsCenteredColumn:(UIView*)firstSubview, ... NS_REQUIRES_NIL_TERMINATION;

@end
