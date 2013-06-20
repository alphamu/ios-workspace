//
//  APPDetailsViewController.m
//  RSSReaderOldSchool
//
//  Created by Ali Muzaffar on 14/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import "APPDetailsViewController.h"
#import "Favorite.h"

@interface APPDetailsViewController () {
    UIBarButtonItem *btnFav;
    UIImage *favImage;
    UIImage *favImageSelected;
    Favorite *favorite;
}
- (IBAction)favoriteClicked:(id)sender;
@end

@implementation APPDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Details";
    
    NSURL *myURL = [NSURL URLWithString: [self.url stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:myURL];
    [self.webView loadRequest:urlRequest];
    
    //add favorite in nav bar
    
    favImage = [UIImage imageNamed:@"ic_action_star_0.png"];
    favImageSelected = [UIImage imageNamed:@"ic_action_star_10.png"];
    
    btnFav = [[UIBarButtonItem alloc]
                                initWithImage:favImage landscapeImagePhone:nil
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(favoriteClicked:)];
    
    self.navigationItem.rightBarButtonItem = btnFav;
    
    //create a new request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //specify which entity to fetch from.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    request.predicate = [NSPredicate predicateWithFormat:@"title LIKE %@", self.articleTitle];
    NSLog(@"request = %@", request);
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    //favorite = [[self.managedObjectContext executeFetchRequest:request error:&error] objectAtIndex:0]; //possible implementation
    NSLog(@"array count %d", mutableFetchResults.count);
    
    if (mutableFetchResults == nil) {
        // Handle the error.
    } else if([mutableFetchResults count] > 0) {
        favorite = [mutableFetchResults objectAtIndex:0];
        btnFav.image = favImageSelected;
    }
    
    //    [mutableFetchResults release]; //ARC not needed
    //    [request release]; //ARC not needed

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)favoriteClicked:(id)sender
{
    if(sender == btnFav) {
        NSLog(@"Fav");
        if(btnFav.image == favImage) {
            NSLog(@"Favorte Image");
            
            //create a new event object
            favorite = (Favorite *)[NSEntityDescription insertNewObjectForEntityForName:@"Favorite" inManagedObjectContext:self.managedObjectContext];
            [favorite setTitle:self.articleTitle];
            [favorite setUrl:self.url];
            
            //save the changes
            NSError *error = nil;
            if (![self.managedObjectContext save:&error]) {
                // Handle the error.
                
            } else {
                //change the star to filled star
                btnFav.image = favImageSelected;
            }
        }
        else if(btnFav.image == favImageSelected) {
            NSLog(@"Favorte Image Selected");
            btnFav.image = favImage;
            if(favorite != nil) {
                //delete
                [self.managedObjectContext deleteObject:favorite];
                
                // Commit the change.
                NSError *error = nil;
                if (![self.managedObjectContext save:&error]) {
                    // Handle the error.
                } else {
                    btnFav.image = favImage;
                }
            } else {
                btnFav.image = favImage;
            }
        }
    } else {
        NSLog(@"Something went wrong");
    }
}

@end
