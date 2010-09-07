//
//  NSMutableDictionary+Resale.h
//  Resale
//
//  Created by A Jesse Jiryu Davis on 9/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableDictionary (Resale)

// like setObject:forKey:, but does nothing for empty string or nil
- (void)setNonEmptyString:(NSString*)str forKey:(id)key;

@end
