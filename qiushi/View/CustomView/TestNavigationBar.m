//
//  TestNavigationBar.m
//  IOS_OBD_ARC
//
//  Created by 一峰 郝 on 12-7-23.
//  Copyright (c) 2012年 carsmart. All rights reserved.
//

#import "TestNavigationBar.h"

@implementation TestNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/ 
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"navi_background"];
    [image drawInRect:CGRectMake(0, 0, 320, 44)];
}

@end
