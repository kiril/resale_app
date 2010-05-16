//
//  NSDictionary+CGI.h
//  Resale
//  Format dictionary as CGI parameters
//
//  Created by A Jesse Jiryu Davis on 5/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (CGI)

- (NSString*)urlEncodedString;

@end
