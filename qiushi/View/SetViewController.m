//
//  SetViewController.m
//  NetDemo
//
//  Created by xyxd mac on 12-8-20.
//
//

#import "SetViewController.h"

#import "DDMenuController.h"
@interface SetViewController ()
{
    UIBarButtonItem *leftMenuBtn;
    

}
@end

@implementation SetViewController

@synthesize items = _items;
@synthesize subItems = _subItems;
@synthesize mTable = _mTable;
@synthesize adSwitch = _adSwitch;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"设置";
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
    
    
//    leftMenuBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_menu_icon.png"]
//                                                               style:UIBarButtonItemStyleBordered
//                                                              target:self
//                                                              action:@selector(showLeft:)];
//
//    self.navigationItem.leftBarButtonItem = leftMenuBtn;
    
   
    
    //设置背景颜色
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
    
    
    _mTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, 320, 480 - 20 - 44 - 30) style:UITableViewStyleGrouped];
    _mTable.delegate = self;
    _mTable.dataSource = self;
    _mTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_mTable];
    
    _items = [[NSMutableArray alloc]initWithObjects:@"显示广告",@"去给评个分吧", nil];
    _subItems = [[NSMutableArray alloc]initWithObjects:@"", nil];
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    _adSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [_adSwitch setOn:[[ud objectForKey:@"showAD"] boolValue] animated:NO];
    [_adSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    

    
    

    
}

- (void)viewDidUnload
{
    
    self.adSwitch = nil;
    self.items = nil;
    self.subItems = nil;
    self.mTable = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)showLeft:(id)seder
{
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showLeftController:YES];
    
    
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
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont fontWithName:@"微软雅黑" size:15.0];
    cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
    //    cell.detailTextLabel.text = [self.subItems objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        
        cell.accessoryView = _adSwitch;
        
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        
        
    }else if (indexPath.row == 1){
        
        //多次跳转，没有下面的好
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/addUserReview?id=545549453&type=Purple+Software"]];
        
        //前去评分
        NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",MyAppleID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }
}

- (void) switchChanged:(id)sender
{
    UISwitch* switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithBool:switchControl.on]  forKey:@"showAD"];
    
    
}





#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif

@end
