//
//  NSMutableDictionary+Resale.m
//  Resale
//
//  Created by A Jesse Jiryu Davis on 9/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSMutableDictionary+Resale.h"


@implementation NSMutableDictionary (Resale)

// like setObject:forKey:, but does nothing for empty string or nil
- (void)setNonEmptyString:(NSString*)str forKey:(id)key {
	if (str.length) [self setObject:str forKey:key];
}

@end
