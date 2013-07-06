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
    
    NSString *template;
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
//    NSLog(@"Available fonts: %@", [UIFont familyNames]);
    
    template = @"<html><head>\
    </head>\
    <style>\
    body { font-family: Verdana, Gill Sans, Arial; font-size: .9em; margin: 1em; background: url('subtle_stripes.png'); } \
    a { color:#FFFF00; text-decoration: none; }\
    div { background: url(graybg.png); color: #fff; padding: 10px; border-radius: 10px; -moz-border-radius: 10px overflow; word-wrap:break-word; } \
    </style>\
    <body><div>\
    %@\
    </div></body>\
    </html>";
    
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

}

- (void)releasePopover
{
    [self.popController dismissPopoverAnimated:NO];
    self.popController.delegate = nil;
    self.popController = nil;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"willRotateToInterfaceOrientation");
    if ([self.popController isPopoverVisible]){
        [self.popController dismissPopoverAnimated:NO];
        NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(releasePopover) object:nil];
        [[NSOperationQueue mainQueue] addOperation:invocationOperation];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self releasePopover];
}

- (void)initEverything {
    
    self.title = self.articleTitle;
    
    //NSURL *myURL = [NSURL URLWithString: [[self.url stringByReplacingOccurrencesOfString:@" " withString:@""] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //NSURLRequest *urlRequest = [NSURLRequest requestWithURL:myURL];
    //[self.webView loadRequest:urlRequest];
    
    //[self.webView loadHTMLString:self.description baseURL:[NSURL URLWithString:@"http://alimuzaffar.com"]];
    [self.webView loadHTMLString:[NSString stringWithFormat:template, self.description] baseURL:[[NSBundle mainBundle] bundleURL]];
    //NSLog(self.description);
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
-(void)selectedStory:(NSString *)articleTitle url:(NSString *)url description:(NSString *)description
{
    NSLog(@"Story Selected");
    if(![self.url isEqualToString:url]) {
        [self setUrl:url];
        [self setArticleTitle:articleTitle];
        [self setDescription:description];
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
    __unsafe_unretained typeof(self) this = self;
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Yayyy, we have the interwebs!");
            if(this.url == nil) {
                this.title = @"<-- Click \"Stories\" to continue";
                [this.webView loadHTMLString:[NSString stringWithFormat:this->template, @"<center>Click the \"Stories\" button in the top left corner to continue.</center>"] baseURL:[[NSBundle mainBundle] bundleURL] ];
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
