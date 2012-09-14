//
//  AboutViewController.m
//  NetDemo
//
//  Created by xyxd mac on 12-8-17.
//
//

#import "AboutViewController.h"

#import "DDMenuController.h"
@interface AboutViewController ()
{
    
}

@end

@implementation AboutViewController

@synthesize name = _name;
@synthesize mTable = _mTable;
@synthesize iconImageView = _iconImageView;
@synthesize items = _items;
@synthesize subItems = _subItems;
@synthesize copyright1 = _copyright1;
@synthesize copyright2 = _copyright2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"关于";
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
    
    //设置背景颜色
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
    
    
    _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(132.0, 28.0, 57.0, 57.0)];
    _iconImageView.image = [UIImage imageNamed:@"Icon.png"];
    [self.view addSubview:_iconImageView];
    
    _name = [[UILabel alloc]initWithFrame:CGRectMake(0, 101, 320, 21)];
    _name.text = @"糗事囧事 1.0.120901";
    _name.font = [UIFont fontWithName:@"微软雅黑" size:17];
    _name.textAlignment = UITextAlignmentCenter;
    _name.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_name];
    
    _copyright1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 346, 320, 21)];
    _copyright1.text = @"内容及版权归 糗事百科 所有";
    _copyright1.font = [UIFont fontWithName:@"微软雅黑" size:15];
    _copyright1.textAlignment = UITextAlignmentCenter;
    _copyright1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_copyright1];

    _copyright2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 375, 320, 21)];
    _copyright2.text = @"个人仅作学习之用";
    _copyright2.font = [UIFont fontWithName:@"微软雅黑" size:15];
    _copyright2.textAlignment = UITextAlignmentCenter;
    _copyright2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_copyright2];

    
    _mTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 130, 320, 208) style:UITableViewStyleGrouped];
    _mTable.delegate = self;
    _mTable.dataSource = self;
    _mTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_mTable];
    
    _items = [[NSMutableArray alloc]initWithObjects:@"内容及版权",@"开发者邮箱", nil];
    _subItems = [[NSMutableArray alloc]initWithObjects:@"糗事百科",@"xyxdasnjss@163.com", nil];
    
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.name = nil;
    self.copyright1 = nil;
    self.copyright2 = nil;
    self.mTable = nil;
    self.items = nil;
    self.subItems = nil;
    self.iconImageView = nil;
}


- (void)showLeft:(id)seder
{
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showLeftController:YES];
    

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TableView*
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"_ContentCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    //设置cell 样式
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.subItems objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont fontWithName:@"微软雅黑" size:15.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"微软雅黑" size:14.0];
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.qiushibaike.com/"]];
        
    }else if (indexPath.row == 1){
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://xyxdasnjss@163.com"]];
        
    }
}

#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif

@end
