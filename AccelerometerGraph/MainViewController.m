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

@synthesize unfiltered, filtered, record, filterLabel/*, settingsButton*/;

// Implement viewDidLoad to do additional setup after loading the view.
-(void)viewDidLoad
{
    NSLog(@"ViewDidLoad called on mainviewcontroller");
	[super viewDidLoad];
    [self setTitle:@"Gait Audibilizer"];
    
    outputString = [[NSMutableString alloc] init];
    //Start motionManager and set timestep
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .001;
    self.motionManager.gyroUpdateInterval = .001;
    
    //Accelerometer motion manager
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
	recordOn = NO;
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
	self.record = nil;
	self.filterLabel = nil;
}

//Output motion data
-(void)outputRotationData:(CMRotationRate)rotation
{
    //get user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //get cutoffs
//    footStrikeCutoff = [defaults doubleForKey:@"footStrikeCutoff"];
//    toeOffCutoff     = [defaults doubleForKey:@"toeOffCutoff"];
//    _soundOn = [defaults boolForKey:@"soundOn"];
    
    //update graphs
    CMAcceleration acceleration = self.motionManager.accelerometerData.acceleration;
    [filter addAcceleration:acceleration];
    [unfiltered addX:acceleration.x y:acceleration.y z:acceleration.z];
    [filtered addX:filter.x y:filter.y z:filter.z];
    
    if (recordOn) {
//    NSLog(@"%@",outputString);
    [outputString appendFormat:@"%f,%f,%f,%f\n",
                        acceleration.x, acceleration.y, acceleration.z,rotation.z];
    }
    
    if([defaults boolForKey:@"soundOn"]){
        if(filter.y > [defaults doubleForKey:@"footStrikeCutoff"]){
            //play sound
            AudioServicesPlaySystemSound (systemSoundID);
            //Foot is now down
            footIsDown = YES;
        }
        if (rotation.z > [defaults doubleForKey:@"toeOffCutoff"] && footIsDown == YES) {
            AudioServicesPlaySystemSound (systemSoundID+1);
            footIsDown = NO;
        }
    }
}

-(IBAction)recordSelect:(id)sender
{
    NSLog(@"recording");
	if(recordOn)
	{
		// If we're recording, end recording and save file
		recordOn = NO;
		record.title = @"Record";
        
        //Prompt for filename
        UIAlertView * saveAlert = [[UIAlertView alloc] initWithTitle:@"Save File" message:@"Please enter a filename or press cancel" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
        saveAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        saveAlert.tag = 420; //blazeit
        [saveAlert show];
        
	}
	else
	{
		// Start recording
		recordOn = YES;
		record.title = @"Stop Recording";
	}

}

//Delegate for the alert window that pops up when recording stops
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 420) {
        if (buttonIndex == 0) {
            UITextField *textfield = [alertView textFieldAtIndex:0];
            fileName = [textfield.text stringByAppendingString:@".csv"];
            NSLog(@"filename: %@", fileName);
            
            //Find directory for saving documents
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docDirectory = [paths objectAtIndex:0];
            
            NSString *outputFileName = [NSString stringWithFormat:@"%@/%@", docDirectory, self->fileName];
            NSLog(@"Output file name: %@", outputFileName);
            
            //Create an error incase something goes wrong
            NSError *csvError = nil;
            
            //We write the string to a file and assign it's return to a boolean
            NSString *nonMutableString = [NSString stringWithFormat:@"%@",outputString];
            NSLog(@"%@",outputString);
            BOOL written = [nonMutableString writeToFile:outputFileName atomically:YES encoding:NSUTF8StringEncoding error:&csvError];
            
            //If there was a problem saving we show the error if not show success and file path
            if (!written)
                NSLog(@"write failed, error=%@", csvError);
            else
                NSLog(@"Saved! File path =%@", outputFileName);
            
            //reset output string
            [outputString setString:@""];
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
	[record release];
    [outputString release];
	[super dealloc];
}

@end
