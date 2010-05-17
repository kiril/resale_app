//
//  NSDictionary+Post.h
//  Resale
//
//  Created by A Jesse Jiryu Davis on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NSDictionary (Post)

- (NSString*)postShortDescription;
- (NSString*)postDistance;
- (NSString*)postPrice;

@end
