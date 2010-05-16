//
//  RSSearchPostsTableDataSource.m
//  Resale
//
//  Created by A Jesse Jiryu Davis on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import "RSSearchPostsTableDataSource.h"
#import "RSSearchPostsModel.h"

@implementation RSSearchPostsTableDataSource


- (void)tableViewDidLoadModel:(UITableView *)tableView
{
    [super tableViewDidLoadModel:tableView];
    [self.items removeAllObjects];
    
    // Construct an object that is suitable for the table view system
    // from each result object that we retrieve from the TTModel.
    for (NSDictionary *post in ((RSSearchPostsModel*)self.model).results) {
        TTTableImageItem* tii = [TTTableImageItem itemWithText:[post objectForKey:@"title"]
													  imageURL:[post objectForKey:@"image_url"]
												  defaultImage:TTIMAGE(@"bundle://rs_post_default_thumbnail.png")
														   URL:nil];
		
        // There is a bug in Three20's table cell image logic w.r.t.
        // Three20's image cache. By applying this TTImageStyle, we can
        // override the layout logic to force the image to always be a fixed size.
        // (thanks RoBak42 for the workaround!)
        tii.imageStyle = [TTImageStyle styleWithImage:nil
                                         defaultImage:[UIImage imageNamed:@"photo_placeholder.png"]
                                          contentMode:UIViewContentModeScaleAspectFill
                                                 size:CGSizeMake(75.f, 75.f)
                                                 next:nil];
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
