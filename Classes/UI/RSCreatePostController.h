//
//  RSCreatePostController.h
//  Resale
//
//  Created by A Jesse Jiryu Davis on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSCreatePostController : UIViewController
	<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
	UIScrollView* _scrollView;
	IBOutlet UIView* contentsView;
	IBOutlet UITextField* titleField, * phoneField, * emailField, * priceField;
	IBOutlet UISwitch* freeSwitch;
	IBOutlet UIView* priceContainer;
	IBOutlet UIButton* photoButton, * useTwitterButton, * useFacebookButton,
		* usePhoneButton, * useEmailButton, * postButton;
	BOOL useTwitter, useFacebook, usePhone, useEmail;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;


- (IBAction)onUseTwitter;
- (IBAction)onUseFacebook;
- (IBAction)onUsePhone;
- (IBAction)onUseEmail;
- (IBAction)onFreeValueChanged;
- (IBAction)choosePhoto;
- (IBAction)post;

@end
