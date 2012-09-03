//
//  ContentViewController.h
//  NetDemo
//
//  Created by xyxd  on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentCell.h"
#import "ASIHttpHeaders.h"



@interface ContentViewController : UIViewController
{
    //http 请求
    ASIHTTPRequest *_asiRequest;
    //糗事的类型:最新，最糗，真相
    QiuShiType Qiutype;
    // 随便逛逛，6小时最糗，24小时最糗，一周最糗
    QiuShiTime QiuTime;


    GADBannerView *bannerView_;
    
    NSMutableArray *_cacheArray;//保存到数据库里的缓存
}

@property(nonatomic,retain) ASIHTTPRequest *asiRequest;
@property (nonatomic,assign) QiuShiType Qiutype;
@property (nonatomic,assign) QiuShiTime QiuTime;
@property (nonatomic,retain) NSMutableArray *cacheArray;
-(void) LoadPageOfQiushiType:(QiuShiType) type Time:(QiuShiTime) time;
-(CGFloat) getTheHeight:(NSInteger)row;
@end
