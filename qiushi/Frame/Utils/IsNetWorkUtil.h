//
//  IsNetWorkUtil.h
//  IOS_OBD_ARC
//
//  Created by xuanyuan xidong on 12-6-19.
//  Copyright (c) 2012年 Carsmart. All rights reserved.
//

#import <Foundation/Foundation.h>

enum internetType
{
    kTypeWifi = 1001,
    kType3G,
    kTypeNO,

};

@interface IsNetWorkUtil : NSObject

+ (void)initNetWorkStatus;
+ (BOOL)isNetWork;
+ (BOOL)isNetWork1;
+ (int)netWorkType;

@end
