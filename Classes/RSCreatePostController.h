//
//  RSCreatePostController.h
//  Resale
//
//  Created by A Jesse Jiryu Davis on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@interface RSCreatePostController : TTTableViewController {
	UITextField* _titleField;
	TTTableImageItem* _photo;
	TTButtonBar* _postOptionsBar;
	
	
	NSArray* postOptions;
	BOOL useTwitter, useFacebook, usePhoneNumber, useEmailAddress;
}

@property (assign, nonatomic) UITextField* titleField;
@property (assign, nonatomic) TTTableImageItem* photo;
@property (assign, nonatomic) TTButtonBar* postOptionsBar;

@end
