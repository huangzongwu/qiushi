//
//  MyProgressHud.h
//  qiushi
//
//  Created by xyxd mac on 12-9-4.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBProgressHUD.h"
@interface MyProgressHud : MBProgressHUD{
    
    
}

+ (MyProgressHud *)getInstance;

+ (void)remove;
+ (void)showHUD:(NSString*)title;
@end