//
//  RSSearchPostsTableDataSource.m
//  Resale
//  Adapted from http://github.com/klazuka/TTRemoteExamples
//
//  Created by A Jesse Jiryu Davis on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import "RSSearchPostsTableDataSource.h"
#import "RSSearchPostsModel.h"
#import "NSDictionary+Post.h"

@implementation RSSearchPostsTableDataSource


- (void)tableViewDidLoadModel:(UITableView *)tableView
{
    [super tableViewDidLoadModel:tableView];
    [self.items removeAllObjects];
    
    // Construct an object that is suitable for the table view system
    // from each result object that we retrieve from the TTModel.
    for (NSDictionary *post in ((RSSearchPostsModel*)self.model).results) {
		NSString* short_code = [post objectForKey:@"short_code"];
		[self.items addObject:[TTTableTextItem itemWithText:post.postShortDescription]];
		
		// TODO: Make full-height
        TTTableImageItem* tii = [TTTableImageItem itemWithText:nil
													  imageURL:[post objectForKey:@"image_url"]
												  defaultImage:TTIMAGE(@"bundle://rs_post_default_thumbnail.png")
														   URL:[NSString stringWithFormat:
																@"resale://post_detail?short_code=%@",
																short_code]];
		
		
		
		[self.items addObject:tii];
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
