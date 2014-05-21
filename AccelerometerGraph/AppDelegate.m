#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

@synthesize window, /*viewController,*/ navController;

-(void)applicationDidFinishLaunching:(UIApplication*)application
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
	// Add the view controller's view to the window
//	[window addSubview:viewController.view];
//    window.rootViewController = navController;
    
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
