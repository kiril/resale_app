//
//  RSCreatePostController.m
//  Resale
//
//  Created by A Jesse Jiryu Davis on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RSCreatePostController.h"


@interface PostOption : NSObject
{
	NSString* _name;
	SEL _selector;
}

@property (assign, nonatomic) NSString* name;
@property SEL selector;

- (id)initWithName:(NSString*)name selector:(SEL)selector;

@end

@implementation PostOption

@synthesize name=_name, selector=_selector;

- (id)initWithName:(NSString*)name selector:(SEL)selector {
	if (self = [super init]) {
		self.name = name;
		self.selector=selector;
	}
	
	return self;
}

- (void)dealloc {
	self.name = self.selector = nil;
	[super dealloc];
}

@end

@implementation RSCreatePostController

@synthesize titleField=_titleField, photo=_photo, postOptionsBar=_postOptionsBar;

- (id) init {
	if (self = [super init]) {
		postOptions = [[NSArray alloc] initWithObjects:
					   [[PostOption alloc] initWithName:@"t" selector:@selector(showTwitterOption)],
					   [[PostOption alloc] initWithName:@"t" selector:@selector(showFacebookOption)],
					   [[PostOption alloc] initWithName:@"#" selector:@selector(showPhoneNumberOption)],
					   [[PostOption alloc] initWithName:@"@" selector:@selector(showEmailAddressOption)],
					   nil];
		
		self.variableHeightRows = self.autoresizesForKeyboard = YES;
		self.tableViewStyle = UITableViewStyleGrouped;
		
		self.titleField = [[UITextField alloc] init];
		self.titleField.text = @"title";
		TTStyle* photoStyle = [TTImageStyle styleWithImageURL:nil
												 defaultImage:nil
												  contentMode:UIViewContentModeCenter
														 size:CGSizeMake(320, 200)
														 next:nil];
		self.photo = [TTTableImageItem
						itemWithText:nil
						imageURL:@"bundle://rs_post_photo_icon.png"
						defaultImage:nil
						imageStyle:photoStyle
						URL:nil];
		
		self.postOptionsBar = [TTButtonBar new];
		for (PostOption* opt in postOptions) {
			[self.postOptionsBar addButton:opt.name target:self action:opt.selector];
		}
		
		TTButtonBar* postBar = [TTButtonBar new];
		[postBar addButton:@"POST" target:self action:nil];
		
		self.dataSource =
			[TTListDataSource dataSourceWithObjects:
			 self.titleField,
			 self.photo,
			 self.postOptionsBar,
			 postBar,
			 nil];
		
		TT_RELEASE_SAFELY(postBar);
	}

	return self;
}

#pragma mark post option handlers

- (void)showTwitterOption {
	
}

- (void)showFacebookOption {
	
}

- (void)showPhoneNumberOption {
	usePhoneNumber = ! usePhoneNumber;
	
	// TODO: Refactor, comment
	int postOptionsBarIndex = [self.dataSource.items indexOfObject:self.postOptionsBar];
	
	// Find name of post option before this one
	NSString* searchName = @"#", * postNameBefore = nil;
	for (int i = 0; i < postOptions.count; i++) {
		if ([((PostOption*)[postOptions objectAtIndex:i]).name isEqualToString:searchName]) {
			if (i > 0) postNameBefore = ((PostOption*)[postOptions objectAtIndex:i-1]).name;
			break;
		}
	}
	
	int insertIndex = 0;
	for (i = self.dataSource.items.count - 1; i >= 0; i--) {
		if (([[self.dataSource.items objectAtIndex:i] isKindOfClass:[PostOption class]] &&
			 [((PostOption*)[self.dataSource.items objectAtIndex:i]).name isEqualToString:postNameBefore])
			|| [[self.dataSource.items objectAtIndex:i] isEqual:self.postOptionsBar]
			)
		{
			insertIndex = i;
			break;
		}
	}
	
	TTTableLinkedItemCell
	
	[self.dataSource.items insertObject: atIndex:<#(NSUInteger)index#>
}

- (void)showEmailAddressOption {
	
}

#pragma mark -

- (void)dealloc {
	self.titleField = self.photo = self.postOptionsBar = nil;
	TT_RELEASE_SAFELY(postOptions);
	[super dealloc];
}

@end

