//
//  WTModifyPlanViewController.h
//  WorkoutTracker
//
//  Created by Ali Muzaffar on 29/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTPlanChangeDelegate.h"

@interface WTModifyPlanViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<WTPlanChangeDelegate> delegate;
@property (retain, nonatomic) IBOutlet UITableView *routines;

@property (retain, nonatomic) IBOutlet UIButton *btnAddRoutine;
@property (retain, nonatomic) IBOutlet UITextField *txtPlanName;
@property (retain, nonatomic) IBOutlet UIButton *btnDeleteRoutine;

-(IBAction)onAddRoutineClicked:(id)sender;
-(IBAction)onEditRoutineClicked:(id)sender;

@end
