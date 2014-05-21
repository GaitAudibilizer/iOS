
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SettingsViewController.h"

@class GraphView;
@class AccelerometerFilter;


@interface MainViewController : UIViewController<UIAccelerometerDelegate, SettingsViewControllerDelegate>
{
	GraphView *unfiltered;
	GraphView *filtered;
	UIBarButtonItem *pause;
    UIButton *settingsButton;
	UILabel *filterLabel;
	AccelerometerFilter *filter;
	BOOL isPaused, useAdaptive;
}

@property(nonatomic) double *footStrikeCutoff;
@property(nonatomic) BOOL *soundOn;
@property(nonatomic) BOOL *footIsDown;

@property(nonatomic, retain) IBOutlet GraphView *unfiltered;
@property(nonatomic, retain) IBOutlet GraphView *filtered;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *pause;
@property(nonatomic, retain) IBOutlet UILabel *filterLabel;


@property (retain, nonatomic) IBOutlet UIButton *settingsButton;

-(IBAction)pauseOrResume:(id)sender;
-(IBAction)filterSelect:(id)sender;
-(IBAction)adaptiveSelect:(id)sender;

@end