//
//  AppDelegate.m
//  qiushi
//
//  Created by xyxd mac on 12-8-22.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"
#import "DDMenuController.h"

#import "LeftController.h"
#import "CustomNavigationBar.h"
#import "MyNavigationController.h"
//#import "RightController.h"

//#import "ViewController.h"




@implementation AppDelegate

@synthesize window = _window;
@synthesize menuController = _menuController;
@synthesize mainController = _mainController;
@synthesize navController = _navController;
@synthesize leftController = _leftController;
@synthesize lightView = _lightView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //    //暂停2s
    ////    [NSThread sleepForTimeInterval:1.0];
    
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
//    } else {
//        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
//    }
//    self.window.rootViewController = self.viewController;
//    [self.window makeKeyAndVisible];
//    return YES;
    
    
    //想摇就写在这～～～
    application.applicationSupportsShakeToEdit=YES;
    
    //默认显示广告
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithBool:YES]  forKey:@"showAD"];
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    _lightView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [_lightView setUserInteractionEnabled:NO];
    [_lightView setBackgroundColor:[UIColor blackColor]];
    [_lightView setAlpha:.0];
//    [self.window addSubview:_lightView];
    
    
    _mainController = [[MainViewController alloc] init];
    
    _navController = [[MyNavigationController alloc] initWithRootViewController:_mainController];
    
    _menuController = [[DDMenuController alloc] initWithRootViewController:_navController];
    
    
    _leftController = [[LeftController alloc] init];
    _leftController.navController = _navController;
    _leftController.mainViewController = _mainController;
    
    _menuController.leftViewController = _leftController;
    
    //    RightController *rightController = [[RightController alloc] init];
    //    rootController.rightViewController = rightController;
    
    self.window.rootViewController = _menuController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    [self.navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_background.png"]];
    
    //判断设备的版本
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
    if ([self.navController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        //ios5 新特性
        [self.navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_background.png"] forBarMetrics:UIBarMetricsDefault];
        [[NSUserDefaults standardUserDefaults] setObject:@">=5" forKey:@"version"];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:@"<5" forKey:@"version"];
    }
#endif
    
    
    [self.window makeKeyAndVisible];
    return YES;
    
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
