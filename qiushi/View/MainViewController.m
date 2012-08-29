//
//  MainViewController.m
//  NetDemo
//
//  Created by xyxd on 12-8-10.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import "MainViewController.h"


#import "SqliteUtil.h"


#import "ContentViewController.h"


#define FTop      101
#define FRecent   102
#define FPhoto    103

//启动一定次数，引导用户去评分
#define kQDCS @"qdcs"  //启动次数
#define kTime 10


@interface MainViewController ()

@end

@implementation MainViewController
@synthesize m_contentView;
@synthesize typeQiuShi = _typeQiuShi;
@synthesize timeSegment = _timeSegment;
@synthesize timeItem = _timeItem;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    //设置糗事类型
    if (!_typeQiuShi) {
        _typeQiuShi = QiuShiTypeTop;
    }
    
    //时间类型
    if (!_timeType) {
        _timeType = QiuShiTimeRandom;
    }
    
    _timeSegment = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects: @"随便逛逛",@"日精选", @"周精选", @"月精选", nil]];
    [_timeSegment setSegmentedControlStyle:UISegmentedControlStyleBar];
    [_timeSegment setSelectedSegmentIndex:0];
    [_timeSegment addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
    _timeItem = [[UIBarButtonItem alloc] initWithCustomView:_timeSegment];
    
    
    
    if (_typeQiuShi == QiuShiTypeTop) {
        self.navigationItem.rightBarButtonItem = _timeItem;
    }else
        self.navigationItem.rightBarButtonItem = nil;
    
    
    //设置背景颜色
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
    
    
    
    [SqliteUtil initDb];
    
    
    
    //每隔一段时间，提示用户去评分
    [self pingFen];
    
    
    //添加内容的TableView
    self.m_contentView = [[ContentViewController alloc]initWithNibName:@"ContentViewController" bundle:nil];
    [m_contentView.view setFrame:CGRectMake(0, 0, kDeviceWidth, self.view.frame.size.height)];
    [m_contentView LoadPageOfQiushiType:_typeQiuShi Time:_timeType];
    [self.view addSubview:m_contentView.view];
    

//    NSString *astring01 = @"1.0";
//    NSString *astring02 = @"0.9.120821";
//    BOOL result = [astring01 compare:astring02] == NSOrderedAscending;
//    NSLog(@"result:%d",result);
//    //NSOrderedAscending 判断两对象值的大小(按字母顺序进行比较，astring02大于astring01为真)
    
    
    
}

-(void)segmentAction:(UISegmentedControl *)segment
{
    if(segment.selectedSegmentIndex == 0)
    {
        [m_contentView LoadPageOfQiushiType:_typeQiuShi Time:QiuShiTimeRandom];
        
    }
    else if(segment.selectedSegmentIndex == 1)
    {
        [m_contentView LoadPageOfQiushiType:_typeQiuShi Time:QiuShiTimeDay];
    }
    else if (segment.selectedSegmentIndex == 2)
    {
        [m_contentView LoadPageOfQiushiType:_typeQiuShi Time:QiuShiTimeWeek];
    }
    else if (segment.selectedSegmentIndex == 3)
    {
        [m_contentView LoadPageOfQiushiType:_typeQiuShi Time:QiuShiTimeMonth];
    }
    
    
    
}

- (void) pingFen
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int sum = [[ud objectForKey:kQDCS] intValue];
    
    if (sum < kTime) {
        sum++;
        
    }else if(sum == kTime){
        sum = 0;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"糗事囧事有什么需要改进的吗？去评个分吧~~" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去评分", nil];
        
        [alert show];
     
    }
    
    [ud setInteger:sum forKey:kQDCS];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //前去评分
        NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",MyAppleID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif


@end
