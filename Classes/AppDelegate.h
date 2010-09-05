//
//  ResaleAppDelegate.h
//  Resale
//
//  Created by A Jesse Jiryu Davis on 5/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SA_OAuthTwitterEngine.h"
#import <CoreLocation/CoreLocation.h>

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface AppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate> {
	NSManagedObjectModel*         _managedObjectModel;
	NSManagedObjectContext*       _managedObjectContext;
	NSPersistentStoreCoordinator* _persistentStoreCoordinator;

	// App State
	BOOL                          _modelCreated;
	BOOL                          _resetModel;

	SA_OAuthTwitterEngine* _twitterEngine;
	CLLocationManager* _locationManager;
	NSMutableDictionary* _shortCodeToPost;
}

@property (nonatomic, retain, readonly) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, readonly)         NSString*               applicationDocumentsDirectory;
@property (nonatomic, retain)			SA_OAuthTwitterEngine* twitterEngine;
@property (nonatomic, retain)			CLLocationManager* locationManager;

- (void)cachePost:(NSDictionary*)post forShortCode:(NSString*)shortCode;

// Get a post from cache or retrieve from server - intended to be called in bg
- (NSDictionary*)postForShortCode:(NSString*)shortCode;

- (void)clearPostCache;

@end

