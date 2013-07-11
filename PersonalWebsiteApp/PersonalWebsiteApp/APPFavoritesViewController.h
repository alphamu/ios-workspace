//
//  APPFavoritesViewController.h
//  PersonalWebsiteApp
//
//  Created by Ali Muzaffar on 7/07/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPStorySelectionDelegate.h"

@interface APPFavoritesViewController : UITableViewController

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, assign) id<APPStorySelectionDelegate> delegate;

@end
