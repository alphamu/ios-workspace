//
//  APPViewController.m
//  RSSReaderOldSchool
//
//  Created by Ali Muzaffar on 14/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import "APPViewController.h"
#import "APPDetailsViewController.h"
#import "APPStorySelectionDelegate.h"
#import "Reachability.h"
#import "CustomCellBackground.h"
#import "CustomHeader.h"

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

@interface APPViewController ()
{
    
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableArray *displayFeeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *description;
    NSString *element;
    UISearchBar *searchBar;
    UISearchDisplayController *searchController;
    
    Reachability *internetReachableFoo;
    
    NSArray *sections;
    NSMutableArray *sectionsCount;
    int tempCount;
    
    UIActivityIndicatorView *activityIndicator;
    
}

-(IBAction)findClicked:(id)sender;


@end

@implementation APPViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = self.tableView.rowHeight + 6;
    
    sections = @[@"http://alimuzaffar.com/index.php/development-work?format=feed&type=rss",
                 @"http://alimuzaffar.com/index.php/blog?format=feed&type=rss",
                 @"http://alimuzaffar.com/index.php/health-a-fitness?format=feed&type=rss"];
    sectionsCount = [@[[NSNumber numberWithInt:0], [NSNumber numberWithInt:0],[NSNumber numberWithInt:0]] mutableCopy];
    
    self.title = @"Stories";
    
    //loading indicator
    activityIndicator = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator startAnimating];
    
    CGRect acFrame = activityIndicator.frame;
    acFrame.origin.x = 10;
    acFrame.origin.y = 10;
    activityIndicator.frame = acFrame;
    
    //    CGRectInset(rect, dx, dy)
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, 35);
    CGRect loadingFrame = CGRectMake(0, 0, self.view.bounds.size.width, 25);
    loadingFrame.origin.x = 10 + activityIndicator.bounds.size.width + 10;
    loadingFrame.origin.y = 8;
    UILabel *loading = [[UILabel alloc] initWithFrame:loadingFrame];
    UIColor *gray = [UIColor grayColor];
    [loading setBackgroundColor:[UIColor clearColor]];
    [loading setTextColor:gray];
    loading.text = @"Loading...";
    
    //put the activity indicator and loading label in a view
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    [view addSubview:activityIndicator];
    [view addSubview:loading];
    
    self.tableView.tableHeaderView = view;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && orientation != UIInterfaceOrientationPortrait) {
        [self testInternetConnection];
    } else {
        [self getNetworkDataOnBackground];
    }
}

-(void) initEverything
{
    
    displayFeeds = [[NSMutableArray alloc] initWithArray:feeds];
    
    UIBarButtonItem *btnFind = [[UIBarButtonItem alloc]
                                initWithTitle:@"Find"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(findClicked:)];
    self.navigationItem.rightBarButtonItem = btnFind;
    
    //Add the search bar
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    searchController.delegate = self;
    searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
    [searchController setActive:NO animated:NO];
    
    if([feeds count] > 0 && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:self.tableView didSelectRowAtIndexPath:scrollIndexPath];
        //        [self.tableView selectRowAtIndexPath:scrollIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return [sections count];
    } else
        return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return displayFeeds.count;
    if (tableView == self.tableView) {
        //return [feeds count];
        return [[sectionsCount objectAtIndex:section] integerValue];
    }
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return [displayFeeds count];
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (tableView == self.tableView) {
        if(section == 0)
            return @"Development work";
        else if(section == 1)
            return @"Blog";
        else if(section == 2)
            return @"Health and fitness";
    }
    
    return nil;
}

// Add new methods
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomHeader * header = [[CustomHeader alloc] init];
    header.titleLabel.text = [self tableView: tableView titleForHeaderInSection:section];
    
    // START NEW
    if (section%2 == 1) {
        header.lightColor = [UIColor colorWithRed:147.0/255.0 green:105.0/255.0 blue:216.0/255.0 alpha:1.0];
        header.darkColor = [UIColor colorWithRed:72.0/255.0 green:22.0/255.0 blue:137.0/255.0 alpha:1.0];
    }
    // END NEW
    return header;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [self tableView: tableView titleForHeaderInSection:section];
    if(sectionTitle == nil) {
        return 0;
    }
    return 50;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [[cell detailTextLabel] setLineBreakMode:UILineBreakModeTailTruncation];
        
        // START NEW
        if (![cell.backgroundView isKindOfClass:[CustomCellBackground class]]) {
            cell.backgroundView = [[CustomCellBackground alloc] init];
        }
        
        if (![cell.selectedBackgroundView isKindOfClass:[CustomCellBackground class]]) {
            cell.selectedBackgroundView = [[CustomCellBackground alloc] init];
        }
        
        cell.textLabel.backgroundColor = [UIColor clearColor]; // NEW
        cell.detailTextLabel.backgroundColor = [UIColor clearColor]; // NEW
        // END NEW
    }
    
    NSString *text;
    NSString *details;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        text = [[displayFeeds objectAtIndex:indexPath.row] objectForKey: @"title"];
        details = [[displayFeeds objectAtIndex:indexPath.row] objectForKey: @"description"];
    } else {
        NSNumber *c = [sectionsCount objectAtIndex:indexPath.section];
        int rowNumber = (indexPath.row + (indexPath.section * [c integerValue]));
        if(indexPath.section == 1)
            rowNumber += 1;
        else if(indexPath.section > 1)
            rowNumber -=1;
        text = [[feeds objectAtIndex:rowNumber] objectForKey:@"title"];
        details = [[feeds objectAtIndex:rowNumber] objectForKey: @"description"];
    }
    
    [cell.textLabel setText:text];
    NSRange r;
    NSString *s = [details copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    
    [cell.detailTextLabel setText:s];
    
    return cell;
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    if ([element isEqualToString:@"item"]) {
        
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        description = [[NSMutableString alloc] init];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]) {
        [link appendString:string];
    } else if ([element isEqualToString:@"description"]) {
        [description appendString:string];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        [item setObject:description forKey:@"description"];
        
        [feeds addObject:[item copy]];
        tempCount = tempCount + 1;
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *url;
    NSString *text;
    NSString *desc;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        url = [displayFeeds[indexPath.row] objectForKey: @"link"];
        text = [displayFeeds[indexPath.row] objectForKey: @"title"];
        desc = [displayFeeds[indexPath.row] objectForKey: @"description"];
    }
    else {
        NSNumber *c = [sectionsCount objectAtIndex:indexPath.section];
        int rowNumber = (indexPath.row + (indexPath.section * [c integerValue]));
        if(indexPath.section == 1)
            rowNumber += 1;
        else if(indexPath.section > 1)
            rowNumber -=1;
        url = [feeds[rowNumber] objectForKey: @"link"];
        text = [feeds[rowNumber] objectForKey: @"title"];
        desc = [feeds[rowNumber] objectForKey: @"description"];
    }
    
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

-(void)findClicked:(id)sender
{
    NSLog(@"findClicked");
    if(searchBar.superview == nil) {
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        self.tableView.tableHeaderView = searchBar;
        [searchController setActive:YES animated:YES];
        [searchBar becomeFirstResponder];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"shouldReloadTableForSearchString: %@", searchString);
    [displayFeeds removeAllObjects];
    for (int i = 0; i < [feeds count]; i++)
    {
        NSMutableDictionary *found = [feeds objectAtIndex:i];
        NSString *t = [found objectForKey:@"title"];
        if ([t containsString:searchString options:NSCaseInsensitiveSearch]) {
            NSLog(@"%@",t);
            [displayFeeds addObject:found];
        }
        else if (searchString == nil || [searchString length] == 0) {
            [displayFeeds addObject:found];
        }
    }
    
    return YES;
    
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    NSLog(@"willEndSearch");
    self.tableView.tableHeaderView = nil;
}

- (void) getNetworkDataOnBackground
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //fetch
        APPViewController *this = self;
        
        // Do any additional setup after loading the view, typically from a nib.
        feeds = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [sections count]; i++) {
            tempCount = 0;
            NSURL *url = [NSURL URLWithString:[sections objectAtIndex:i]];
            parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
            [parser setDelegate:self];
            [parser setShouldResolveExternalEntities:NO];
            [parser parse];
            [sectionsCount replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:tempCount]];
        }
        
        //remove loading indicator
        [activityIndicator stopAnimating];
        self.tableView.tableHeaderView = nil;
        NSLog(@"Done fetching");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [this initEverything];
        });
    });
}
// Checks if we have an internet connection or not
- (void)testInternetConnection
{
    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    APPViewController *this = self;
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [this getNetworkDataOnBackground];
        });
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"List: No network connection"
                                                            message:@"You must be connected to the internet to use this app."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        });
    };
    
    [internetReachableFoo startNotifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
