//
//  ContentCell.m
//  NetDemo
//
//  Created by Michael on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentsCell.h"

@interface CommentsCell()
@end;

@implementation CommentsCell
@synthesize txtContent,txtAnchor,footView,centerimageView,txtfloor;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        UIImage *centerimage = [UIImage imageNamed:@"block_center_background.png"];
        centerimageView = [[UIImageView alloc]initWithImage:centerimage];
        [centerimageView setFrame:CGRectMake(0, 0, 320, 220)];
        [self addSubview:centerimageView];
    
        
        txtContent = [[UILabel alloc]init];
        [txtContent setBackgroundColor:[UIColor clearColor]];
        [txtContent setFrame:CGRectMake(20, 32, 280, 220)];
        [txtContent setFont:[UIFont fontWithName:@"微软雅黑" size:14]];
        [txtContent setLineBreakMode:UILineBreakModeTailTruncation];
        [self addSubview:txtContent];
   
        
        txtAnchor = [[UILabel alloc]initWithFrame:CGRectMake(10,4, 200, 30)];
        [txtAnchor setText:@"匿名"];
        [txtAnchor setFont:[UIFont fontWithName:@"微软雅黑" size:14]];
        [txtAnchor setBackgroundColor:[UIColor clearColor]];
        [txtAnchor setTextColor:[UIColor brownColor]];
        [self addSubview:txtAnchor];
     
        
        txtfloor = [[UILabel alloc]initWithFrame:CGRectMake(290,4, 50, 30)];
        [txtfloor setText:@"1"];
        [txtfloor setFont:[UIFont fontWithName:@"微软雅黑" size:14]];
        [txtfloor setBackgroundColor:[UIColor clearColor]];
        [txtfloor setTextColor:[UIColor brownColor]];
        [self addSubview:txtfloor];
     
        
        UIImage *footimage = [UIImage imageNamed:@"block_line.png"];
        footView = [[UIImageView alloc]initWithImage:footimage];
        [footView setFrame:CGRectMake(5, txtContent.frame.size.height, 310, 2)];
        [self addSubview:footView];
      
       
    }
    return self;
}



-(void) resizeTheHeight
{
    CGFloat contentWidth = 280;  

    UIFont *font = [UIFont fontWithName:@"微软雅黑" size:14];  
    
    CGSize size = [txtContent.text sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 220) lineBreakMode:UILineBreakModeTailTruncation];  
    
    [txtContent setFrame:CGRectMake(20, 28, 280, size.height)];
    [centerimageView setFrame:CGRectMake(0, 0, 320, size.height+30)];
    [footView setFrame:CGRectMake(5, size.height+28, 310, 2)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif

@end
