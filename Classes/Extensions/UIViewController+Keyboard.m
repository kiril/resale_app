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
//	and place all content inside the scroll view.  In Interface Builder or in
//  code, set text fields' delegates to the controller so its textFieldDidBeginEditing:
//  method is called.
//
//  Created by A Jesse Jiryu Davis on 1/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+Keyboard.h"
#import "UIView+AJJD.h" // for allSubviews

NSMutableDictionary* instance2frame;

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;

@implementation UIViewController (Keyboard)

// Assume the view controller using this category has a real implementation
// of a "scrollView" property
@dynamic scrollView;

// Call this in viewDidLoad
- (void)viewControllerKeyboardViewDidLoad {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(onKeyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(onKeyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
	
	// allSubviews is recursive, from UIView+AJJD
	for (UIView* subview in [self.view allSubviews]) {
		if ([subview isKindOfClass:[UITextField class]]) {
			// Assume that this UIViewController (for which this file implements
			// a category) has been declared a UITextFieldDelegate
			[(UITextField*)subview setDelegate:(id<UITextFieldDelegate>)self];
		}
	}
//	CGRect frame = self.scrollView.frame;
//	frame.size.height -= 200;
//	self.scrollView.frame = frame;
}


#pragma mark -
#pragma mark notification handlers

#define KEYBOARD_ANIMATION_DURATION 0.3

- (void)onKeyboardWillShow:(NSNotification*)notif {
	// Get the size of the onscreen keyboard
	NSDictionary *info = [notif userInfo];
    NSValue *keyBounds = [info objectForKey:UIKeyboardBoundsUserInfoKey];	
    CGRect bndKey;
    [keyBounds getValue:&bndKey];
	BOOL hasTabBar = nil != self.tabBarController;
	self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, bndKey.size.height - (hasTabBar ? 49 : 0), 0);
	
//	// Store the current frame of the scrollview
//	CGRect frame = self.scrollView.frame;
//	if ( ! instance2frame)
//		instance2frame = [NSMutableDictionary new];
//	
//	NSNumber* key = [NSNumber numberWithInt:(int)self];
//	[instance2frame setObject:[NSValue valueWithCGRect:frame] forKey:key];
//	
//	// Adjust the size of the scroll view so the keyboard doesn't overlap it
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
//	[UIView setAnimationBeginsFromCurrentState:YES];
//	
//	BOOL hasTabBar = nil != self.tabBarController;
//	frame.size.height -= (bndKey.size.height - (hasTabBar ? 49 : 0));
//	self.scrollView.frame = frame;
//	
//	[UIView commitAnimations];
}

- (void)onKeyboardWillHide:(NSNotification*)notif {
	[UIView beginAnimations:nil context:NULL];
	self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	[UIView commitAnimations];
	
//	// Keyboard has slid away, restore scroll view's frame to original
//	NSNumber* key = [NSNumber numberWithInt:(int)self];
//	NSValue* value = [instance2frame objectForKey:key];
//	if (value) {
//		DLog(@"onKeyboardWillHide");
//		
//		CGRect frame = [value CGRectValue];
//		[UIView beginAnimations:nil context:NULL];
//		[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
//		[UIView setAnimationBeginsFromCurrentState:YES];
//		self.scrollView.frame = frame;
//		[UIView commitAnimations];
//		
//		// Delete the frame from storage
//		[instance2frame removeObjectForKey:key];
//	}
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	CGRect textFieldRect =
		[self.view.window convertRect:textField.bounds fromView:textField];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[self.scrollView scrollRectToVisible:textFieldRect animated:NO];
	
	//CGPoint contentOffset = self.scrollView.contentOffset;
//	contentOffset.y += 50;
//	[self.scrollView setContentOffset:contentOffset];
//	
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark UITextFieldDelegate implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	// Text fields are tagged in IB with ascending tags: 1, 2, 3, ..., in order
	// to simulate a tab order.  iPhone framework doesn't provide a tab order.
	
	// Idea from here:
	// http://stackoverflow.com/questions/1347779/how-to-navigate-through-textfields-next-done-buttons/1347871
	
	// The fields in the login view are tagged 1 and 2.  The fields in the
	// register view are tagged 1, 2, and 3.
	
	NSInteger nextTag = textField.tag + 1;
	
	// Try to find next responder
	UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
	if (nextResponder) {
		// Found next responder, so set it.
		[nextResponder becomeFirstResponder];
	} else {
		// Not found, so remove keyboard.
		[textField resignFirstResponder];
	}
	return NO; // We do not want UITextField to insert line-breaks.
}

#pragma mark -

// Call this from dealloc
- (void)viewControllerKeyboardDealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
