//
//  ResaleAppDelegate.h
//  Resale
//
//  Created by A Jesse Jiryu Davis on 5/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface AppDelegate : NSObject <UIApplicationDelegate> {
  NSManagedObjectModel*         _managedObjectModel;
  NSManagedObjectContext*       _managedObjectContext;
  NSPersistentStoreCoordinator* _persistentStoreCoordinator;

  // App State
  BOOL                          _modelCreated;
  BOOL                          _resetModel;
}

@property (nonatomic, retain, readonly) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, readonly)         NSString*               applicationDocumentsDirectory;


@end

