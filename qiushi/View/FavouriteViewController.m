//
//  FavouriteViewController.m
//  qiushi
//
//  Created by xyxd on 12-9-4.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import "FavouriteViewController.h"

#import "PullingRefreshTableView.h"
#import "CommentsViewController.h"

#import "CJSONDeserializer.h"
#import "QiuShi.h"
#import "GADBannerView.h"
#import "SqliteUtil.h"
#import "SVStatusHUD.h"
#import "MyNavigationController.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
@interface FavouriteViewController () <
PullingRefreshTableViewDelegate,
UITableViewDataSource,
UITableViewDelegate
>

@property (retain,nonatomic) PullingRefreshTableView *tableView;
@property (retain,nonatomic) NSMutableArray *list;
@property (nonatomic) BOOL refreshing;
@property (assign,nonatomic) NSInteger page;
@end

@implementation FavouriteViewController

@synthesize tableView = _tableView;
@synthesize list = _list;
@synthesize refreshing = _refreshing;
@synthesize page = _page;
@synthesize cacheArray = _cacheArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"个人收藏";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.hidesBackButton = YES;
    
    
    
    UIImage *image = [UIImage imageNamed:@"nav_menu_icon.png"];
    UIImage *imagef = [UIImage imageNamed:@"nav_menu_icon_f.png"];
    CGRect backframe= CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:backframe];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:imagef forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(showLeft:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* someBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = someBarButtonItem;
    
    
    
    
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    //设置背景颜色
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
    
    
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
    

    
    
    
    _cacheArray = [SqliteUtil queryDbIsSave];
    if (_cacheArray != nil) {
        [self.list removeAllObjects];
        for (QiuShi *qiushi in _cacheArray)
        {
            QiuShi *qs = [[QiuShi alloc]initWithQiushi:qiushi];
            
            [self.list addObject:qs];
            
        }
        
        //数据源去重复
        [self removeRepeatArray];
        
        
        
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd  = NO;
        [self.tableView reloadData];
        
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
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)viewDidAppear:(BOOL)animated
{
    //解决本view与root 共同的手势 冲突
    _menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [_menuController.tap setEnabled:NO];
    [_menuController.pan setEnabled:NO];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [_menuController.tap setEnabled:YES];
    [_menuController.pan setEnabled:YES];
}

#pragma mark - Your actions

- (void)loadData{
    
    self.page++;
        
    
    
}



-(void) GetResult:(ASIHTTPRequest *)request
{
    
    //    NSString *responseString = [request responseString];
    //    NSLog(@"%@\n",responseString);
    
    if (self.refreshing) {
        self.page = 1;
        self.refreshing = NO;
        if (self.list.count > 100) {
            [self.list removeAllObjects];
        }
        
        [SqliteUtil initDb];
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
    
    
    
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    
    
    CommentsViewController *comments=[[CommentsViewController alloc]initWithNibName:@"CommentsViewController" bundle:nil];
    comments.qs = [self.list objectAtIndex:indexPath.row];
    
    
    [[delegate navController] pushViewController:comments animated:YES];
    
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        DLog(@"delete");
    }
    
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
    if (qs.imageURL==nil || [qs.imageURL isEqualToString:@""]) {
        height = size.height+140;
    }else
    {
        height = size.height+220;
    }
    // 返回需要的高度
    return height;
}

- (void)removeRepeatArray
{
    DLog(@"原来：%d",self.list.count);
    NSMutableArray* filterResults = [[NSMutableArray alloc] init];
    BOOL copy;
    if (![self.list count] == 0) {
        for (QiuShi *a1 in self.list) {
            copy = YES;
            for (QiuShi *a2 in filterResults) {
                if ([a1.qiushiID isEqualToString:a2.qiushiID] && [a1.anchor isEqualToString:a2.anchor]) {
                    copy = NO;
                    break;
                }
            }
            if (copy) {
                [filterResults addObject:a1];
            }
        }
    }
    
    self.list = filterResults;
    DLog(@"之后：%d",self.list.count);
    //    self.list = [NSMutableArray arrayWithArray:[self.list sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
    
}

- (void)showLeft:(id)seder
{
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showLeftController:YES];
    
    
}


#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif


@end
