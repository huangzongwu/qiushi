//
//  MyNavigationController.m
//  IOS_OBD_ARC
//
//  Created by xuanyuan xidong on 12-7-18.
//  Copyright (c) 2012年 Beijing CarSmart Technology Co., LTD. All rights reserved.
//

#import "MyNavigationController.h"

@implementation MyNavigationController


-(void)popself
{
    
    [self popViewControllerAnimated:YES];
    
}

-(UIBarButtonItem*) createBackButton

{ 
    UIImage* image= [UIImage imageNamed:@"navi_back_btn"];
    UIImage* imagef = [UIImage imageNamed:@"navi_back_f_btn"];
    CGRect backframe= CGRectMake(0, 0, image.size.width, image.size.height); 
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = backframe;
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton setBackgroundImage:imagef forState:UIControlStateHighlighted];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal]; 
//    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; 
//    backButton.titleLabel.font=[UIFont systemFontOfSize:12]; 
    [backButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    //定制自己的风格的  UIBarButtonItem
    UIBarButtonItem* someBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:backButton]; 
    return someBarButtonItem;
    
//    return [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(popself)];
    
} 

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated 

{ 
    
    [super pushViewController:viewController animated:animated]; 
    
    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1) 
    { 
        
        if ([viewController.navigationItem hidesBackButton]==NO) 
        {
            viewController.navigationItem.leftBarButtonItem =[self createBackButton];
        }
        else 
        {
            viewController.navigationItem.leftBarButtonItem =nil;
        }
        
        
    } 
    
} 

@end