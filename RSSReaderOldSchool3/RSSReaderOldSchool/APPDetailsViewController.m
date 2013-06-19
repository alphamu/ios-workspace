//
//  APPDetailsViewController.m
//  RSSReaderOldSchool
//
//  Created by Ali Muzaffar on 14/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import "APPDetailsViewController.h"

@interface APPDetailsViewController () {
    UIBarButtonItem *btnFav;
    UIImage *favImage;
    UIImage *favImageSelected;
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
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [self.webView loadRequest:request];
    
    //add favorite in nav bar
    
    favImage = [UIImage imageNamed:@"ic_action_star_0.png"];
    favImageSelected = [UIImage imageNamed:@"ic_action_star_10.png"];
    
    btnFav = [[UIBarButtonItem alloc]
                                initWithImage:favImage landscapeImagePhone:nil
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(favoriteClicked:)];
    
    self.navigationItem.rightBarButtonItem = btnFav;
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
            btnFav.image = favImageSelected;
        }
        else if(btnFav.image == favImageSelected) {
            NSLog(@"Favorte Image Selected");
            btnFav.image = favImage;
        }
    } else {
        NSLog(@"Something went wrong");
    }
}

@end
