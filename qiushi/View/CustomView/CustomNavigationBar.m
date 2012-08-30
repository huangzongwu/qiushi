//
//  CustomNavigationBar.m
//  IOS_OBD_ARC
//
//  Created by xuanyuan xidong on 12-6-27.
//  Copyright (c) 2012年 Carsmart. All rights reserved.
//

#import "CustomNavigationBar.h"


@implementation UINavigationBar (UINavigationBarCategory)  

UIImageView *backgroundView; 

-(void)setBackgroundImage:(UIImage*)image   
{   
    if(image == nil)   
    {   
        [backgroundView removeFromSuperview];   
    }   
    else   
    {   
        backgroundView = [[UIImageView alloc] initWithImage:image];   
        backgroundView.tag = 1;   
        backgroundView.frame = CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height);   
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;   
        [self addSubview:backgroundView];   
        [self sendSubviewToBack:backgroundView];   
        [backgroundView release];   
    }   
}   

//for other views   
- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index   
{   
    [super insertSubview:view atIndex:index];   
    [self sendSubviewToBack:backgroundView];   
}   

- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"navi_background"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end   
