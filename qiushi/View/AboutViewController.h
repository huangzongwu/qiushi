//
//  AboutViewController.h
//  NetDemo
//
//  Created by xyxd mac on 12-8-17.
//
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_iconImageView;
    UILabel *_name;
    UILabel *_copyright1;
    UILabel *_copyright2;
    UITableView *_mTable;
    
    NSMutableArray *_items;
    NSMutableArray *_subItems;
}

@property (nonatomic, retain) UILabel *name;
@property (nonatomic, retain) UILabel *copyright1;
@property (nonatomic, retain) UILabel *copyright2;
@property (nonatomic, retain) UITableView *mTable;
@property (nonatomic, retain) UIImageView *iconImageView;

@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSMutableArray *subItems;

@end
