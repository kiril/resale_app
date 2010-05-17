//
//  RSSearchPostsModel.h
//  Resale
//  Model that searches for posts on the server
//  Thanks to http://revetkn.com/?p=62
//
//  Created by A Jesse Jiryu Davis on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define TTDFLAG_URLREQUEST 1

#import <Three20UI/Three20UI.h>
#import <CoreLocation/CoreLocation.h>


@interface RSSearchPostsModel : TTURLRequestModel <TTURLRequestDelegate> {
@private
	CLLocationCoordinate2D _coordinate;
	NSString* _query;
	// TODO: I copied these from the example - needed?
	BOOL _loading;
	BOOL _loaded;
	NSArray* _results;
}

@property (retain, nonatomic) NSArray* results;

- (id)initWithLocation:(CLLocationCoordinate2D)coordinate query:(NSString*)query;

@end
