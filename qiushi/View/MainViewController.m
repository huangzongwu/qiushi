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
#import "SVStatusHUD.h"


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

#pragma mark - view life cycle

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
    
    
    //初始化 摇一摇刷新
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shake" ofType:@"wav"];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    

    
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
    


    
    
    
}

- (void)viewDidUnload
{
    DLog(@"viewDidUnload");
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


//摇一摇 的准备
-(BOOL)canBecomeFirstResponder{
    return YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    DLog("viewDidAppear");
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated
{
    DLog("viewWillDisappear");
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    DLog("viewWillAppear");
    [super viewWillAppear:animated];
}


#pragma mark - action


-(void)segmentAction:(UISegmentedControl *)segment
{
    //tttttttttttttttttttttttt
//    [SVStatusHUD showWithImage:[UIImage imageNamed:@"icon_shake.png"] status:@"摇动刷新哦，亲~~"];
    
    
        //tttttttttttttttttttttttt
    
    if(segment.selectedSegmentIndex == 0)
    {   _timeType = QiuShiTimeRandom;
        
        
    }
    else if(segment.selectedSegmentIndex == 1)
    {
        _timeType = QiuShiTimeDay;
        
    }
    else if (segment.selectedSegmentIndex == 2)
    {
        _timeType = QiuShiTimeWeek;
        
    }
    else if (segment.selectedSegmentIndex == 3)
    {
        _timeType = QiuShiTimeMonth;
       
    }
    
    [m_contentView LoadPageOfQiushiType:_typeQiuShi Time:_timeType];
    
    
}


#pragma mark -  引导用户去 评分
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






//摇动后 
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    DLog(@"UIEventSubType : %d",motion);
    if(motion==UIEventSubtypeMotionShake)
    {
                
        AudioServicesPlaySystemSound (soundID);
        
        [SVStatusHUD showWithImage:[UIImage imageNamed:@"icon_shake.png"] status:@"摇动刷新哦，亲~~"];
        //刷新 数据
        [self refreshDate];
        
    }
    
}

#pragma mark - 刷新数据
- (void)refreshDate
{
    if (_typeQiuShi == QiuShiTypeTop) {
        self.navigationItem.rightBarButtonItem = _timeItem;
    }else
        self.navigationItem.rightBarButtonItem = nil;
    //刷新 数据
    [m_contentView LoadPageOfQiushiType:_typeQiuShi Time:_timeType];
}


#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif


@end
