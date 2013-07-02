//
//  WTViewController.m
//  WorkoutTracker
//
//  Created by Ali Muzaffar on 29/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import "WTViewController.h"
#import "WTModifyPlanViewController.h"
#import "WTAddPlanViewController.h"

@interface WTViewController () {
    UIBarButtonItem *btnAdd;
}
- (void) onAddClicked:(id) sender;
- (void) showWorkoutPlans:(BOOL) show;
- (void) showEmptyNotification:(BOOL) show;
@end

@implementation WTViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"Workout Plans"];
        [self showWorkoutPlans:NO];
        [self showEmptyNotification:YES];
        btnAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddClicked:)];
        self.navigationItem.rightBarButtonItem = btnAdd;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib
    
}

- (void) showWorkoutPlans:(BOOL) show
{
    if(show) {
        [self.view addSubview:_plans];
        
    } else {
        [_plans removeFromSuperview];
    }
}

- (void) showEmptyNotification:(BOOL) show
{
    if(show) {
        // center in view whether iPad or iPhone. with 20px padding (for iPhone).
        // offset x 20px to add padding, reduce width 40px (instead of 20)
        // to adjust for the 20px padding.
        UIView *parentView = self.parentViewController.view;
        [_empty setFrame:CGRectMake(20, 0, parentView.frame.size.width - 40, _empty.frame.size.height)];
        
        [self.view addSubview:_empty];
        
    } else {
        [_empty removeFromSuperview];
    }
}

- (void)onAddClicked:(id)sender
{
    WTAddPlanViewController *modify = [[WTAddPlanViewController alloc] initWithNibName:@"WTAddPlanViewController" bundle:nil];
    modify.delegate = self;
    [self.navigationController pushViewController:modify animated:YES];
    [modify release];
}

- (void) refresh
{
    [self showWorkoutPlans:YES];
    [self showEmptyNotification:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_plans release];
    [_empty release];
    
    [btnAdd release];
    [super dealloc];
}
@end
