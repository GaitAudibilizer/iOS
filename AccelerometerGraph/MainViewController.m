#import "MainViewController.h"
#import "GraphView.h"
#import "AccelerometerFilter.h"

#define kUpdateFrequency	60.0
#define kLocalizedPause		NSLocalizedString(@"Pause","pause taking samples")
#define kLocalizedResume	NSLocalizedString(@"Resume","resume taking samples")
#define systemSoundID    1025

@interface MainViewController()

// Sets up a new filter. Since the filter's class matters and not a particular instance
// we just pass in the class and -changeFilter: will setup the proper filter.
-(void)changeFilter:(Class)filterClass;

@end

@implementation MainViewController

@synthesize unfiltered, filtered, pause, filterLabel/*, settingsButton*/;

// Implement viewDidLoad to do additional setup after loading the view.
-(void)viewDidLoad
{
    NSLog(@"ViewDidLoad called on mainviewcontroller");
	[super viewDidLoad];
    [self setTitle:@"Gait Audibilizer"];
    
    //Start motionManager
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .001;
    self.motionManager.gyroUpdateInterval = .001;
    
    //accelerometer motion manager
//    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
//                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
//                                                 [self outputAccelertionData:accelerometerData.acceleration];
//                                                 if(error){
//                                                     
//                                                     NSLog(@"%@", error);
//                                                 }
//                                             }];
    
    [self.motionManager startAccelerometerUpdates];
    //gyro motion manager
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        [self outputRotationData:gyroData.rotationRate];
                                    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(goToSettings)];
    
    //get user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //get cutoffs
    footStrikeCutoff = [defaults doubleForKey:@"footStrikeCutoff"];
    toeOffCutoff     = [defaults doubleForKey:@"toeOffCutoff"];
    
    _soundOn = [defaults boolForKey:@"soundOn"];
	pause.possibleTitles = [NSSet setWithObjects:kLocalizedPause, kLocalizedResume, nil];
	isPaused = NO;
	useAdaptive = YES;
    footIsDown = NO;
    
	[self changeFilter:[HighpassFilter class]];
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0 / kUpdateFrequency];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
	
	[unfiltered setIsAccessibilityElement:YES];
	[unfiltered setAccessibilityLabel:NSLocalizedString(@"unfilteredGraph", @"")];

	[filtered setIsAccessibilityElement:YES];
	[filtered setAccessibilityLabel:NSLocalizedString(@"filteredGraph", @"")];
    
}

-(void) goToSettings {
    NSLog(@"settings button pressed");
    
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController"bundle:nil];
    settingsViewController.delegate=self;
    [self.navigationController pushViewController:settingsViewController animated:YES];
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
}

- (void)addItemViewController:(SettingsViewController *)controller didFinishEnteringItem:(BOOL *)item
{
    _soundOn = item;
    NSLog(item ? @"Yes" : @"No");
}

- (void)setFootstrikeCutoff:(SettingsViewController *)controller didFinishEnteringItem:(double)item
{
    footStrikeCutoff = item;
    NSLog(@"setfootstrikecutoff called");
}

-(void)viewDidUnload
{
	[super viewDidUnload];
	self.unfiltered = nil;
	self.filtered = nil;
	self.pause = nil;
	self.filterLabel = nil;
}


// UIAccelerometerDelegate method, called when the device accelerates.
//-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
//{
//    //get user defaults
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    //get cutoffs
//    footStrikeCutoff = [defaults doubleForKey:@"footStrikeCutoff"];
//    toeOffCutoff     = [defaults doubleForKey:@"toeOffCutoff"];
//    _soundOn = [defaults boolForKey:@"soundOn"];
//    
//	// Update the accelerometer graph view
//	if(!isPaused)
//	{
//        [filter addAcceleration:acceleration];
//		[unfiltered addX:acceleration.x y:acceleration.y z:acceleration.z];
//		[filtered addX:filter.x y:filter.y z:filter.z];
//        
//        //Play tone if acceleration is greater than cutoff value and sound is turned on
//        //More complete step detection will be added here later
//        if(self.soundOn){
//            
//            //Check for footstrike
//            if (filter.y > footStrikeCutoff && footIsDown == NO) {
//                
//                //play sound
//                AudioServicesPlaySystemSound (systemSoundID);
//                
//                //Foot is now down
//                footIsDown = YES;
//            }
//            
//            //Check for toe off
////            if (footIsDown == YES && filter.x > toeOffCutoff && filter.y < footStrikeCutoff) {
//////                AudioServicesPlaySystemSound (systemSoundID+1);
////                footIsDown = NO;
////            }
//        }
//        
//		
//	}
//}

//Output motion data
-(void)outputRotationData:(CMRotationRate)rotation
{
    //get user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //get cutoffs
    footStrikeCutoff = [defaults doubleForKey:@"footStrikeCutoff"];
    toeOffCutoff     = [defaults doubleForKey:@"toeOffCutoff"];
    _soundOn = [defaults boolForKey:@"soundOn"];
    CMAcceleration acceleration = self.motionManager.accelerometerData.acceleration;
    
    [filter addAcceleration:acceleration];
    [unfiltered addX:acceleration.x y:acceleration.y z:acceleration.z];
    [filtered addX:filter.x y:filter.y z:filter.z];

    
    if(self.soundOn){
        if(self.motionManager.accelerometerData.acceleration.y > footStrikeCutoff && footIsDown == NO){
            //play sound
            AudioServicesPlaySystemSound (systemSoundID);
            
            //Foot is now down
            footIsDown = YES;
        }
        
        
        if (rotation.z > toeOffCutoff && footIsDown == YES) {
            AudioServicesPlaySystemSound (systemSoundID+1);
            footIsDown = NO;
        }
    }
    

    
}

-(void)changeFilter:(Class)filterClass
{
	// Ensure that the new filter class is different from the current one...
	if(filterClass != [filter class])
	{
		// And if it is, release the old one and create a new one.
		[filter release];
		filter = [[filterClass alloc] initWithSampleRate:kUpdateFrequency cutoffFrequency:5.0];
		// Set the adaptive flag
		filter.adaptive = useAdaptive;
		// And update the filterLabel with the new filter name.
		filterLabel.text = filter.name;
	}
}

-(IBAction)pauseOrResume:(id)sender
{
    NSLog(@"pausing");
	if(isPaused)
	{
		// If we're paused, then resume and set the title to "Pause"
		isPaused = NO;
		pause.title = kLocalizedPause;
	}
	else
	{
		// If we are not paused, then pause and set the title to "Resume"
		isPaused = YES;
		pause.title = kLocalizedResume;
	}
	
	// Inform accessibility clients that the pause/resume button has changed.
	UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
}

-(IBAction)filterSelect:(id)sender
{
	if([sender selectedSegmentIndex] == 0)
	{
		// Index 0 of the segment selects the lowpass filter
		[self changeFilter:[LowpassFilter class]];
	}
	else
	{
		// Index 1 of the segment selects the highpass filter
		[self changeFilter:[HighpassFilter class]];
	}

	// Inform accessibility clients that the filter has changed.
	UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
}

-(IBAction)adaptiveSelect:(id)sender
{
	// Index 1 is to use the adaptive filter, so if selected then set useAdaptive appropriately
	useAdaptive = [sender selectedSegmentIndex] == 1;
	// and update our filter and filterLabel
	filter.adaptive = useAdaptive;
	filterLabel.text = filter.name;
	
	// Inform accessibility clients that the adaptive selection has changed.
	UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
}

-(void)dealloc
{
	// clean up everything.
	[unfiltered release];
	[filtered release];
	[filterLabel release];
	[pause release];
	[super dealloc];
}

@end
