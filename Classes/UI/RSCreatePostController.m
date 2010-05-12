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
#import "AppDelegate.h"
#import "RSPost.h"

@interface RSCreatePostController (private)

- (void)updateControls:(BOOL)animate;
- (void)updateTwitterWithPost:(RSPost*)post;

@end


@implementation RSCreatePostController

@synthesize scrollView=_scrollView;

- (void)viewDidLoad {
	useTwitter = useFacebook = usePhone = useEmail = NO;
	
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
	useTwitter = ! useTwitter;
	[self updateControls:YES];
}

- (IBAction)onUseFacebook {
	useFacebook = ! useFacebook;
	[self updateControls:YES];
}

- (IBAction)onUsePhone {
	usePhone = ! usePhone;
	[self updateControls:YES];
}

- (IBAction)onUseEmail {
	useEmail = ! useEmail;
	[self updateControls:YES];
}

- (IBAction)onFreeValueChanged {
	[self updateControls:YES];
}

- (IBAction)choosePhoto {
	UIImagePickerController* imagePickerController = [UIImagePickerController new];
	imagePickerController.delegate = self;
	// TODO: detect if we're on simulator or real phone, use 'camera' sourceType on phone
	imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentModalViewController:imagePickerController animated:YES];
}

- (IBAction)post {
	RSPost* post = [RSPost new];
	if (useTwitter) {
		[self updateTwitterWithPost:post];
	}
	
	[post release];
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField
	shouldChangeCharactersInRange:(NSRange)range
	replacementString:(NSString *)string
{
	int maxLength = 0;
	// TODO: put some thought into these lengths
	if (textField == titleField) maxLength = 60;
	else if (textField == phoneField) maxLength = 20;
	else if (textField == emailField) maxLength = 40;
	else if (textField == priceField) maxLength = 2;
	
	// Allow text change if text field won't exceed max length
	return (textField.text.length + string.length - range.length <= maxLength);
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
	[photoButton setBackgroundImage:image forState:UIControlStateNormal];
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissModalViewControllerAnimated:YES];
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
	   didShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated
{
	// Nothing
}

- (void)navigationController:(UINavigationController *)navigationController
	  willShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated
{
	// Nothing
}

#pragma mark Twitter

- (void)updateTwitterWithPost:(RSPost*)post {
	AppDelegate* appdel = (AppDelegate*)[UIApplication sharedApplication].delegate;
	UIViewController* authController =
	[SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:appdel.twitterEngine
																	delegate:self];
	
	if (authController) {
		[self presentModalViewController:authController animated:YES];
	}
}

#pragma mark SA_OAuthTwitterControllerDelegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller
	  authenticatedWithUsername: (NSString *) username
{
	
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	
}

#pragma mark private

- (void)updateControls:(BOOL)animate {
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
	
	useTwitterButton.backgroundColor = useTwitter ? [UIColor blueColor] : [UIColor clearColor];
	useFacebookButton.backgroundColor = useFacebook ? [UIColor blueColor] : [UIColor clearColor];
	usePhoneButton.backgroundColor = usePhone ? [UIColor blueColor] : [UIColor clearColor];
	useEmailButton.backgroundColor = useEmail ? [UIColor blueColor] : [UIColor clearColor];
	
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
	TT_RELEASE_SAFELY(photoButton);
	TT_RELEASE_SAFELY(useTwitterButton);
	TT_RELEASE_SAFELY(useFacebookButton);
	TT_RELEASE_SAFELY(usePhoneButton);
	TT_RELEASE_SAFELY(useEmailButton);
	TT_RELEASE_SAFELY(postButton);
	[self viewControllerKeyboardDealloc];
    [super dealloc];
}


@end

