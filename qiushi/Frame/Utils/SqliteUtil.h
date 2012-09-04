//
//  SqliteUtil.h
//  NetDemo
//
//  Created by xyxd mac on 12-8-17.
//
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>
@class QiuShi;

@interface SqliteUtil : NSObject
{
    
    
    
}

+ (void)initDb;
+ (void)saveDb:(QiuShi*)qs;
+ (NSMutableArray*)queryDb;
+ (NSString*)processString:(NSString*)str;

+ (BOOL)delAll;//删除所有数据（删除表）
+ (BOOL)delNoSave;//删除未收藏的
+ (NSMutableArray*)queryDbIsSave;//查询收藏的
@end
