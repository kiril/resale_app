//
//  ResaleAppDelegate.m
//  Resale
//
//  Created by A Jesse Jiryu Davis on 5/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AppDelegate.h"

#define kStoreType      NSSQLiteStoreType
#define kStoreFilename  @"db.sqlite"

#import "RSTabController.h"
#import "RSCreatePostController.h"
#import "RSSearchPostsController.h"
#import "RSUserPostsController.h"
#import "RSPostDetailController.h"
#import "RSStylesheet.h"
#import "Constants.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface AppDelegate()
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSString *)applicationDocumentsDirectory;

@end


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AppDelegate

@synthesize twitterEngine=_twitterEngine, locationManager=_locationManager;

- (void)cachePost:(NSDictionary*)post forShortCode:(NSString*)shortCode {
	[_shortCodeToPost setObject:post forKey:shortCode];
}

// Get a post from cache or retrieve from server - intended to be called in bg
- (NSDictionary*)postForShortCode:(NSString*)shortCode {
	// TODO: Get from server if not in cache
	return [_shortCodeToPost objectForKey:shortCode];
}

- (void)clearPostCache {
	[_shortCodeToPost removeAllObjects];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// Forcefully removes the model db and recreates it.
	//_resetModel = YES;
	_shortCodeToPost = [NSMutableDictionary new];
	
	self.twitterEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
	self.twitterEngine.consumerKey = twitterConsumerKey;
	self.twitterEngine.consumerSecret = twitterConsumerSecret;
	
	[TTStyleSheet setGlobalStyleSheet:[[[RSStylesheet alloc]  
																			init] autorelease]];  
	
	// TODO ajdavis: test all nav paths' persistence
	TTNavigator* navigator = [TTNavigator navigator];
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	navigator.window = [[[UIWindow alloc] initWithFrame:TTScreenBounds()] autorelease];

	TTURLMap* map = navigator.URLMap;

	[map from:@"*" toViewController:[TTWebController class]];

	[map from:@"resale://tabs" toSharedViewController:[RSTabController class]];
	[map from:@"resale://create_post" toSharedViewController:[RSCreatePostController class]];
	// TODO: include lat/long/query arguments to search_posts so we can persist the user's search
//	[map from:@"resale://search_posts" toSharedViewController:[RSSearchPostsController class]];
//	[map                   from:@"resale://post_detail?short_code=(initWithShortCode:)"
//											 parent:@"resale://search_posts"
//						 toViewController:[RSPostDetailController class]
//										 selector:nil
//									 transition:0];
	[map from:@"resale://user_posts" toSharedViewController:[RSUserPostsController class]];
	
	
	if (![navigator restoreViewControllers]) {
		[navigator openURLAction:[TTURLAction actionWithURLPath:@"resale://tabs"]];
	}
	
	self.locationManager = [[CLLocationManager new] autorelease];
	self.locationManager.delegate = self;
	self.locationManager.distanceFilter = 50;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[self.locationManager startUpdatingLocation];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
	self.twitterEngine = self.locationManager = nil;
	TT_RELEASE_SAFELY(_managedObjectContext);
	TT_RELEASE_SAFELY(_managedObjectModel);
	TT_RELEASE_SAFELY(_persistentStoreCoordinator);
	TT_RELEASE_SAFELY(_shortCodeToPost);

	[super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)navigator:(TTNavigator*)navigator shouldOpenURL:(NSURL*)URL {
  return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
  [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
  return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationWillTerminate:(UIApplication *)application {
  NSError* error = nil;
  if (_managedObjectContext != nil) {
    if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager: (CLLocationManager *)manager
	didUpdateToLocation: (CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	// TODO: periodically refresh location, say, restart every 30 seconds
	// while in search or map views?
	[manager stopUpdatingLocation];
	NSLog(@"Location is (%.2f, %.2f)",
		  newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}

- (void)locationManager: (CLLocationManager *)manager
	   didFailWithError: (NSError *)error
{
	NSLog(@"Location error: %@", error);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Core Data stack


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSManagedObjectContext*)managedObjectContext {
  if( _managedObjectContext != nil ) {
    return _managedObjectContext;
  }
	
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil) {
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    [_managedObjectContext setUndoManager:nil];
    [_managedObjectContext setRetainsRegisteredObjects:YES];
  }
  return _managedObjectContext;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSManagedObjectModel*)managedObjectModel {
  if( _managedObjectModel != nil ) {
    return _managedObjectModel;
  }
  _managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
  return _managedObjectModel;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)storePath {
  return [[self applicationDocumentsDirectory]
    stringByAppendingPathComponent: kStoreFilename];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSURL*)storeUrl {
  return [NSURL fileURLWithPath:[self storePath]];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDictionary*)migrationOptions {
  return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSPersistentStoreCoordinator*)persistentStoreCoordinator {
  if( _persistentStoreCoordinator != nil ) {
    return _persistentStoreCoordinator;
  }

  NSString* storePath = [self storePath];
  NSURL *storeUrl = [self storeUrl];

	NSError* error;
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
    initWithManagedObjectModel: [self managedObjectModel]];

  NSDictionary* options = [self migrationOptions];

  // Check whether the store already exists or not.
  NSFileManager* fileManager = [NSFileManager defaultManager];
  BOOL exists = [fileManager fileExistsAtPath:storePath];

  TTDINFO(storePath);
  if( !exists ) {
    _modelCreated = YES;
  } else {
    if( _resetModel ||
        [[NSUserDefaults standardUserDefaults] boolForKey:@"erase_all_preference"] ) {
      [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"erase_all_preference"];
      [fileManager removeItemAtPath:storePath error:nil];
      _modelCreated = YES;
    }
  }

  if (![_persistentStoreCoordinator
    addPersistentStoreWithType: kStoreType
                 configuration: nil
                           URL: storeUrl
                       options: options
                         error: &error
  ]) {
    // We couldn't add the persistent store, so let's wipe it out and try again.
    [fileManager removeItemAtPath:storePath error:nil];
    _modelCreated = YES;

    if (![_persistentStoreCoordinator
      addPersistentStoreWithType: kStoreType
                   configuration: nil
                             URL: storeUrl
                         options: nil
                           error: &error
    ]) {
      // Something is terribly wrong here.
    }
  }

  return _persistentStoreCoordinator;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Application's documents directory


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)applicationDocumentsDirectory {
  return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
    lastObject];
}


@end

