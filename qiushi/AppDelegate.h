//
//  AppDelegate.h
//  qiushi
//
//  Created by xyxd mac on 12-8-22.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@class MainViewController;
@class DDMenuController;
@class LeftController;
@class MyNavigationController;

//@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    GADBannerView *bannerView_;//实例变量 bannerView_是一个view
    
    MainViewController *_mainController;
    MyNavigationController *_navController;
    LeftController *_leftController;
}

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) DDMenuController *menuController;

@property (strong, nonatomic) MainViewController *mainController;
@property (strong, nonatomic) MyNavigationController *navController;
@property (strong, nonatomic) LeftController *leftController;


@end
