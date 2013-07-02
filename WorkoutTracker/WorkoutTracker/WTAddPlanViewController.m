//
//  WTAddPlanViewController.m
//  WorkoutTracker
//
//  Created by Ali Muzaffar on 2/07/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import "WTAddPlanViewController.h"
#import "WTAddRoutineViewController.h"

@interface WTAddPlanViewController ()
{
    UIBarButtonItem *btnNext;
}

@end

@implementation WTAddPlanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        btnNext = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(onSaveClicked:)];
        self.navigationItem.rightBarButtonItem = btnNext;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) onSaveClicked:(id)sender
{
    WTAddRoutineViewController *routine = [[WTAddRoutineViewController alloc] initWithNibName:@"WTAddRoutineViewController" bundle:nil];
    [self.navigationController pushViewController:routine animated:YES];
    [routine release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)dealloc {
    [_txtPlanName release];
    
    [btnNext release];
    
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTxtPlanName:nil];
    
    [super viewDidUnload];
}
@end
