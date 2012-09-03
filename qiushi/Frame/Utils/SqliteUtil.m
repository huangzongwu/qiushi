//
//  SqliteUtil.m
//  NetDemo
//
//  Created by xyxd mac on 12-8-17.
//
//

#import "SqliteUtil.h"

#import "QiuShi.h"
#import "JSON.h"
#import "SVStatusHUD.h"

@implementation SqliteUtil

static sqlite3 *qiushiDB;
static NSString *databasePath;
static NSArray *dirPaths;


+(void) initDb
{
    

    
    /*根据路径创建数据库并创建一个表contact(id nametext addresstext phonetext)*/
    
    NSString *docsDir;

    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"qiushis.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath:databasePath] == NO)
    {
//        const char *dbpath = [databasePath UTF8String];
//        if (sqlite3_open(dbpath, &qiushiDB)==SQLITE_OK)
//        {
//            char *errMsg;
//            
//            
//            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS QIUSHIS(ID INTEGER PRIMARY KEY AUTOINCREMENT, QIUSHIID TEXT,IMAGEURL TEXT,IMAGEMIDURL TEXT,TAG TEXT, CONTENT TEXT,COMMENTSCOUNT INTEGER,UPCOUNT INTEGER,DOWNCOUNT INTEGER,ANCHOR TEXT,FBTIME TEXT)";
//            
//            if (sqlite3_exec(qiushiDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
//                NSLog(@"创建表失败\n");
//            }
//        }
//        else
//        {
//            NSLog(@"创建/打开数据库失败");
//        }
    }else
    {
        DLog(@"数据库已存在");
    }
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &qiushiDB)==SQLITE_OK)
    {
        char *errMsg;
        
        
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS QIUSHIS(ID INTEGER PRIMARY KEY AUTOINCREMENT, QIUSHIID TEXT,IMAGEURL TEXT,IMAGEMIDURL TEXT,TAG TEXT, CONTENT TEXT,COMMENTSCOUNT INTEGER,UPCOUNT INTEGER,DOWNCOUNT INTEGER,ANCHOR TEXT,FBTIME TEXT)";
        
        if (sqlite3_exec(qiushiDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"创建表失败\n");
        }
    }
    else
    {
        NSLog(@"创建/打开数据库失败");
    }
    
}

+ (void)saveDb:(QiuShi*)qs
{
    
    sqlite3_stmt *statement;
    
    
//    NSLog(@"%@",databasePath);
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &qiushiDB)==SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO QIUSHIS (qiushiid,imageurl,imagemidurl,tag,content,commentscount,upcount,downcount,anchor,fbtime) VALUES( \"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\")",qs.qiushiID,qs.imageURL,qs.imageMidURL,qs.tag,qs.content,qs.commentsCount,qs.upCount,qs.downCount,qs.anchor,qs.fbTime];
        
               
//        DLog(@"%@",insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(qiushiDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement)==SQLITE_DONE) {
            NSLog(@"已存储到数据库");
             [SVStatusHUD showWithImage:[UIImage imageNamed:@"wifi.png"] status:[NSString stringWithFormat:@"已存储到数据库"]];
        }
        else
        {
            NSLog(@"保存失败");
            
            NSLog(@"Error:%s",sqlite3_errmsg(qiushiDB));
            [SVStatusHUD showWithImage:[UIImage imageNamed:@"wifi.png"] status:[NSString stringWithFormat:@"Error:%s",sqlite3_errmsg(qiushiDB)]];
        }
        sqlite3_finalize(statement);
        sqlite3_close(qiushiDB);
    }
}

//
+ (NSMutableArray*)queryDb
{
    NSMutableArray *selectArray = [[NSMutableArray alloc]init];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT  * from QIUSHIS"];


        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(qiushiDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
          

                NSLog(@"已查到结果");
                 [SVStatusHUD showWithImage:[UIImage imageNamed:@"wifi.png"] status:[NSString stringWithFormat:@"已查到结果"]];
// qs.qiushiID,qs.imageURL,qs.imageMidURL,qs.tag,qs.content,qs.commentsCount,qs.upCount,qs.downCount,qs.anchor,qs.fbTime
//
                
                QiuShi *qs;
//                NSDictionary *qs = [[NSDictionary alloc]init];
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                 
                    qs = [[QiuShi alloc]init];
                    qs.qiushiID = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 1)]];

                    qs.imageURL = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 2)]];
                    qs.imageMidURL = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 3)]];
                    qs.tag = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 4)]];
                    qs.content = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 5)]];
                    qs.commentsCount = (int)(char *)sqlite3_column_text(statement, 6);
                    qs.upCount = (int)(char *)sqlite3_column_text(statement, 7);
                    qs.downCount = (int)(char *)sqlite3_column_text(statement, 8);
                    qs.anchor = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 9)]];
                    qs.fbTime = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 10)]];

//                    DLog(@"%@",qs.qiushiID);
//                    DLog(@"%@",qs.imageURL);
//                    DLog(@"%@",qs.imageMidURL);
//
//                    DLog(@"%@",qs.tag);
//                    DLog(@"%@",qs.content);
//                    DLog(@"%d",qs.commentsCount);
//                    DLog(@"%d",qs.upCount);
//                    DLog(@"%d",qs.downCount);
//                    DLog(@"%@",qs.anchor);
//                    DLog(@"%@",qs.fbTime);
                    
                    
//                    
//                    id image = [dictionary objectForKey:@"image"];
//                    if ((NSNull *)image != [NSNull null])
//                    {
//                        self.imageURL = [dictionary objectForKey:@"image"];
//                        
//                        NSString *newImageURL = [NSString stringWithFormat:@"http://img.qiushibaike.com/system/pictures/%@/small/%@",qiushiID,imageURL];
//                        NSString *newImageMidURL = [NSString stringWithFormat:@"http://img.qiushibaike.com/system/pictures/%@/medium/%@",qiushiID,imageURL];
//                        self.imageURL = newImageURL;
//                        self.imageMidURL = newImageMidURL;
//                    }
//                    
//                    NSDictionary *vote = [NSDictionary dictionaryWithDictionary:[dictionary objectForKey:@"votes"]];
//                    self.downCount = [[vote objectForKey:@"down"]intValue];
//                    self.upCount = [[vote objectForKey:@"up"]intValue];
//                    
//                    id user = [dictionary objectForKey:@"user"];
//                    if ((NSNull *)user != [NSNull null]) 
//                    {
//                        NSDictionary *user = [NSDictionary dictionaryWithDictionary:[dictionary objectForKey:@"user"]];
//                        self.anchor = [user objectForKey:@"login"];
//                    }
//
//                    
//                    NSDictionary *dic = [NSDictionary alloc]initWithObjectsAndKeys:
//                    qs.qiushiID,@"id",
//                    qs.tag,@"tag",
//                    qs.content,@"content",
//                    qs.commentsCount,@"commentsCount",
//                    qs.imageURL,@"imageURL",
//                    nil


                    
                    [selectArray addObject:qs];

                }
                
            }
            else {
                NSLog( @"未查到结果");
                
                NSLog(@"Error:%s",sqlite3_errmsg(qiushiDB));
                  [SVStatusHUD showWithImage:[UIImage imageNamed:@"wifi.png"] status:[NSString stringWithFormat:@"Error:%s",sqlite3_errmsg(qiushiDB)]];
                
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(qiushiDB);
    }
    
    if (selectArray.count > 0) {
        
        DLog(@"查到%d条数据",selectArray.count);
         [SVStatusHUD showWithImage:[UIImage imageNamed:@"wifi.png"] status:[NSString stringWithFormat:@"查到%d条数据",selectArray.count]];
        return selectArray;
    }
    return nil;
}


+ (NSString*)processString:(NSString*)str
{
    if (str == nil || [str isEqualToString:@""] || [str isEqualToString:@"(null)"]) {
        return @"";
    }else{
        return str;
    }
}



 

- (BOOL) deleteData:(NSString*)tableName UUID:(NSString*)uuid
{
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        NSString *deleteSqlStr = [NSString stringWithFormat:@"delete from QIUSHIS where QIUSHIID = ?"];
        
    
        
        
        const char *deleteSql  = [deleteSqlStr UTF8String];
        int deleteSqlOk = sqlite3_prepare_v2(qiushiDB, deleteSql, -1, &statement, nil);
        if (deleteSqlOk != SQLITE_OK) {
            
            NSLog(@"Error:%s",sqlite3_errmsg(qiushiDB));
             [SVStatusHUD showWithImage:[UIImage imageNamed:@"wifi.png"] status:[NSString stringWithFormat:@"Error:%s",sqlite3_errmsg(qiushiDB)]];
            
            printf("---------- delete sql is error!-------------\r\n");
            sqlite3_close(qiushiDB);
            return NO;
        }
        
        sqlite3_bind_text(statement, 1, [uuid UTF8String], -1, SQLITE_TRANSIENT);
        
        int execDeleteSqlOk = sqlite3_step(statement);
        sqlite3_finalize(statement);
        
        if (execDeleteSqlOk == SQLITE_ERROR) {
            sqlite3_close(qiushiDB);
            return NO;
        }
        
    }
    printf("----------delete data t_Infor Database is OK!-------------\r\n");
    sqlite3_close(qiushiDB);
    return YES;
}
    

+ (BOOL)delAll
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        NSString *deleteSqlStr = [NSString stringWithFormat:@"drop table qiushis"];
        
        
        
        
        const char *deleteSql  = [deleteSqlStr UTF8String];
        int deleteSqlOk = sqlite3_prepare_v2(qiushiDB, deleteSql, -1, &statement, nil);
        if (deleteSqlOk != SQLITE_OK) {
            printf("---------- delete sql is error!-------------\r\n");
            
            NSLog(@"Error:%s",sqlite3_errmsg(qiushiDB));
             [SVStatusHUD showWithImage:[UIImage imageNamed:@"wifi.png"] status:[NSString stringWithFormat:@"Error:%s",sqlite3_errmsg(qiushiDB)]];
            
            sqlite3_close(qiushiDB);
            return NO;
        }
        
//        sqlite3_bind_text(statement, 1, [uuid UTF8String], -1, SQLITE_TRANSIENT);
        
        int execDeleteSqlOk = sqlite3_step(statement);
        sqlite3_finalize(statement);
        
        if (execDeleteSqlOk == SQLITE_ERROR) {
            sqlite3_close(qiushiDB);
            return NO;
        }
        
    }
    printf("----------delete data t_Infor Database is OK!-------------\r\n");
    sqlite3_close(qiushiDB);
    return YES;

}
    
@end
    