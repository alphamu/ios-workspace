//
//  APPDetailsViewController.h
//  RSSReaderOldSchool
//
//  Created by Ali Muzaffar on 14/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPStorySelectionDelegate.h"
#import "APPViewController.h"

@interface APPDetailsViewController : UIViewController <UIPopoverControllerDelegate, APPStorySelectionDelegate>

@property (weak, nonatomic) NSString *url;
@property (weak, nonatomic) NSString *articleTitle;
@property (weak, nonatomic) NSString *description;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) UIPopoverController *popController;

@property (nonatomic, assign) UINavigationController *stories;

@end
