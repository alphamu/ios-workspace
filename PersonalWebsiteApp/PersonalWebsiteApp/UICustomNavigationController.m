//
//  UICustomNavigationController.m
//  PersonalWebsiteApp
//
//  Created by Ali Muzaffar on 28/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import "UICustomNavigationController.h"

@interface UICustomNavigationController ()

@end

@implementation UICustomNavigationController

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        return NO;
    
    return YES;
}

@end
