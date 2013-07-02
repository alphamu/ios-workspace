//
//  WTAddRoutineViewController.m
//  WorkoutTracker
//
//  Created by Ali Muzaffar on 2/07/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import "WTAddRoutineViewController.h"
#import "WTAddExercisesViewController.h"

@interface WTAddRoutineViewController () {
    UIBarButtonItem *btnNext;
}
@end

@implementation WTAddRoutineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        btnNext = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(onSaveClicked:)];
        self.navigationItem.rightBarButtonItem = btnNext;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) onSaveClicked:(id)sender
{
    WTAddExercisesViewController *routine = [[WTAddExercisesViewController alloc] initWithNibName:@"WTAddExercisesViewController" bundle:nil];
    [self.navigationController pushViewController:routine animated:YES];
    [routine release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [btnNext release];
    
    [super dealloc];
}

@end
