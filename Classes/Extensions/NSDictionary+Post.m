//
//  NSDictionary+Post.m
//  Resale
//
//  Created by A Jesse Jiryu Davis on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+Post.h"
#import "AppDelegate.h"


@implementation NSDictionary (Post)

- (NSString*)postShortDescription {
	return [NSString stringWithFormat:@"%@ %@ %@",
			// TODO: truncate title at some number of chars, say, 50
			[self objectForKey:@"title"],
			self.postPrice,
			self.postDistance];	
}

- (NSString*)postDistance {
	// TODO: ignore obviously wrong locations (both for this phone & for the post)
	// like 0, 0, latitudes out of [-180, 180], longitudes out of [-90, 90], or NaN.
	AppDelegate* appdel = (AppDelegate*)[UIApplication sharedApplication].delegate;
	NSDictionary* locationDict = [self objectForKey:@"location"];
	CLLocation* location = [[[CLLocation alloc] initWithLatitude:[[locationDict objectForKey:@"lat"] doubleValue]
													   longitude:[[locationDict objectForKey:@"long"] doubleValue]]
							autorelease];
	// TODO: use getDistanceFrom: if OS < 3.2
	//CLLocationDistance distance = [appdel.locationManager.location getDistanceFrom:location];
	CLLocationDistance distance = [appdel.locationManager.location distanceFromLocation:location];
	return [NSString stringWithFormat:@"%dm", (int)distance];
}

- (NSString*)postPrice {
	NSString* raw_price = [self objectForKey:@"price"];
	if (raw_price && 0 != [raw_price intValue]) return [NSString stringWithFormat:@"$%@", raw_price];
	else return @"FREE";
}

@end
