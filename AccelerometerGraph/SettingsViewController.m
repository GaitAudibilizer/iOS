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
@synthesize footStrikeCutoffSlider, footStrikeSliderLabel,soundSwitch,soundSelectionSwitch,filterSwitch;

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
    
    //Set slider parameters
    footStrikeCutoffSlider.continuous = YES;
    footStrikeCutoffSlider.minimumValue = 0;
    footStrikeCutoffSlider.maximumValue = .5;
    
    _toeOffCutoffSlider.continuous = YES;
    _toeOffCutoffSlider.minimumValue = 0;
    _toeOffCutoffSlider.maximumValue = 2;
    
    //Fetch user settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    footStrikeCutoffSlider.value = [defaults doubleForKey:@"footStrikeCutoff"];
    _toeOffCutoffSlider.value = [defaults doubleForKey:@"toeOffCutoff"];
    [soundSwitch setOn:[defaults boolForKey:@"soundOn"]];
    [filterSwitch setOn:[defaults boolForKey:@"soundOn"]];
    [soundSelectionSwitch setSelectedSegmentIndex:[defaults integerForKey:@"soundSet"]];
    
    //Set label text
    _toeOffLabelString = [NSString stringWithFormat:@"%0.2f", _toeOffCutoffSlider.value];
    _footStrikeLabelString = [NSString stringWithFormat:@"%0.2f", footStrikeCutoffSlider.value];
    [footStrikeSliderLabel setText:_footStrikeLabelString];
    [_toeOffSliderLabel setText:_footStrikeLabelString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)soundOnOrOff:(id)sender
{
    //Save settings to NSUserDeafaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:soundSwitch.isOn forKey:@"soundOn"];
}

-(IBAction)footStrikeCutoffSelect:(id)sender
{
    //update label
    _footStrikeLabelString = [NSString stringWithFormat:@"%.4f", footStrikeCutoffSlider.value];
//    NSLog([NSString stringWithFormat:@"%.3f", footStrikeCutoffSlider.value]);
    [footStrikeSliderLabel setText:_footStrikeLabelString];
    
    //Save settings to NSUserDeafaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:footStrikeCutoffSlider.value forKey:@"footStrikeCutoff"];
}

- (IBAction)toeOffCutoffSelect:(id)sender {
    //update label
    _toeOffLabelString= [NSString stringWithFormat:@"%.3f", _toeOffCutoffSlider.value];
//    NSLog([NSString stringWithFormat:@"%.3f", _toeOffCutoffSlider.value]);
    [_toeOffSliderLabel setText:_toeOffLabelString];
    
    //Save settings to NSUserDeafaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:_toeOffCutoffSlider.value forKey:@"toeOffCutoff"];
}

- (IBAction)chooseSound:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"sound selector pressed");
    
    if (soundSelectionSwitch.selectedSegmentIndex == 0){
        [defaults setInteger:0 forKey:@"soundSet"];
    }else{
        [defaults setInteger:1 forKey:@"soundSet"];
    }
}

- (IBAction)filterOnOrOff:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:filterSwitch.isOn forKey:@"filterOn"];
}

- (void)dealloc {
    [soundSwitch release];
    [footStrikeCutoffSlider release];
    [footStrikeSliderLabel release];
    [footStrikeSliderLabel release];
    [_toeOffCutoffSlider release];
    [_toeOffCutoffSlider release];
    [_toeOffSliderLabel release];
    [soundSelectionSwitch release];
    [filterSwitch release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setSoundSwitch:nil];
    [self setFootStrikeCutoffSlider:nil];
    [self setFootStrikeSliderLabel:nil];
    [self setToeOffCutoffSlider:nil];
    [self setToeOffSliderLabel:nil];
    [self setSoundSelectionSwitch:nil];
    [self setFilterSwitch:nil];
    [super viewDidUnload];
}
@end
