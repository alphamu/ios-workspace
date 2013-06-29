//
//  WTAppDelegate.h
//  WorkoutTracker
//
//  Created by Ali Muzaffar on 29/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) UINavigationController *navController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
