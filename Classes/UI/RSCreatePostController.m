//
//  RSCreatePostController.m
//  Resale
//
//  Created by A Jesse Jiryu Davis on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RSCreatePostController.h"
#import "RSTabController.h"
#import "UIViewController+Keyboard.h"
#import "UIView+AJJD.h"
#import "UIView+LW.h"
#import "AppDelegate.h"
#import "extThree20JSON/NSObject+SBJSON.h"
#import "extThree20JSON/TTURLJSONResponse.h"

@interface RSCreatePostController (private)

- (void)sendPost;
- (void)uploadImage;
- (void)updateControls:(BOOL)animate;
- (void)updateTwitter;
- (void)updatePostFromUI;
- (void)enableControls:(BOOL)enabled;

@end


@implementation RSCreatePostController

@synthesize scrollView=_scrollView, thePost=_thePost;

- (void)viewDidLoad {
	useTwitter = useFacebook = usePhone = useEmail = NO;
	self.thePost = [[[NSMutableDictionary alloc] initWithCapacity:5] autorelease];
	sharingOptions = [NSMutableArray new];
	if ([MFMailComposeViewController canSendMail]) {
		[sharingOptions addObject:@"Email"];
	}
	
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
#ifdef TARGET_IPHONE_SIMULATOR
	imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
	imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
	[self presentModalViewController:imagePickerController animated:YES];
}

- (IBAction)post {
	[self updatePostFromUI];
	[self enableControls:NO];
	TT_RELEASE_SAFELY(activityLabel);
//	activityLabel = [[TTActivityLabel alloc] initWithFrame:CGRectMake(30, 40, 320 - 30 * 2, 100)
//													 style:TTActivityLabelStyleWhite
//													  text:@"Uploading image"];
	
	if (hasImage) {
		// Upload image, then send post
		[self uploadImage];
	} else {
		// Send post now
		[self sendPost];
	}
}

- (IBAction)share {
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share this post"
															 delegate:self
													cancelButtonTitle:@"Cancel"
											   destructiveButtonTitle:nil
													otherButtonTitles:nil];
	for (NSString* optionName in sharingOptions)
		[actionSheet addButtonWithTitle:optionName];
	
	// TODO: SMS via API
	//[actionSheetController addButtonWithTitle:@"SMS"];
	RSTabController* tabController = [[TTNavigator navigator].URLMap objectForURL:@"resale://tabs"];
	[actionSheet showFromTabBar:tabController.tabBar];
}

- (void)uploadImage {
	TTURLRequest* request = [TTURLRequest requestWithURL:@"http://localhost:8001/post/image" delegate:self];
	request.httpMethod = @"POST";
	request.cachePolicy = TTURLRequestCachePolicyNoCache;
	request.response = [[TTURLJSONResponse new] autorelease];
	request.httpBody = UIImageJPEGRepresentation([photoButton backgroundImageForState:UIControlStateNormal],
												  0.5 // quality
												  );
	
	request.userInfo = [TTUserInfo topic:@"uploadImage"];
	[request send];
}

- (void)sendPost {
	// TODO: show progress
	TTURLRequest* request = [TTURLRequest requestWithURL:@"http://localhost:8001/post" delegate:self];
	request.httpMethod = @"POST";
	request.cachePolicy = TTURLRequestCachePolicyNoCache;
	request.response = [[TTURLJSONResponse new] autorelease];
	request.userInfo = [TTUserInfo topic:@"sendPost"];
	
	NSMutableDictionary* jsonDict = [NSMutableDictionary dictionaryWithDictionary:self.thePost];
	[jsonDict setObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSNumber numberWithFloat:11.5], @"lat",
						 [NSNumber numberWithFloat:123.0], @"long",
						 nil]
				 forKey:@"location"];
	NSString* json = [jsonDict JSONRepresentation];
	[request setHttpBody:[json dataUsingEncoding:NSUTF8StringEncoding]];
	[request send];
	
	if (useTwitter) {
		[self updateTwitter];
	}
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
	hasImage = YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissModalViewControllerAnimated:YES];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	int sharingIndex = buttonIndex - 1; // Cancel is index 0
	if (sharingIndex >= sharingOptions.count) {
		NSLog(@"Bad actionSheet button index");
		return;
	}
	
	NSString* optionName = [sharingOptions objectAtIndex:sharingIndex];
	
	if ([optionName isEqualToString:@"Email"]) {
		MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
		mailer.mailComposeDelegate = self;
		[mailer setSubject:[self.thePost objectForKey:@"title"]];
		NSString* emailBody = nil;
		if ([[self.thePost objectForKey:@"price"] isEqualToString:@"0"]) {
			// Free
			emailBody = @"I'm giving stuff away!";
		} else {
			// Not free
			emailBody = [NSString stringWithFormat:
						 @"I'm selling stuff for $%@!",
						 [self.thePost objectForKey:@"price"]];
		}
		
		emailBody = [emailBody stringByAppendingFormat:
					 @"<p>&nbsp;</p><a href=\"%@\">%@</a><br/>",
					 [self.thePost objectForKey:@"url"],
					 [self.thePost objectForKey:@"url"]];
		
		if ([self.thePost objectForKey:@"image_url"]) {
			emailBody = [emailBody stringByAppendingFormat:
						 @"<p>&nbsp;</p>"
						 "<img src=\"%@\" />",
						 [self.thePost objectForKey:@"image_url"]];
		}
		
		[mailer setMessageBody:emailBody
						isHTML:YES];
		[self presentModalViewController:mailer animated:YES];
		[mailer release];
	} else {
		NSLog(@"Unhandled sharing option: %@", optionName);
	}
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError*)error
{
	// Nothing
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

#pragma mark TTURLRequestDelegate

- (void)requestDidFinishLoad:(TTURLRequest*)request {
	NSString* topic = ((TTUserInfo*)request.userInfo).topic;
	NSDictionary* responseDict = (NSDictionary*)((TTURLJSONResponse*)request.response).rootObject;
	if (! [[responseDict objectForKey:@"result"] isEqualToString:@"OK"]) {
		// TODO: general and richer error communication to user
		TTAlert([NSString stringWithFormat:@"Server error: %@", [responseDict objectForKey:@"message"]]);
		return;
	}
	
	if ([topic isEqualToString:@"uploadImage"]) {
		// We've uploaded an image!  Prepare to send post.
		[self.thePost setObject:[responseDict objectForKey:@"image_url"] forKey:@"image_url"];
		[self sendPost];
	} else if ([topic isEqualToString:@"sendPost"]) {
		NSDictionary* postFromServer = [((TTURLJSONResponse*)request.response).rootObject objectForKey:@"post"];
		[self.thePost addEntriesFromDictionary:postFromServer];
		[self enableControls:YES];
	} else {
		NSLog(@"Error in [RSCreatePostController requestDidFinishLoad]: unrecognized request topic %@",
			  topic
			  );
	}
	
	[self updateControls:YES];
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
	NSLog(@"create-post request failed: %@", error);
	TTAlert([NSString stringWithFormat:@"Server error: %@", error]);
	[self enableControls:YES];
	[self updateControls:YES];
}

- (void)requestDidCancelLoad:(TTURLRequest*)request {
	NSLog(@"create-post request canceled");
	TTAlert(@"Server request cancelled");
	[self enableControls:YES];
	[self updateControls:YES];
}

#pragma mark Twitter

- (void)updateTwitter {
	AppDelegate* appdel = (AppDelegate*)[UIApplication sharedApplication].delegate;
	UIViewController* authController =
	[SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:appdel.twitterEngine
																	delegate:self];
	
	if (authController) {
		[self presentModalViewController:authController animated:YES];
	}
}

// Update self.thePost from UI
- (void)updatePostFromUI {
	[self.thePost setObject:titleField.text forKey:@"title"];
	[self.thePost setObject:freeSwitch.on ? @"0" : priceField.text
					 forKey:@"price"];
}

- (void)enableControls:(BOOL)enabled {
	// allSubviews from UIView+AJJD.h
	for (UIView* view in self.view.allSubviews) {
		if ([view isKindOfClass:[UIControl class]])
			[(UIControl*)view setEnabled:enabled];
	}
}

#pragma mark SA_OAuthTwitterControllerDelegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller
	  authenticatedWithUsername: (NSString *) username
{
	NSLog(@"OAuthTwitterController authenticatedWithUsername");
	AppDelegate* appdel = (AppDelegate*)[UIApplication sharedApplication].delegate;
	NSString* tweet = nil;
	if (freeSwitch.on) tweet = [titleField.text stringByAppendingString:@" FREE"];
	else tweet = [titleField.text stringByAppendingFormat:@" $%@", priceField.text];
	tweet = [tweet stringByAppendingFormat:@" %@", [self.thePost objectForKey:@"url"]];
	NSString* twitterConnectionId = [appdel.twitterEngine sendUpdate:tweet];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	NSLog(@"OAuthTwitterControllerFailed");	
	// TODO: alert user, let user try to tweet again w/o duplicating Resale post
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	NSLog(@"OAuthTwitterControllerCanceled");	
	// TODO: alert user, let user try to tweet again w/o duplicating Resale post
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
	
	int shareButtonY = postButtonY + postButton.frame.size.height + 5;
	
	// Show share button if we know a URL for this post
	BOOL showShareButton = [self.thePost objectForKey:@"url"] ? YES : NO;
	int bottomY = shareButtonY + (showShareButton ? shareButton.frame.size.height + 5 : 0);
	
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
	// Has post already been sent to server?
	postButton.enabled = [self.thePost objectForKey:@"url"] ? NO : YES;
	[shareButton reposition:CGPointMake(shareButton.frame.origin.x, shareButtonY)];
	shareButton.alpha = showShareButton ? 1 : 0;
	CGSize size = CGSizeMake(self.scrollView.contentSize.width, bottomY);
	// TODO: shrinking the contents to fit controls would be nice, but for some
	// reason disables user interaction
//	[contentsView resize:size];
	self.scrollView.contentSize = size;
	
	useTwitterButton.backgroundColor = useTwitter ? [UIColor blueColor] : [UIColor clearColor];
	useFacebookButton.backgroundColor = useFacebook ? [UIColor blueColor] : [UIColor clearColor];
	usePhoneButton.backgroundColor = usePhone ? [UIColor blueColor] : [UIColor clearColor];
	useEmailButton.backgroundColor = useEmail ? [UIColor blueColor] : [UIColor clearColor];
	
	if (animate) [UIView commitAnimations];
}

#pragma mark -

- (void)dealloc {
	self.scrollView = self.thePost = nil;
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
	TT_RELEASE_SAFELY(shareButton);
	TT_RELEASE_SAFELY(sharingOptions);
	[self viewControllerKeyboardDealloc];
    [super dealloc];
}


@end

