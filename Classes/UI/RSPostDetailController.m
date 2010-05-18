//
//  RSPostDetailController.m
//  Resale
//
//  Created by A Jesse Jiryu Davis on 5/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RSPostDetailController.h"
#import "AppDelegate.h"
#import "RSPostDetailTableDataSource.h"
#import "RSPostDetailModel.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RSPostDetailController


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithShortCode:(NSString*)shortCode {
	if (self = [super init]) {
		self.variableHeightRows = YES;
		// Initialize our TTTableViewDataSource and our TTModel.
		// TODO: can we simplify this and combine the two models?  Or at least refactor with RSSearchPostsController?
		// TODO: don't start loading search until view is visible
		id<TTTableViewDataSource> ds = [RSPostDetailTableDataSource dataSourceWithItems:nil];
		ds.model = [[[RSPostDetailModel alloc] initWithShortCode:shortCode] autorelease];
		
		// By setting the dataSource property, the model property for this
		// class (SearchTableViewController) will automatically be hooked up 
		// to point at the same model that the dataSource points at, 
		// which we just instantiated above.
		self.dataSource = ds;		
	}
	
	return self;
}


@end

