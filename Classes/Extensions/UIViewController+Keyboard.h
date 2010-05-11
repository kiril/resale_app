//
//  UIViewController+Keyboard.h
//  Manage a scroll view so its text fields aren't hidden when the onscreen
//  keyboard slides into place
//  
//  Just include this header in the header of a UIViewController.  Give that
//  controller an instance variable:
//  
//		UIScrollView* scrollView;
//  
//	and place all content inside the scroll view.  Call
//  [self viewControllerKeyboardViewDidLoad] in your controller's viewDidLoad,
//  and call [self viewControllerKeyboardDealloc] in your dealloc.  Add
//  <UITextViewDelegate> to your controller's declaration.  Remember to set the
//  scrollView's contentSize in code!
//
//  Created by A Jesse Jiryu Davis on 1/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Keyboard)

// Call this in viewDidLoad
- (void)viewControllerKeyboardViewDidLoad;

// Declare and implement this property in your view controller, too
@property (readonly) UIScrollView* scrollView;

// Call this from dealloc (removes self as notification observer)
- (void)viewControllerKeyboardDealloc;

@end
