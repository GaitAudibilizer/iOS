///Users/iangarcia-doty/Documents/ME113/Examples.iOS/AccelerometerGraph/SettingsViewController.m
//  SettingsViewController.h
//  AccelerometerGraph
//
//  Created by Ian Garcia-Doty on 5/19/14.
//
//

#import <UIKit/UIKit.h>

@class SettingsViewController;

@protocol SettingsViewControllerDelegate <NSObject>
- (void)addItemViewController:(SettingsViewController*)controller didFinishEnteringItem:(NSString *)item;
@end

@interface SettingsViewController : UIViewController
{

}

@property (nonatomic, assign) id <SettingsViewControllerDelegate> delegate;

@property (retain, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (retain, nonatomic) IBOutlet UISlider *footStrikeCutoffSlider;
@property (retain, nonatomic) IBOutlet UILabel *footStrikeSliderLabel;

-(IBAction)soundOnOrOff:(id)sender;
-(IBAction)footStrikeCutoffSelect:(id)sender;

@end
