//
//  APPViewController.m
//  RSSReaderOldSchool
//
//  Created by Ali Muzaffar on 14/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import "APPViewController.h"
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
    
}

-(IBAction)findClicked:(id)sender;


@end

@implementation APPViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Stories";
	// Do any additional setup after loading the view, typically from a nib.
    feeds = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://images.apple.com/main/rss/hotnews/hotnews.rss"];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
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
    return 3;
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        url = [displayFeeds[indexPath.row] objectForKey: @"link"];
    }
    else {
        url = [feeds[indexPath.row] objectForKey: @"link"];
    }
    APPDetailsViewController *details = [[APPDetailsViewController alloc] initWithNibName:@"APPDetailsViewController" bundle:nil];
    [details setUrl:url];
    [self.navigationController pushViewController:details animated:YES];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
