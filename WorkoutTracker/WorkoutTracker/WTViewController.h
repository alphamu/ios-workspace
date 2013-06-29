//
//  WTViewController.h
//  WorkoutTracker
//
//  Created by Ali Muzaffar on 29/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTPlanChangeDelegate.h"

@interface WTViewController : UIViewController <WTPlanChangeDelegate>
@property (retain, nonatomic) IBOutlet UITableView *plans;
@property (retain, nonatomic) IBOutlet UILabel *empty;

@end
