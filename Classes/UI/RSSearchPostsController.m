//
//  RSSearchPostsController.m
//  Resale
//
//  Created by A Jesse Jiryu Davis on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RSSearchPostsController.h"
#import "RSSearchPostsTableDataSource.h"
#import "RSSearchPostsModel.h"
#import "AppDelegate.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RSSearchPostsController


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) init {
  if (self = [super init]) {
    //self.variableHeightRows = YES;

	  self.title = @"Stuff nearby";
	  
	  // Initialize our TTTableViewDataSource and our TTModel.
	  // TODO: can we simplify this and combine the two models?
	  // TODO: don't start loading search until view is visible
	  id<TTTableViewDataSource> ds = [RSSearchPostsTableDataSource dataSourceWithItems:nil];
	  AppDelegate* appdel = [UIApplication sharedApplication].delegate;
	  // TODO: ask user for query
	  ds.model = [[[RSSearchPostsModel alloc] initWithLocation:appdel.locationManager.location.coordinate
														 query:@""] autorelease];
	  
	  // By setting the dataSource property, the model property for this
	  // class (SearchTableViewController) will automatically be hooked up 
	  // to point at the same model that the dataSource points at, 
	  // which we just instantiated above.
	  self.dataSource = ds;
  }

  return self;
}


@end

