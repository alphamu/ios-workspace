//
//  WTModifyPlanViewController.m
//  WorkoutTracker
//
//  Created by Ali Muzaffar on 29/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import "WTModifyPlanViewController.h"

@interface WTModifyPlanViewController () {
    UITableViewCellEditingStyle editingStyle;
}

@property (copy) NSMutableArray *thingsToLearn;
@property (copy) NSMutableArray *thingsLearned;

@end

@implementation WTModifyPlanViewController

-(void)viewDidUnload
{
    [_delegate release];
    [_thingsToLearn release];
    [_thingsLearned release];
    
    [self setRoutines:nil];
    [self setBtnAddRoutine:nil];
    [self setTxtPlanName:nil];
    [self setBtnAddRoutine:nil];
    [self setBtnDeleteRoutine:nil];
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        editingStyle = UITableViewCellEditingStyleNone;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.thingsToLearn = [@[@"Drawing Rects", @"Drawing Gradients", @"Drawing Arcs"] mutableCopy];
    self.thingsLearned = [@[@"Table Views", @"UIKit", @"Objective-C"] mutableCopy];
    //    [_routines setDelegate:self]; //set in the nib
    //    [_routines setDataSource:self]; //set in the nib
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.thingsToLearn.count;
    } else {
        return self.thingsLearned.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSString * entry;
    
    if (indexPath.section == 0) {
        entry = self.thingsToLearn[indexPath.row];
    } else {
        entry = self.thingsLearned[indexPath.row];
    }
    cell.textLabel.text = entry;
    
    return cell;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Things We'll Learn";
    } else {
        return @"Things Already Covered";
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return editingStyle;
    
}

-(void)onAddRoutineClicked:(id)sender {
    editingStyle = UITableViewCellEditingStyleInsert;
    if([_routines isEditing]) {
        [_routines setEditing:NO animated:YES];
    } else {
        [_routines setEditing:YES animated:YES];
    }
    
}

-(void)onEditRoutineClicked:(id)sender {
    editingStyle = UITableViewCellEditingStyleDelete;
    if([_routines isEditing]) {
        [_routines setEditing:NO animated:YES];
    } else {
        [_routines setEditing:YES animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_routines release];
    [_btnAddRoutine release];
    [_txtPlanName release];
    [_btnAddRoutine release];
    [_btnDeleteRoutine release];
    [super dealloc];
}
@end
