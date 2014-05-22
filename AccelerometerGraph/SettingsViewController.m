//
//  SettingsViewController.m
//  AccelerometerGraph
//
//  Created by Ian Garcia-Doty on 5/19/14.
//
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize footStrikeCutoffSlider, footStrikeSliderLabel,soundSwitch;

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
    footStrikeCutoffSlider.continuous = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)soundOnOrOff:(id)sender
{
    NSLog(@"Soundswitch pressed");
    
    [self.delegate addItemViewController:self didFinishEnteringItem:soundSwitch.isOn];
//    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)footStrikeCutoffSelect:(id)sender
{
    
}

- (void)dealloc {
    [soundSwitch release];
    [footStrikeCutoffSlider release];
    [footStrikeSliderLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setSoundSwitch:nil];
    [self setFootStrikeCutoffSlider:nil];
    [self setFootStrikeSliderLabel:nil];
    [super viewDidUnload];
}
@end
