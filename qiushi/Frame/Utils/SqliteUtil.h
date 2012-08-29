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
//+ (NSMutableArray*)queryDb;

@end
