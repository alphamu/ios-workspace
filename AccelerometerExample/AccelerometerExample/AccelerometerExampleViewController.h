//
//  AccelerometerExampleViewController.h
//  AccelerometerExample
//
//  Created by Ali Muzaffar on 12/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccelerometerExampleViewController : UIViewController <UIAccelerometerDelegate>
{
    UIAccelerometer *cccelerometer;
}

@property (nonatomic, retain) UIAccelerometer *accelerometer;

- (void)accelerometer:(UIAccelerometer *)accelerometer
       didAccelerate:(UIAcceleration *)acceleration;

@end
