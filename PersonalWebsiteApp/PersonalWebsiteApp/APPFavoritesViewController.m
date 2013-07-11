//
//  APPFavoritesViewController.m
//  PersonalWebsiteApp
//
//  Created by Ali Muzaffar on 7/07/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import "APPFavoritesViewController.h"
#import "Favorite.h"
#import "APPDetailsViewController.h"

@interface NSString (JRStringAdditions)

- (BOOL)containsString:(NSString *)string;
- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options;

@end

@implementation NSString (JRStringAdditions)

- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL)containsString:(NSString *)string {
    return [self containsString:string options:0];
}

@end

@interface APPFavoritesViewController () {
    NSMutableArray *favoritesArray;
}

@end

@implementation APPFavoritesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Favorites"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self fetchFavoritesSaved];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"favorites count %d", favoritesArray.count);
    return [favoritesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    Favorite *item = [favoritesArray objectAtIndex:indexPath.row];
    NSString *title = [NSString stringWithString:item.title];
    NSString *desc = [NSString stringWithString:item.desc];
    
    [cell.textLabel setText:title];
    
    NSRange r;
    NSString *s = [desc copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    
    [cell.detailTextLabel setText:s];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *url;
    NSString *text;
    NSString *desc;
    
    Favorite *item = favoritesArray[indexPath.row];
    url = item.url;
    text = item.title;
    desc = item.desc;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if(self.delegate) {
            [self.delegate selectedStory:text url:url description:desc];
        }
    } else {
        APPDetailsViewController *details = [[APPDetailsViewController alloc] initWithNibName:@"APPDetailsViewController" bundle:nil];
        details.managedObjectContext = _managedObjectContext;
        [details setUrl:url];
        [details setArticleTitle:text];
        [details setDescription:desc];
        [self.navigationController pushViewController:details animated:YES];
    }
}

- (void) initEverything:(NSArray *) favorites
{
    favoritesArray = [favorites copy];
    
     NSLog(@"initEverything %d", [favoritesArray count]);
    
    [self.tableView reloadData];
    
}

- (void) fetchFavoritesSaved
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //fetch
        //remove loading indicator
        self.tableView.tableHeaderView = nil;

        //create a new request
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        //specify which entity to fetch from.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        NSLog(@"request = %@", request);
        
        NSError *error = nil;
        NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
        //favorite = [[self.managedObjectContext executeFetchRequest:request error:&error] objectAtIndex:0]; //possible implementation
        NSLog(@"array count %d", fetchResults.count);
        
        if (fetchResults == nil) {
            // Handle the error.
        } else if([fetchResults count] > 0) {
            NSLog(@"FOUND RESULTS %d", [fetchResults count]);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initEverything:fetchResults];
        });
        
    });

}

@end
