//
//  CommentsViewController.h
//  NetDemo
//
//  Created by Michael on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentCell.h"
#import "CommentsCell.h"
#import "ASIHttpHeaders.h"
#import "QiuShi.h"
#import "Comments.h"

#import "GADBannerView.h"

@class SHSShareViewController;
@interface CommentsViewController : UIViewController<UIGestureRecognizerDelegate>
{
    //糗事内容的TableView
    UITableView *tableView;
    //评论的TableView
    UITableView *commentView;
    //http请求
    ASIHTTPRequest *_asiRequest;
    //糗事的对象
    QiuShi *qs;
    //记录评论的数组
    NSMutableArray *list;
    GADBannerView *bannerView_;//实例变量 bannerView_是一个view
    
    
//    UIBarButtonItem *_shareItem;//分享item
    
    DDMenuController *_menuController;
    
    SHSShareViewController *_shareView;
}
@property (nonatomic,retain) UITableView *commentView;
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *list;
@property (nonatomic,retain) ASIHTTPRequest *asiRequest;
@property (nonatomic,retain) QiuShi *qs;
@property (nonatomic,retain) SHSShareViewController *shareView;
-(CGFloat) getTheHeight;
-(CGFloat) getTheCellHeight:(int) row;
@end

