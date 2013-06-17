//
//  APPDetailViewController.m
//  RSSReader
//
//  Created by Ali Muzaffar on 13/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import "APPDetailViewController.h"

@interface APPDetailViewController ()

@end

@implementation APPDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *myURL = [NSURL URLWithString: [self.url stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
