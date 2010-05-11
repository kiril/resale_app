//
//  UIView+LW.m
//  Christies
//
//  Created by Lawrence Wang on 5/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIView+LW.h"


@implementation UIView (LW)

- (void)placeAfterView:(UIView*)prev offset:(CGPoint)offset {
	CGRect frame = CGRectMake(prev.frame.origin.x + offset.x, 
							  prev.frame.origin.y + prev.frame.size.height + offset.y,
							  self.frame.size.width, self.frame.size.height);
	self.frame = frame;
}

- (void)reposition:(CGPoint)newOrigin {
	CGRect frame = self.frame;
	frame.origin = newOrigin;
	self.frame = frame;
}

- (void)centerInSuperview {
	CGSize superSize = self.superview.bounds.size;
	self.center = CGPointMake(superSize.width/2, superSize.height/2);
}

- (void)move:(CGPoint)delta {
	CGRect frame = self.frame;
	frame.origin = CGPointMake(frame.origin.x + delta.x, frame.origin.y + delta.y);
	self.frame = frame;
}

- (void)resize:(CGSize)newSize {
	CGRect frame = self.frame;
	frame.size = newSize;
	self.frame = frame;
}

- (void)resizeToFitLastSubview:(UIView*)subview padding:(CGSize)padding {
	CGRect frame = self.frame;
	CGRect subframe = subview.frame;
	frame.size = CGSizeMake(MIN(320, subframe.origin.x + subframe.size.width + padding.width),
							subframe.origin.y + subframe.size.height + padding.height);
	self.frame = frame;
}

- (void)addSubviewsAsCenteredColumn:(UIView*)firstSubview, ... {
	CGRect bounds = self.bounds;
	UIView* subview;
	va_list args, args2;
	int totalHeight = 0;
	if (firstSubview) {
		// find the total height and center horizontally
		[self addSubview:firstSubview];
		[firstSubview centerInSuperview];
		totalHeight += firstSubview.frame.size.height;
		va_start(args, firstSubview);
		va_copy(args2, args);
		while (subview = va_arg(args, UIView*)) {
			[self addSubview:subview];
			[subview centerInSuperview];
			totalHeight += subview.frame.size.height;
		}
		va_end(args);
		// then center vertically
		int ypos = bounds.size.height / 2 - totalHeight / 2;
		CGRect frame = firstSubview.frame;
		[firstSubview reposition:CGPointMake(frame.origin.x, ypos)];
		ypos += frame.size.height;
		while (subview = va_arg(args2, UIView*)) {
			frame = subview.frame;
			[subview reposition:CGPointMake(frame.origin.x, ypos)];
			ypos += frame.size.height;
		}
		va_end(args2);
	}
}

@end
