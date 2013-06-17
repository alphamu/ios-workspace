//
//  AccelerometerExampleViewController.m
//  AccelerometerExample
//
//  Created by Ali Muzaffar on 12/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import "AccelerometerExampleViewController.h"

@interface AccelerometerExampleViewController ()

@property (weak, nonatomic) IBOutlet UITextField *AccelX;
@property (weak, nonatomic) IBOutlet UITextField *AccelY;
@property (weak, nonatomic) IBOutlet UITextField *AccelZ;

- (IBAction)startAccelerometerClicked:(id)sender;
- (IBAction)stopAccelerometerClicked:(id)sender;

@end

@implementation AccelerometerExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startAccelerometerClicked:(id)sender {
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:0.20] ;
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    
    NSLog(@"start acc");
}

- (IBAction)stopAccelerometerClicked:(id)sender {
     [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
        NSLog(@"stop acc");
}

-(void)accelerometer:(UIAccelerometer *)accelerometer
       didAccelerate:(UIAcceleration *)acceleration {
    
    self.AccelX.text = [NSString stringWithFormat:@"%f", acceleration.x];
    self.AccelY.text = [NSString stringWithFormat:@"%f", acceleration.y];
    self.AccelZ.text = [NSString stringWithFormat:@"%f", acceleration.z];
    
    NSLog(@"X=%f   Y=%f   Z=%f", acceleration.x, acceleration.y, acceleration.z);
}

- (void)viewDidUnload {
    self.AccelX = nil;
    self.AccelY = nil;
    self.AccelZ = nil;
}

@end
