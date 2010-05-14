//
//  RSCreatePostController.h
//  Resale
//
//  Created by A Jesse Jiryu Davis on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

// From http://github.com/bengottlieb/Twitter-OAuth-iPhone.git
#import "SA_OAuthTwitterController.h"
#import "Three20Network/TTURLRequestDelegate.h"

@interface RSCreatePostController : UIViewController
	<UITextFieldDelegate, UINavigationControllerDelegate,
	UIImagePickerControllerDelegate, SA_OAuthTwitterControllerDelegate,
	TTURLRequestDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
{
	UIScrollView* _scrollView;
	IBOutlet UIView* contentsView;
	IBOutlet UITextField* titleField, * phoneField, * emailField, * priceField;
	IBOutlet UISwitch* freeSwitch;
	IBOutlet UIView* priceContainer;
	IBOutlet UIButton* photoButton, * useTwitterButton, * useFacebookButton,
		* usePhoneButton, * useEmailButton, * postButton, * shareButton;
	TTActivityLabel* activityLabel;
	BOOL useTwitter, useFacebook, usePhone, useEmail, hasImage;
	NSMutableArray* sharingOptions;
	
	NSMutableDictionary* _thePost;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) NSMutableDictionary* thePost;


- (IBAction)onUseTwitter;
- (IBAction)onUseFacebook;
- (IBAction)onUsePhone;
- (IBAction)onUseEmail;
- (IBAction)onFreeValueChanged;
- (IBAction)choosePhoto;
- (IBAction)post;
- (IBAction)share;

@end
