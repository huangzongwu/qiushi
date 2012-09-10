//
//  IsNetWorkUtil.m
//  IOS_OBD_ARC
//
//  Created by xuanyuan xidong on 12-6-19.
//  Copyright (c) 2012年 Carsmart. All rights reserved.
//

#import "IsNetWorkUtil.h"

#import "Reachability.h"
#import "iToast.h"


@implementation IsNetWorkUtil

static BOOL isNetWork = YES;
static int typeInternet = kTypeNO;

+ (void)initNetWorkStatus{
    
    //判断是否联网
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(reachabilityChanged1:) 
                                                 name:kReachabilityChangedNotification 
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            DLog( @"Block Says Reachable+++");
            
            isNetWork = YES;
            
            
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            DLog( @"Block Says Unreachable---");
            isNetWork = NO;
            
            
        });
    };
    
    [self setInternetType:reach];
    
    [reach startNotifier];
    
    
    
    
}

+ (void)reachabilityChanged1:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {


        isNetWork = YES;
        
        
    }
    else
    {
        

        isNetWork = NO;
        
    }
    
    [self setInternetType:reach];
}

+ (BOOL)isNetWork
{
    return isNetWork;
}

+ (BOOL)isNetWork1
{
    
    if (isNetWork == NO)
    {
        [[iToast makeText:NSLocalizedString(@"noNetWork",@"网络连接不可用,请检查网络")] show];
    }
    return isNetWork;
}

+ (void)setInternetType:(Reachability*)reach
{
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            typeInternet = kTypeNO;
            DLog(@"无网络连接");
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            typeInternet = kType3G;
            DLog(@"3G网络连接");
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            typeInternet = kTypeWifi;
            DLog(@"wifi网络连接");
            break;
    }
}


@end
