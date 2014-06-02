

@interface AppDelegate : NSObject<UIApplicationDelegate>
{
    UIWindow *window;
	UIViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (retain, nonatomic) IBOutlet UINavigationController *navController;

@end