//
//  ContentViewController.m
//  NetDemo
//
//  Created by xyxd on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContentViewController.h"
#import "PullingRefreshTableView.h"
#import "CommentsViewController.h"
#import "CJSONDeserializer.h"
#import "QiuShi.h"
#import "GADBannerView.h"
#import "SqliteUtil.h"

@interface ContentViewController () <
PullingRefreshTableViewDelegate,
ASIHTTPRequestDelegate,
UITableViewDataSource,
UITableViewDelegate
>
-(void) GetErr:(ASIHTTPRequest *)request;
-(void) GetResult:(ASIHTTPRequest *)request;
@property (retain,nonatomic) PullingRefreshTableView *tableView;
@property (retain,nonatomic) NSMutableArray *list;
@property (nonatomic) BOOL refreshing;
@property (assign,nonatomic) NSInteger page;
@end

@implementation ContentViewController
@synthesize tableView = _tableView;
@synthesize list = _list;
@synthesize refreshing = _refreshing;
@synthesize page = _page;
@synthesize asiRequest = _asiRequest;
@synthesize Qiutype,QiuTime;
@synthesize cacheArray = _cacheArray;






- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor clearColor]];
    _list = [[NSMutableArray alloc] init ];
    

//    NSLog(@"viewDidLoad content");
    
    //ad
    bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
                                            self.view.frame.size.height - GAD_SIZE_320x50.height,
                                            GAD_SIZE_320x50.width,
                                            GAD_SIZE_320x50.height)];//设置位置
    
    bannerView_.adUnitID = MY_BANNER_UNIT_ID;//调用你的id
    bannerView_.rootViewController = self;
    [bannerView_ loadRequest:[GADRequest request]];
    
    
    CGRect bounds = self.view.bounds;
    bounds.size.height -= (44);
    self.tableView = [[PullingRefreshTableView alloc] initWithFrame:bounds pullingDelegate:self];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
//    _asiRequest = nil;
    
    
    
    
    _cacheArray = [SqliteUtil queryDb];
    if (_cacheArray != nil) {
        for (QiuShi *qiushi in _cacheArray)
        {
            QiuShi *qs = [[QiuShi alloc]initWithQiushi:qiushi];
            
                        
            
            [self.list addObject:qs];
            
            DLog(@"%@",[self.list description]);
            [self.tableView reloadData];
        }

    }
    
    
//    if (self.page == 0) {
//
//        [self.tableView launchRefreshing];
//    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    //    NSLog(@"dealloc content");
    self.asiRequest.delegate = nil;
}

#pragma mark - Your actions

- (void)loadData{
    
    self.page++;
    NSURL *url;
    
    if (Qiutype == QiuShiTypeTop) {
        switch (QiuTime) {
            case QiuShiTimeRandom:
                url = [NSURL URLWithString:SuggestURLString(10,self.page)];
                break;
            case QiuShiTimeDay:
                url = [NSURL URLWithString:DayURLString(10,self.page)];
                break;
            case QiuShiTimeWeek:
                url = [NSURL URLWithString:WeakURlString(10,self.page)];
                break;
            case QiuShiTimeMonth:
                url = [NSURL URLWithString:MonthURLString(10,self.page)];
                break;
            default:
                url = [NSURL URLWithString:SuggestURLString(10,self.page)];
                break;
        }
    }else{
        switch (Qiutype) {
            case QiuShiTypeTop:
                url = [NSURL URLWithString:SuggestURLString(10,self.page)];
                break;
            case QiuShiTypeNew:
                url = [NSURL URLWithString:LastestURLString(10,self.page)];
                break;
            case QiuShiTypePhoto:
                url = [NSURL URLWithString:ImageURLString(10,self.page)];
                break;
            default:
                url = [NSURL URLWithString:SuggestURLString(10,self.page)];
                break;
        }
    }
    
    
    
    
    NSLog(@"%@",url);
//    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    
    _asiRequest = [ASIHTTPRequest requestWithURL:url];
    [_asiRequest setDelegate:self];
    [_asiRequest setDidFinishSelector:@selector(GetResult:)];
    [_asiRequest setDidFailSelector:@selector(GetErr:)];
    [_asiRequest startAsynchronous];
    
}

-(void) GetErr:(ASIHTTPRequest *)request
{
    self.refreshing = NO;
    [self.tableView tableViewDidFinishedLoading];

    
    NSString *responseString = [request responseString];
    NSLog(@"%@\n",responseString);
    NSError *error = [request error];
    NSLog(@"-------------------------------\n");
    NSLog(@"error:%@",error);
    
    
    
}

-(void) GetResult:(ASIHTTPRequest *)request
{
    
//    NSString *responseString = [request responseString];
//    NSLog(@"%@\n",responseString);
    
    if (self.refreshing) {
        self.page = 1;
        self.refreshing = NO;
        [self.list removeAllObjects];
    }
    NSData *data =[request responseData];
    NSMutableDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:data error:nil];
    
  
    
    if ([dictionary objectForKey:@"items"]) {
		NSArray *array = [NSArray arrayWithArray:[dictionary objectForKey:@"items"]];
        

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yy-MM-dd HH:mm"];

        for (NSDictionary *qiushi in array)
        {
            QiuShi *qs = [[QiuShi alloc]initWithDictionary:qiushi];
            
            qs.fbTime = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:qs.published_at]];
            
//            DLog(@"%@",@"dsfasdfsa");
            
//            //ttttttttttt
//            qs.content = @"中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试中文测试111";
//            qs.content = @"test...";
//            qs.imageURL = @"http://img.qiushibaike.com/system/pictures/6317243/small/app6317243.jpg";
//            qs.imageMidURL = @"http://img.qiushibaike.com/system/pictures/6317243/medium/app6317243.jpg";
//            //tttttttttttt
            
            
            
            
            //保存到数据库
            [SqliteUtil saveDb:qs];
            

            [self.list addObject:qs];
        }
        
		
    }    
    
    if (self.page >= 20) {
        [self.tableView tableViewDidFinishedLoadingWithMessage:@"亲，下面没有了哦..."];
        self.tableView.reachedTheEnd  = YES;
    } else {        
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd  = NO;
        [self.tableView reloadData];
    }
    
}
#pragma mark - TableView*
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Contentidentifier = @"_ContentCELL";
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:Contentidentifier];
    if (cell == nil){
        //设置cell 样式
        cell = [[ContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Contentidentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
    }
    
    QiuShi *qs = [self.list objectAtIndex:[indexPath row]];
    //设置内容
    cell.txtContent.text = qs.content;
    
    [cell.txtContent setNumberOfLines: 12];
    
    //设置图片
    if (qs.imageURL!=nil && qs.imageURL!= @"") {
        cell.imgUrl = qs.imageURL;
        cell.imgMidUrl = qs.imageMidURL;
        // cell.imgPhoto.hidden = NO;
    }else
    {
        cell.imgUrl = @"";
        cell.imgMidUrl = @"";
        // cell.imgPhoto.hidden = YES;
    }
    //设置用户名
    if (qs.anchor!=nil && qs.anchor!= @"") 
    {
        cell.txtAnchor.text = qs.anchor;
    }else
    {
        cell.txtAnchor.text = @"匿名";
    }
    //设置标签
    if (qs.tag!=nil && qs.tag!= @"") 
    {
        cell.txtTag.text = qs.tag;
    }else
    {
        cell.txtTag.text = @"";
    }
    //设置up ，down and commits
    [cell.goodbtn setTitle:[NSString stringWithFormat:@"%d",qs.upCount] forState:UIControlStateNormal];
    [cell.badbtn setTitle:[NSString stringWithFormat:@"%d",qs.downCount] forState:UIControlStateNormal];
    [cell.commentsbtn setTitle:[NSString stringWithFormat:@"%d",qs.commentsCount] forState:UIControlStateNormal];
    
    //发布时间
    cell.txtTime.text = qs.fbTime;


    
    //自适应函数
    [cell resizeTheHeight:kTypeMain];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getTheHeight:indexPath.row];
}

//自定义 头内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    //是否显示广告
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    if ([[ud objectForKey:@"showAD"] boolValue] == YES) {
        return bannerView_;
    }else{
        return nil;
    }
   	
}



//自定义 头高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //是否显示广告
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    if ([[ud objectForKey:@"showAD"] boolValue] == YES) {
        return GAD_SIZE_320x50.height;;
    }else{
        return .0f;
    }
    
}



#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}


- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];    
}

#pragma mark - Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       
    UINavigationController *menuController = (UINavigationController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    CommentsViewController *demoView=[[CommentsViewController alloc]initWithNibName:@"CommentsViewController" bundle:nil];
    demoView.qs = [self.list objectAtIndex:indexPath.row];
    [menuController pushViewController:demoView animated:YES];
    

}

#pragma mark - LoadPage
-(void) LoadPageOfQiushiType:(QiuShiType) type Time:(QiuShiTime) time
{
    self.Qiutype = type;
    self.QiuTime = time;
    self.page =0;
    [self.tableView launchRefreshing];
    
}


-(CGFloat) getTheHeight:(NSInteger)row
{
    CGFloat contentWidth = 280;  
    // 设置字体
    UIFont *font = [UIFont fontWithName:@"微软雅黑" size:14];  
    
    QiuShi *qs =[self.list objectAtIndex:row];  
    // 显示的内容 
    NSString *content = qs.content;
    // 计算出长宽
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 220) lineBreakMode:UILineBreakModeTailTruncation]; 
    CGFloat height;
    if (qs.imageURL==nil) {
        height = size.height+140;
    }else
    {
        height = size.height+220;
    }
    // 返回需要的高度  
    return height; 
}




#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif


@end