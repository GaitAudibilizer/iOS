#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

@synthesize window, /*viewController,*/ navController;

//Set default user defaults
+(void)initialize{

    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"soundOn", [NSNumber numberWithBool:YES], @"footStrikeCutoff", [NSNumber numberWithFloat:.065],
                                 @"toeOffCutoff", [NSNumber numberWithFloat:.05],
                                 @"gyroCutoff", [NSNumber numberWithFloat:.05],
                                 @"soundSet", [NSNumber numberWithInt:0],
                                 @"filterOn",[NSNumber numberWithBool:YES],
                                 nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
}

-(void)applicationDidFinishLaunching:(UIApplication*)application
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIViewController *cont=[[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    self.navController=[[UINavigationController alloc]initWithRootViewController:cont];
    
    [self.navController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navController.navigationBar.shadowImage = [UIImage new];
    self.navController.navigationBar.translucent = YES;
    self.navController.view.backgroundColor = [UIColor clearColor];
    
    [self.window setRootViewController:navController];
    
    [self.window makeKeyAndVisible];

}

// Release resources.
-(void)dealloc
{
    [window release];
	[viewController release];
    [navController release];
    [super dealloc];
}

@end
