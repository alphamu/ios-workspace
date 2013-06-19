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
    IBOutlet UISearchBar *searchBar;
    BOOL searching;
    BOOL letUserSelectRow;
    
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
//    [displayFeeds removeObjectAtIndex:0];
    
    UIBarButtonItem *btnFind = [[UIBarButtonItem alloc]
                                initWithTitle:@"Find"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(findClicked:)];
    self.navigationItem.rightBarButtonItem = btnFind;
    
    //Add the search bar
    //self.tableView.tableHeaderView = searchBar;
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    [searchBar setDelegate:self];
    //[self.tableView sizeToFit];
    
    searching = NO;
    letUserSelectRow = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return displayFeeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    //cell.textLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
    NSString *text = [[displayFeeds objectAtIndex:indexPath.row] objectForKey: @"title"];
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
    NSString *url = [displayFeeds[indexPath.row] objectForKey: @"link"];
    APPDetailsViewController *details = [[APPDetailsViewController alloc] initWithNibName:@"APPDetailsViewController" bundle:nil];
    [details setUrl:url];
    [self.navigationController pushViewController:details animated:YES];
}

- (BOOL) searchBarShouldBeginEditing:(UISearchBar *)_searchBar
{

    [searchBar setShowsCancelButton:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText
{
    NSLog(@"Search Text: %@",searchText);
    [displayFeeds removeAllObjects];
    for (int i = 0; i < [feeds count]; i++)
    {
        NSMutableDictionary *found = [feeds objectAtIndex:i];
        NSString *t = [found objectForKey:@"title"];
        if ([t containsString:searchText options:NSCaseInsensitiveSearch]) {
            NSLog(@"%@",t);
            [displayFeeds addObject:found];
        }
        else if (searchText == nil || [searchText length] == 0) {
            [displayFeeds addObject:found];
        }
        
    }
    
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar
{
    NSLog(@"cancel");
    [searchBar setShowsCancelButton:NO];
    [searchBar setText:nil];
    [searchBar resignFirstResponder];
    self.tableView.tableHeaderView = nil;
    [displayFeeds removeAllObjects];
    [displayFeeds addObjectsFromArray:feeds];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
    //do nothing, hopefully we are filtering as the user types.
    NSLog(@"search");
    [self searchBarCancelButtonClicked:_searchBar];
}

-(IBAction)findClicked:(id)sender
{
    NSLog(@"Click");
    if(searchBar.superview == nil) {
        searchBar.alpha = 0.0;
        [UIView beginAnimations:@"animation" context:nil];
        [UIView setAnimationDuration:0.6];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.tableView.tableHeaderView = searchBar;
        searchBar.alpha = 1.0;
        [UIView commitAnimations];
        [searchBar becomeFirstResponder];
    }

    else {
        [self searchBarCancelButtonClicked:searchBar];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
