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

@property (retain) NSMutableArray *thingsToLearn;
@property (retain) NSMutableArray *thingsLearned;

@end

@implementation WTModifyPlanViewController

-(void)viewDidUnload
{
    [self setThingsToLearn:nil];
    [self setThingsLearned:nil];
    
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
    self.thingsToLearn = [[NSMutableArray alloc] initWithArray:@[@"Drawing Rects", @"Drawing Gradients", @"Drawing Arcs"]];
    self.thingsLearned = [[NSMutableArray alloc] initWithArray:@[@"Table Views", @"UIKit", @"Objective-C"]];
    
    //    [self.routines setDelegate:self]; //set in the nib
    //    [self.routines setDataSource:self]; //set in the nib
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(indexPath.section == 0)
           [self.thingsToLearn removeObjectAtIndex:indexPath.row];
        else if (indexPath.section == 1)
            [self.thingsLearned removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        if(indexPath.section == 0)
            [self.thingsToLearn insertObject:@"Insert" atIndex:indexPath.row];
        else if (indexPath.section == 1)
            [self.thingsLearned insertObject:@"Insert" atIndex:indexPath.row];
        
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)onAddRoutineClicked:(id)sender {
    editingStyle = UITableViewCellEditingStyleInsert;
    if([self.routines isEditing]) {
        [self.routines setEditing:NO animated:YES];
    } else {
        [self.routines setEditing:YES animated:YES];
    }
    
}

-(void)onEditRoutineClicked:(id)sender {
    editingStyle = UITableViewCellEditingStyleDelete;
    if([self.routines isEditing]) {
        [self.routines setEditing:NO animated:YES];
    } else {
        [self.routines setEditing:YES animated:YES];
    }
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

- (void)dealloc {
    [_routines release];
    [_btnAddRoutine release];
    [_txtPlanName release];
    [_btnAddRoutine release];
    [_btnDeleteRoutine release];
    [super dealloc];
}
@end
