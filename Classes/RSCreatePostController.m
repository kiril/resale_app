//
//  RSCreatePostController.m
//  Resale
//
//  Created by A Jesse Jiryu Davis on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RSCreatePostController.h"
#import "UIViewController+Keyboard.h"
#import "UIView+AJJD.h"
#import "UIView+LW.h"

@interface RSCreatePostController (private)

- (void)updateControls:(BOOL)animate;

@end


@implementation RSCreatePostController

@synthesize scrollView=_scrollView;

- (void)viewDidLoad {
	// Keep contents view out of scroll view in IB, and start off with all its
	// fields visible, simply so we can easily edit it in IB
	[self updateControls:NO];
	[self.scrollView addSubview:contentsView];
	self.scrollView.contentSize = contentsView.frame.size;
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
											  initWithTitle:@"Done"
											  style:UIBarButtonItemStyleBordered
											  target:self
											  action:@selector(inputDone)];
	
	[self viewControllerKeyboardViewDidLoad];
}

#pragma mark button handlers

- (IBAction)inputDone {
	// From UIView+AJJD
	[self.view makeSubviewsPerformSelector:@selector(resignFirstResponder)];
}

- (IBAction)onUseTwitter {
	
}

- (IBAction)onUseFacebook {
	
}

- (IBAction)onUsePhone {
	usePhone = ! usePhone;
	usePhoneButton.backgroundColor = usePhone ? [UIColor blueColor] : [UIColor clearColor];
	[self updateControls:YES];
}

- (IBAction)onUseEmail {
	useEmail = ! useEmail;
	useEmailButton.backgroundColor = useEmail ? [UIColor blueColor] : [UIColor clearColor];
	[self updateControls:YES];
}

- (IBAction)onFreeValueChanged {
	[self updateControls:YES];
}

#pragma mark private

- (void)updateControls:(BOOL)animate {
//	CGPoint offset = CGPointMake(0, 5);
	int emailFieldY = freeSwitch.frame.origin.y + freeSwitch.frame.size.height + 5 + (
		usePhone ?
		phoneField.frame.size.height + 5 :
		0
	);
	
	int priceContainerY = emailFieldY + (
		useEmail ? 
		emailField.frame.size.height + 5 :
		0
	);
	
	int postButtonY = priceContainerY + (
		freeSwitch.on ? 0 : priceContainer.frame.size.height + 5
	);
	
	if (animate) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
	}
	
	phoneField.alpha = usePhone ? 1 : 0;
	emailField.alpha = useEmail ? 1 : 0;
	priceContainer.alpha = freeSwitch.on ? 0 : 1;
	
	[emailField reposition:CGPointMake(emailField.frame.origin.x, emailFieldY)];
	[priceContainer reposition:CGPointMake(priceContainer.frame.origin.x, priceContainerY)];
	[postButton reposition:CGPointMake(postButton.frame.origin.x, postButtonY)];
	
	if (animate) [UIView commitAnimations];
}

#pragma mark -

- (void)dealloc {
	self.scrollView = nil;
	TT_RELEASE_SAFELY(contentsView);
	TT_RELEASE_SAFELY(titleField);
	TT_RELEASE_SAFELY(phoneField);
	TT_RELEASE_SAFELY(emailField);
	TT_RELEASE_SAFELY(freeSwitch);
	TT_RELEASE_SAFELY(priceContainer);
	TT_RELEASE_SAFELY(usePhoneButton);
	TT_RELEASE_SAFELY(useEmailButton);
	TT_RELEASE_SAFELY(postButton);
	[self viewControllerKeyboardDealloc];
    [super dealloc];
}


@end

