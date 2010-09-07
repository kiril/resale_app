//
//  RSAPI.h
//  Resale
//
//  Created by A Jesse Jiryu Davis on 9/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSAPI : NSObject {

}

+ (NSURL*)APIURLWithPath:(NSString*)path;
+ (TTURLRequest*)APIRequestWithPath:(NSString*)path delegate:(id)delegate;
+ (TTURLRequest*)getAPIRequestWithPath:(NSString*)path delegate:(id)delegate;
+ (TTURLRequest*)postAPIRequestWithPath:(NSString*)path json:(NSDictionary*)json delegate:(id)delegate;

@end
