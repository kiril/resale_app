//
//  RSPostDetailModel.h
//  Resale
//  Model that searches for posts on the server
//  Thanks to http://revetkn.com/?p=62
//
//  Created by A Jesse Jiryu Davis on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define TTDFLAG_URLREQUEST 1

#import <Three20Network/Three20Network.h>


@interface RSPostDetailModel : TTModel {
@private
	NSString* shortCode;
	// TODO: I copied these from the example - needed?
	BOOL _loading;
	BOOL _loaded;
	NSDictionary* _post;
}

@property (retain, nonatomic) NSDictionary* post;

- (id)initWithShortCode:(NSString*)theShortCode;

@end
