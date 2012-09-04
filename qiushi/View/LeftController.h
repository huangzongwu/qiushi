//
//  LeftController.h
//  DDMenuController
//
//  Created by Devin Doty on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QuadCurveMenu.h"
@class MyNavigationController;
@interface LeftController : UIViewController<QuadCurveMenuDelegate>
{
    NSMutableArray *_items;
    
    DDMenuController *_menuController;
    MyNavigationController *_navController;
    MainViewController *_mainViewController;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) MyNavigationController *navController;
@property (nonatomic, retain) MainViewController *mainViewController;
@end
