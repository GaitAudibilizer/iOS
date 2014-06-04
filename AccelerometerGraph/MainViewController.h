
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SettingsViewController.h"
#import "SavedDataViewController.h"
#import <CoreMotion/CoreMotion.h>

@class GraphView;
@class AccelerometerFilter;


@interface MainViewController : UIViewController<UIAccelerometerDelegate>
{
	GraphView *unfiltered;
	GraphView *filtered;
	UIBarButtonItem *record;
	UILabel *filterLabel;
	AccelerometerFilter *filter;
    NSMutableString* outputString;
    NSString* fileName;
	BOOL recordOn, useAdaptive;
    double footStrikeCutoff;
    double toeOffCutoff;
    BOOL footIsDown;
}


@property(nonatomic) BOOL *soundOn;


@property(nonatomic, retain) IBOutlet GraphView *unfiltered;
@property(nonatomic, retain) IBOutlet GraphView *filtered;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *record;
@property(nonatomic, retain) IBOutlet UILabel *filterLabel;

@property (strong, nonatomic) CMMotionManager *motionManager;

-(IBAction)recordSelect:(id)sender;
-(IBAction)filterSelect:(id)sender;
-(IBAction)adaptiveSelect:(id)sender;

@end