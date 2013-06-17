//
//  MultiScreenAppDelegate.h
//  MultiScreenExample
//
//  Created by Ali Muzaffar on 13/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MultiScreenViewController;

@interface MultiScreenAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) MultiScreenViewController *viewController;
@property (strong, nonatomic) UINavigationController *navController;


@end
