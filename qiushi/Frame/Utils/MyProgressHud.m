//
//  MyProgressHud.m
//  qiushi
//
//  Created by xyxd mac on 12-9-4.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import "MyProgressHud.h"

static MyProgressHud *instance;
@implementation MyProgressHud







+ (MyProgressHud *)getInstance {
    
    @synchronized(self){
        if (!instance) {
            instance = (MyProgressHud *)[[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
            //            instance.delegate = self;
            instance.opacity=0.6;
            instance.labelText = @"请稍候...";
            [instance show:YES];
        }
        
        return instance;
    }
    
}

+ (void)remove{
    
    if (instance) {
        [instance removeFromSuperview];
        //        [instance release];
        
    }
}

+ (void)showHUD:(NSString*)title
{
#ifndef __OPTIMIZE__
    
    DLog(@"%@",title);
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//	
//	// Configure for text only and offset down
//	hud.mode = MBProgressHUDModeText;
//	hud.labelText = title;
//    //	hud.margin = 10.f;
//    //	hud.yOffset = 150.f;
//    //    hud.opacity = 0.6;
//	hud.removeFromSuperViewOnHide = YES;
//	
//	[hud hide:YES afterDelay:3];
    
#else
#endif
    
}

@end
