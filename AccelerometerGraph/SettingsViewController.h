///Users/iangarcia-doty/Documents/ME113/Examples.iOS/AccelerometerGraph/SettingsViewController.m
//  SettingsViewController.h
//  AccelerometerGraph
//
//  Created by Ian Garcia-Doty on 5/19/14.
//
//

#import <UIKit/UIKit.h>

@class SettingsViewController;

@interface SettingsViewController : UIViewController
{

}

@property(nonatomic, retain) NSString *footStrikeLabelString;
@property(nonatomic, retain) NSString *toeOffLabelString;

@property (retain, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (retain, nonatomic) IBOutlet UISlider *footStrikeCutoffSlider;
@property (retain, nonatomic) IBOutlet UILabel *footStrikeSliderLabel;
@property (retain, nonatomic) IBOutlet UILabel *toeOffSliderLabel;
@property (retain, nonatomic) IBOutlet UISlider *toeOffCutoffSlider;
@property (retain, nonatomic) IBOutlet UISegmentedControl *soundSelectionSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *filterSwitch;



-(IBAction)soundOnOrOff:(id)sender;
-(IBAction)footStrikeCutoffSelect:(id)sender;
-(IBAction)toeOffCutoffSelect:(id)sender;
-(IBAction)chooseSound:(id)sender;
-(IBAction)filterOnOrOff:(id)sender;


@end
