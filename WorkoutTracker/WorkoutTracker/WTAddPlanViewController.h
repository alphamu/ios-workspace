//
//  WTAddPlanViewController.h
//  WorkoutTracker
//
//  Created by Ali Muzaffar on 2/07/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTPlanChangeDelegate.h"

@interface WTAddPlanViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, assign) id<WTPlanChangeDelegate> delegate;
@property (retain, nonatomic) IBOutlet UITextField *txtPlanName;

@end
