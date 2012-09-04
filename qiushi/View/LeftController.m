//
//  LeftController.m
//  DDMenuController
//
//  Created by Devin Doty on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LeftController.h"
#import "MainViewController.h"
#import "DDMenuController.h"
#import "AppDelegate.h"
#import "AboutViewController.h"
#import "SetViewController.h"
#import "PurchaseInViewController.h"
#import "MyNavigationController.h"
#import "FavouriteViewController.h"


@implementation LeftController

@synthesize tableView=_tableView;
@synthesize items = _items;
@synthesize navController = _navController;
@synthesize mainViewController = _mainViewController;

- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    
    _items = [[NSMutableArray alloc]initWithObjects:@"随便逛逛",@"新鲜出炉",@"有图有真相",@"关于",@"设置",@"个人收藏", nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1001" forKey:@"mainType"];
    
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = (id<UITableViewDelegate>)self;
        tableView.dataSource = (id<UITableViewDataSource>)self;
        tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        [self.view addSubview:tableView];
        self.tableView = tableView;
    }
    
    //仿Path菜单
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"story-button.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"story-button-pressed.png"];
    
    // Camera MenuItem.
    QuadCurveMenuItem *cameraMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                highlightedImage:storyMenuItemImagePressed
                                                                    ContentImage:[UIImage imageNamed:@"story-camera.png"]
                                                         highlightedContentImage:nil];
    // People MenuItem.
    QuadCurveMenuItem *peopleMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                highlightedImage:storyMenuItemImagePressed
                                                                    ContentImage:[UIImage imageNamed:@"story-people.png"]
                                                         highlightedContentImage:nil];
    // Place MenuItem.
    QuadCurveMenuItem *placeMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[UIImage imageNamed:@"story-place.png"]
                                                        highlightedContentImage:nil];
    // Music MenuItem.
    QuadCurveMenuItem *musicMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[UIImage imageNamed:@"story-music.png"]
                                                        highlightedContentImage:nil];
    // Thought MenuItem.
    QuadCurveMenuItem *thoughtMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                 highlightedImage:storyMenuItemImagePressed
                                                                     ContentImage:[UIImage imageNamed:@"story-thought.png"]
                                                          highlightedContentImage:nil];
    // Sleep MenuItem.
    QuadCurveMenuItem *sleepMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[UIImage imageNamed:@"story-sleep.png"]
                                                        highlightedContentImage:nil];
    
    NSArray *menus = [NSArray arrayWithObjects:cameraMenuItem, peopleMenuItem,placeMenuItem,
                      musicMenuItem, thoughtMenuItem, sleepMenuItem,
                      nil];
    
    QuadCurveMenu *menu = [[QuadCurveMenu alloc] initWithFrame:self.view.bounds menus:menus];
    menu.delegate = self;
    [self.view addSubview:menu];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
    _items = nil;
}


#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.items.count;
    }else{
        return 0;
    }
    
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
    }
    cell.textLabel.font = [UIFont fontWithName:@"微软雅黑" size:15.0];
    
    return cell;
    
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"我的糗事囧事 v1.0.120817";
    }else if(section == 1)
    {
        return @"内容及版权归糗事百科所有";
    }else if(section == 2){
        return @"个人仅作学习之用";
    }else{
        return @"邮箱：xyxdasnjss@163.com";
    }
    
    
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *str =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"mainType"]];
    
    
    
    if (indexPath.row == 0) {
        if ([str isEqualToString:@"(null)"]||[str isEqualToString:@"1001"]) {
            [_menuController showRootController:YES];
        }else{
            
            [self.navController popToRootViewControllerAnimated:YES];
            self.mainViewController.title = @"";
            
            self.mainViewController.typeQiuShi = 1001 + indexPath.row ; //
            [self.mainViewController refreshDate];
            [_menuController showRootController:YES];
            
        }
    }else if (indexPath.row == 1){
        
        if ([str isEqualToString:@"1002"]) {
            [_menuController showRootController:YES];
        }else{
            [self.navController popToRootViewControllerAnimated:YES];
            self.mainViewController.title = [NSString stringWithFormat:@"%@", [self.items objectAtIndex:indexPath.row]];
            
            self.mainViewController.typeQiuShi = 1001 + indexPath.row ; //
            [self.mainViewController refreshDate];
            [_menuController showRootController:YES];
            
        }
        
    }else if (indexPath.row == 2){
        if ([str isEqualToString:@"1003"]) {
            [_menuController showRootController:YES];
        }else{
            [self.navController popToRootViewControllerAnimated:YES];
            self.mainViewController.title = [NSString stringWithFormat:@"%@", [self.items objectAtIndex:indexPath.row]];
            
            self.mainViewController.typeQiuShi = 1001 + indexPath.row ; //
            [self.mainViewController refreshDate];
            [_menuController showRootController:YES];
            
            
        }
    }else if (indexPath.row == 3){
        if ([str isEqualToString:@"1004"]) {
            [_menuController showRootController:YES];
        }else{
            AboutViewController *about = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
            [self.navController pushViewController:about animated:YES];

            [_menuController showRootController:YES];
            
        }
    }else if (indexPath.row == 4){
        if ([str isEqualToString:@"1005"]) {
            [_menuController showRootController:YES];
        }else{
            SetViewController *set = [[SetViewController alloc]initWithNibName:@"SetViewController" bundle:nil];
            
            [self.navController pushViewController:set animated:YES];
            [_menuController showRootController:YES];
            
        }
    }else if (indexPath.row == 5){
        if ([str isEqualToString:@"1006"]) {
            [_menuController showRootController:YES];
        }else{
            FavouriteViewController *favourite = [[FavouriteViewController alloc]initWithNibName:@"FavouriteViewController" bundle:nil];
            
            [self.navController pushViewController:favourite animated:YES];
            [_menuController showRootController:YES];
            
        }
    }
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",(1001 + indexPath.row)] forKey:@"mainType"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}

- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx
{
    NSLog(@"Select the index : %d",idx);
    if (idx == 0)
    {
        //程序内购买
//        PurchaseInViewController *purchase = [[PurchaseInViewController alloc]initWithNibName:@"PurchaseInViewController" bundle:nil];
//        [self.navController pushViewController:purchase animated:YES];

        
    }
     [_menuController showRootController:YES];
}


#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif

@end
