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
}

@property (nonatomic, retain, readonly) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, readonly)         NSString*               applicationDocumentsDirectory;
@property (nonatomic, retain)			SA_OAuthTwitterEngine* twitterEngine;
@property (nonatomic, retain)			CLLocationManager* locationManager;

@end

