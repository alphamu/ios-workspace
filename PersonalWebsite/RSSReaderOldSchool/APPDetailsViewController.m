//
//  APPDetailsViewController.m
//  RSSReaderOldSchool
//
//  Created by Ali Muzaffar on 14/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import "APPDetailsViewController.h"
#import "APPViewController.h"
#import "Favorite.h"
#import "Reachability.h"

@interface APPDetailsViewController () {
    UIBarButtonItem *btnFav;
    UIImage *favImage;
    UIImage *favImageSelected;
    Favorite *favorite;
    
    Reachability *internetReachableFoo;
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
//    [self initEverything];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && orientation == UIInterfaceOrientationPortrait ) {
        [self testInternetConnection];
    } else {
        [self initEverything];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)  name:UIDeviceOrientationDidChangeNotification  object:nil];
}

-(void) orientationChanged:(NSNotification *)notification {
    NSLog(@"orientationChanged");
    
    [self initEverything];

    if(self.popController != nil && [self.popController isPopoverVisible]) {
        [self.popController dismissPopoverAnimated:YES];
        self.popController = nil;
    }
        

}

- (void)initEverything {
    
    self.title = self.articleTitle;
    
    NSURL *myURL = [NSURL URLWithString: [[self.url stringByReplacingOccurrencesOfString:@" " withString:@""] stringByAddingPercentEscapesUsingEncoding:
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
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && orientation == UIInterfaceOrientationPortrait )
    {
        UIBarButtonItem *list = [[UIBarButtonItem alloc]
                                 initWithTitle:@"Stories"
                                 style:UIBarButtonItemStyleBordered
                                 target:self
                                 action:@selector(toolbarItemTapped:)];
        
        self.navigationItem.leftBarButtonItem = list;
        
    } else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    if(self.url == nil)
        return;
    
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

- (void)toolbarItemTapped:(id)sender
{
    if(self.popController.popoverVisible) {
        [self.popController dismissPopoverAnimated:NO];
        return;
    } else {
        if(self.popController == nil) {
            UIPopoverController* aPopover = [[UIPopoverController alloc]
                                             initWithContentViewController:self.stories];
            aPopover.delegate = self;
            
            
            // Store the popover in a custom property for later use.
            self.popController = aPopover;
        }
    }
    
    [self.popController presentPopoverFromBarButtonItem:sender
                               permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}
-(void)selectedStory:(NSString *)articleTitle url:(NSString *)url
{
    NSLog(@"Story Selected");
    if(![self.url isEqualToString:url]) {
        [self setUrl:url];
        [self setArticleTitle:articleTitle];
        [self initEverything];
    }
    if(self.popController != nil && self.popController.popoverVisible) {
        [self.popController dismissPopoverAnimated:YES];
    }
}

// Checks if we have an internet connection or not
- (void)testInternetConnection
{
    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    APPDetailsViewController *this = self;
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Yayyy, we have the interwebs!");
            if(this.url == nil) {
                this.title = @"<-- Click \"Stories\" to continue";
                [this.webView loadHTMLString:@"<center>Click the \"Stories\" button in the top left corner to continue.</center>" baseURL:nil];
            }
        });
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Someone broke the internet :(");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                            message:@"You must be connected to the internet to use this app."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        });
    };
    
    [internetReachableFoo startNotifier];
}


@end
