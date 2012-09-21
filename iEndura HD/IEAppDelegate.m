//
//  IEAppDelegate.m
//  iEndura HD
//
//  Created by Candan BÖLÜKBAŞ on 14 Sep.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "IEAppDelegate.h"
#import "IEViewController.h"
#import "IEMainViewController.h"
#import "IEGlobals.h"
#import "IEHelperMethods.h"
#import "IEDatabaseOps.h"

@implementation IEAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize userSeesionId, navBarTitle, tabBarController, dbRequiresUpdate, favMenuOpened, currCam;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [UIApplication sharedApplication].keyWindow.frame=CGRectMake(0, 20, 320, 460);
    APP_DELEGATE.userSeesionId = @"";
    APP_DELEGATE.dbRequiresUpdate = NO;
    APP_DELEGATE.favMenuOpened = NO;
    APP_DELEGATE.currCam = nil;
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    NSString *app_requires_init = [IEHelperMethods getUserDefaultSettingsString:APP_REQUIRES_INIT_KEY];
    
    if(app_requires_init == nil || [app_requires_init isEqualToString:POZITIVE_VALUE])
    {
        IEDatabaseOps *dbOps = [[IEDatabaseOps alloc] init];
        [dbOps CopyDbToDocumentsFolder];
        NSArray *favoriteCameras = [[NSArray alloc] init];
        [IEHelperMethods setUserDefaultSettingsObject:favoriteCameras key:FAVORITE_CAMERAS_KEY];
        [IEHelperMethods setUserDefaultSettingsString:NEGATIVE_VALUE key:APP_REQUIRES_INIT_KEY];
        [IEHelperMethods setUserDefaultSettingsString:POZITIVE_VALUE key:AUTO_UPDATE_CAMERA_DB_KEY];
    }
    
    [self setUpTabBar];
    return YES;

}

- (void) setUpTabBar 
{
    IEMainViewController *firstViewController = [[IEMainViewController alloc] initWithNibName:@"IEMainViewController" bundle:nil];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
	navController.navigationBar.tintColor = [IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_DARK_BLUE];
    UIImage *tbaImage = [UIImage imageNamed:@"iendura_tab_icon.png"];
    firstViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"iEndura" image:tbaImage tag:0];
    firstViewController.title = @"iEndura";
    UINavigationController *firstNavController = [[UINavigationController alloc]initWithRootViewController:firstViewController];
    
    /*IECamListViewController *secondViewController = [[IECamListViewController alloc]init];
    IECameraLocation *cl = [[IECameraLocation alloc] init];
    cl.RemoteLocation = FAVORITE_CAMERAS_TITLE;
    cl.LocationType = IE_Cam_Loc_Fav;
    [secondViewController.navigationItem setTitle:cl.RemoteLocation];
    secondViewController.CurrentCameraLocation = cl;
    secondViewController.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];
    UINavigationController *secondNavController = [[UINavigationController alloc]initWithRootViewController:secondViewController];
    
    IESearchViewController *thirdViewController = [[IESearchViewController alloc]init];
    thirdViewController.title = @"Search";
    thirdViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:2];
    UINavigationController *thirdNavController = [[UINavigationController alloc]initWithRootViewController:thirdViewController];
    
    IESettingsViewController *forthViewController = [[IESettingsViewController alloc]init];
    forthViewController.title = @"Settings";
    UIImage *tbaImageSettings = [UIImage imageNamed:@"settings.png"];
    forthViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:tbaImageSettings tag:3];
    UINavigationController *forthNavController = [[UINavigationController alloc]initWithRootViewController:forthViewController];*/
    
    //    IEHelpViewController *fifthViewController = [[IEHelpViewController alloc]init];
    //    firstViewController.title = @"Help";
    //    UIImage *tbaImageHelp = [UIImage imageNamed:@"help.png"];
    //    fifthViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Help" image:tbaImageHelp tag:4];
    //    UINavigationController *fifthNavController = [[UINavigationController alloc]initWithRootViewController:fifthViewController];
    //    
    //    IEAboutViewController *sixthViewController = [[IEAboutViewController alloc]init];
    //    sixthViewController.title = @"About";
    //    UIImage *tbaImageAbout = [UIImage imageNamed:@"about.png"];
    //    sixthViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"About" image:tbaImageAbout tag:5];
    //    UINavigationController *sixhNavController = [[UINavigationController alloc]initWithRootViewController:sixthViewController];
    
    tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    tabBarController.viewControllers = [[NSArray alloc] initWithObjects:firstNavController, nil];
    tabBarController.tabBar.tintColor = [IEHelperMethods getColorFromRGBColorCode:BACKGROUNG_COLOR_DARKER_BLUE];
    tabBarController.delegate = self;             
    // add tabbar and show
    [[self window] addSubview:[tabBarController view]];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
