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
    NSString *element;
    UISearchBar *searchBar;
    UISearchDisplayController *searchController;
    
    Reachability *internetReachableFoo;
    
}

-(IBAction)findClicked:(id)sender;


@end

@implementation APPViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && orientation != UIInterfaceOrientationPortrait) {
        [self testInternetConnection];
    } else {
        [self initEverything];
    }
}

-(void) initEverything
{
    self.title = @"Stories";
    
    //loading indicator
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]
                                   initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator startAnimating];
    
    CGRect acFrame = activityIndicator.frame;
    acFrame.origin.x = 10;
    acFrame.origin.y = 10;
    activityIndicator.frame = acFrame;
    
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, 25);
    CGRect loadingFrame = CGRectMake(0, 0, self.view.bounds.size.width, 25);
    loadingFrame.origin.x = 10 + activityIndicator.bounds.size.width + 10;
    loadingFrame.origin.y = 8;
    UILabel *loading = [[UILabel alloc] initWithFrame:loadingFrame];
    UIColor *gray = [UIColor grayColor];
    [loading setTextColor:gray];
    loading.text = @"Loading...";
    
    //put the activity indicator and loading label in a view
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    [view addSubview:activityIndicator];
    [view addSubview:loading];

    self.tableView.tableHeaderView = view;

    
	// Do any additional setup after loading the view, typically from a nib.
    feeds = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://images.apple.com/main/rss/hotnews/hotnews.rss"];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
    //remove loading indicator
    [activityIndicator stopAnimating];
    self.tableView.tableHeaderView = nil;
    
    
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
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return displayFeeds.count;
    if (tableView == self.tableView) {
        return [feeds count];
    }
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return [displayFeeds count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }

    NSString *text;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        text = [[displayFeeds objectAtIndex:indexPath.row] objectForKey: @"title"];
    } else {
        text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
    }

    [cell.textLabel setText:text];
    
    return cell;
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    if ([element isEqualToString:@"item"]) {
        
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]) {
        [link appendString:string];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        
        [feeds addObject:[item copy]];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *url;
    NSString *text;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        url = [displayFeeds[indexPath.row] objectForKey: @"link"];
        text = [displayFeeds[indexPath.row] objectForKey: @"title"];
    }
    else {
        url = [feeds[indexPath.row] objectForKey: @"link"];
        text = [feeds[indexPath.row] objectForKey: @"title"];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if(self.delegate) {
            [self.delegate selectedStory:text url:url];
        }
    } else {
        APPDetailsViewController *details = [[APPDetailsViewController alloc] initWithNibName:@"APPDetailsViewController" bundle:nil];
        details.managedObjectContext = _managedObjectContext;
        [details setUrl:url];
        [details setArticleTitle:text];
        [self.navigationController pushViewController:details animated:YES];
    }
}

-(IBAction)findClicked:(id)sender
{
    NSLog(@"findClicked");
    if(searchBar.superview == nil) {
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
            [this initEverything];
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

@end
