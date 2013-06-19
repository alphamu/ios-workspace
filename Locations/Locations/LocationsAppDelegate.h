//
//  LocationsAppDelegate.h
//  Locations
//
//  Created by Ali Muzaffar on 18/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationsAppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *navigationController;
}

@property (strong, nonatomic) IBOutlet UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) UINavigationController *navigationController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
