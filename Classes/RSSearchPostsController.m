//
//  RSSearchPostsController.m
//  Resale
//
//  Created by A Jesse Jiryu Davis on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RSSearchPostsController.h"



///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RSSearchPostsController


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) init {
  if (self = [super init]) {
    //self.variableHeightRows = YES;

    self.dataSource =
      [TTListDataSource dataSourceWithObjects:
	   [TTTableTextItem itemWithText:@"Table cell item"],
	   nil];
  }

  return self;
}


@end

