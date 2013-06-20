//
//  APPViewController.h
//  RSSReaderOldSchool
//
//  Created by Ali Muzaffar on 14/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPStorySelectionDelegate.h"

@interface APPViewController : UITableViewController <NSXMLParserDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

//@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, assign) id<APPStorySelectionDelegate> delegate;

@end
