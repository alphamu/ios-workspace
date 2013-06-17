//
//  MultiScreenViewController.m
//  MultiScreenExample
//
//  Created by Ali Muzaffar on 13/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import "MultiScreenViewController.h"
#import "ScreenOneViewController.h"
#import "ScreenTwoViewController.h"

@interface MultiScreenViewController ()

- (IBAction)ShowScreenOne:(id)sender;
- (IBAction)ShowScreenTwo:(id)sender;
- (IBAction)ShowScreen:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *ScreenThreeButton;
@property (weak, nonatomic) IBOutlet UIButton *ScreenFourButton;
@property (weak, nonatomic) IBOutlet UILabel *SelectScreen;

@end

@implementation MultiScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [[NSString alloc]  initWithFormat:@"Welcome"];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ShowScreenOne:(id)sender {
    self.SelectScreen.text=@"Screen One Selected";
    ScreenOneViewController *one = [[ScreenOneViewController alloc] initWithNibName:@"ScreenOneViewController" bundle:nil];
    [self.navigationController pushViewController:one animated:YES];
}

- (IBAction)ShowScreenTwo:(id)sender {
    self.SelectScreen.text=@"Screen Two Selected";
    ScreenTwoViewController *two = [[ScreenTwoViewController alloc] initWithNibName:@"ScreenTwoViewController" bundle:nil];
    [self.navigationController pushViewController:two animated:YES];
}

- (IBAction)ShowScreen:(id)sender {
    if(sender == self.ScreenThreeButton)
        self.SelectScreen.text=@"Screen Three Selected";
    else if (sender == self.ScreenFourButton)
        self.SelectScreen.text = @"Screen Four Selected";
}

@end
