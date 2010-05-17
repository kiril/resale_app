//
//  RSPostDetailTableDataSource.m
//  Resale
//  Adapted from http://github.com/klazuka/TTRemoteExamples
//
//  Created by A Jesse Jiryu Davis on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "RSPostDetailTableDataSource.h"
#import "RSPostDetailModel.h"
#import "AppDelegate.h"
#import "NSDictionary+Post.h"


@implementation RSPostDetailTableDataSource


- (void)tableViewDidLoadModel:(UITableView *)tableView
{
	[super tableViewDidLoadModel:tableView];
    [self.items removeAllObjects];
    
    // Construct an object that is suitable for the table view system
    // from each result object that we retrieve from the TTModel.
	NSDictionary *post = ((RSPostDetailModel*)self.model).post;
	
	TTTableImageItem* tii = [TTTableImageItem itemWithText:nil
												  imageURL:[post objectForKey:@"image_url"]
											  defaultImage:TTIMAGE(@"bundle://rs_post_default_thumbnail.png")
													   URL:nil];
	tii.imageStyle = TTSTYLEVAR(imageStyle);
	[self.items addObject:tii];
	
	// TODO: remove these once i've figured out how to make the image's cell as
	// tall as the image it contains
	[self.items addObject:[TTTableTextItem itemWithText:@"spacer"]];
	[self.items addObject:[TTTableTextItem itemWithText:@"spacer"]];
	[self.items addObject:[TTTableTextItem itemWithText:@"spacer"]];
	
	[self.items addObject:[TTTableTextItem itemWithText:post.postShortDescription]];
	
	if ([post objectForKey:@"phone_number"]) {
		// TODO: Make the phone number callable or textable when tapped
		[self.items addObject:[TTStyledText textFromXHTML:[post objectForKey:@"phone_number"]]];
	}
	 
	if ([post objectForKey:@"email_address"]) {
		// TODO: open a mail-compose view when user taps on address
		// TODO: escape HTML sequences in the email address, or ensure elsewhere they're not allowed
		// in: security risk
		NSString* email_address = [post objectForKey:@"email_address"];
		[self.items addObject:[TTStyledText textFromXHTML:[NSString stringWithFormat:
														   @"<a href=\"mailto:%@\">%@</a>",
														   email_address,
														   email_address]]];
	}
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTableViewDataSource protocol

- (UIImage*)imageForEmpty
{
	return [UIImage imageNamed:@"Three20.bundle/images/empty.png"];
}

- (UIImage*)imageForError:(NSError*)error
{
    return [UIImage imageNamed:@"Three20.bundle/images/error.png"];
}


@end
