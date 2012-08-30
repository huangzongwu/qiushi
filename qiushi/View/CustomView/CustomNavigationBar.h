//
//  CustomNavigationBar.h
//  IOS_OBD_ARC
//
//  Created by xuanyuan xidong on 12-6-27.
//  Copyright (c) 2012年 Carsmart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (UINavigationBarCategory)



//@property (nonatomic, readonly) UIImageView *backgroundView; 
  
- (void)setBackgroundImage:(UIImage*)image;   
- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index;  
//- (void)drawRect1:(CGRect)rect;
@end  
