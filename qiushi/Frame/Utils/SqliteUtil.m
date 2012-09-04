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

#import "MyProgressHud.h"

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
        
        [MyProgressHud showHUD:[NSString stringWithFormat:@"数据库已存在,%s",sqlite3_errmsg(qiushiDB)]];
    }
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &qiushiDB)==SQLITE_OK)
    {
        char *errMsg;
        
        
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS QIUSHIS(ID INTEGER PRIMARY KEY AUTOINCREMENT, QIUSHIID TEXT unique,IMAGEURL TEXT,IMAGEMIDURL TEXT,TAG TEXT, CONTENT TEXT,COMMENTSCOUNT TEXT,UPCOUNT TEXT,DOWNCOUNT TEXT,ANCHOR TEXT,FBTIME TEXT,isSave text)";
        
        if (sqlite3_exec(qiushiDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            
            
            
            
            
            [MyProgressHud showHUD:[NSString stringWithFormat:@"创建表失败,%s",sqlite3_errmsg(qiushiDB)]];
            
        }
    }
    else
    {
        
        [MyProgressHud showHUD:[NSString stringWithFormat:@"创建/打开数据库失败,%s",sqlite3_errmsg(qiushiDB)]];
    }
    
}

+ (void)saveDb:(QiuShi*)qs
{
    
    
    
    sqlite3_stmt *statement;
    
    
    //    NSLog(@"%@",databasePath);
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &qiushiDB)==SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO QIUSHIS (qiushiid,imageurl,imagemidurl,tag,content,commentscount,upcount,downcount,anchor,fbtime,isSave) VALUES( \"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",'no')",qs.qiushiID,qs.imageURL,qs.imageMidURL,qs.tag,qs.content,[NSString stringWithFormat:@"%d",qs.commentsCount],[NSString stringWithFormat:@"%d",qs.upCount],[NSString stringWithFormat:@"%d",qs.downCount],qs.anchor,qs.fbTime];
        
        
        
        
        //        DLog(@"%@",insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(qiushiDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement)==SQLITE_DONE) {
            
            
            
            [MyProgressHud showHUD:[NSString stringWithFormat:@"已存储到数据库,"]];
            
        }
        else
        {
            
            
            
            [MyProgressHud showHUD:[NSString stringWithFormat:@"保存失败:%s",sqlite3_errmsg(qiushiDB)]];
            
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
        NSString *querySQL = [NSString stringWithFormat:@"SELECT  * from QIUSHIS order by upcount desc"];
        //本打算按 upcount 降序排序，但是string类型，所以 是 乱序了，
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(qiushiDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                
                NSLog(@"已查到结果");
                
                
                QiuShi *qs;
                
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                    qs = [[QiuShi alloc]init];
                    qs.qiushiID = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 1)]];
                    
                    qs.imageURL = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 2)]];
                    qs.imageMidURL = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 3)]];
                    qs.tag = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 4)]];
                    qs.content = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 5)]];
                    qs.commentsCount = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 6)] intValue];
                    qs.upCount = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 7)] intValue];
                    qs.downCount = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 8)] intValue];
                    qs.anchor = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 9)]];
                    qs.fbTime = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 10)]];
                    
                    
                    
                    
                    [selectArray addObject:qs];
                    
                }
                
            }
            else {
                
                
                
                [MyProgressHud showHUD:[NSString stringWithFormat:@"查询出错:%s",sqlite3_errmsg(qiushiDB)]];
                
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(qiushiDB);
    }
    
    if (selectArray.count > 0) {
        
        
        [MyProgressHud showHUD:[NSString stringWithFormat:@"查到%d条数据",selectArray.count]];
        
        if (selectArray.count > 200) {
            [self delNoSave];
            [MyProgressHud showHUD:[NSString stringWithFormat:@"数据超过200条，删除数据"]];
        }
        
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
            
            [MyProgressHud showHUD:[NSString stringWithFormat:@"删除出错:%s",sqlite3_errmsg(qiushiDB)]];
            
            
            
            
            sqlite3_close(qiushiDB);
            return NO;
        }
        
        
        int execDeleteSqlOk = sqlite3_step(statement);
        sqlite3_finalize(statement);
        
        if (execDeleteSqlOk == SQLITE_ERROR) {
            sqlite3_close(qiushiDB);
            return NO;
        }
        
    }
    [MyProgressHud showHUD:[NSString stringWithFormat:@"删除成功"]];
    sqlite3_close(qiushiDB);
    return YES;
    
}

+ (BOOL)delNoSave
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        NSString *deleteSqlStr = [NSString stringWithFormat:@"delete from QIUSHIS where issave='no'"];
        
        
        
        
        const char *deleteSql  = [deleteSqlStr UTF8String];
        int deleteSqlOk = sqlite3_prepare_v2(qiushiDB, deleteSql, -1, &statement, nil);
        if (deleteSqlOk != SQLITE_OK) {
            
            [MyProgressHud showHUD:[NSString stringWithFormat:@"删除出错:%s",sqlite3_errmsg(qiushiDB)]];
            
            
            
            
            sqlite3_close(qiushiDB);
            return NO;
        }
        
        
        int execDeleteSqlOk = sqlite3_step(statement);
        sqlite3_finalize(statement);
        
        if (execDeleteSqlOk == SQLITE_ERROR) {
            sqlite3_close(qiushiDB);
            return NO;
        }
        
    }
    [MyProgressHud showHUD:[NSString stringWithFormat:@"删除成功"]];
    sqlite3_close(qiushiDB);
    return YES;
    
}


+ (NSMutableArray*)queryDbIsSave
{
    
    
    
    NSMutableArray *selectArray = [[NSMutableArray alloc]init];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT  * from QIUSHIS where issave='yes' order by upcount desc"];
        //本打算按 upcount 降序排序，但是string类型，所以 是 乱序了，
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(qiushiDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                
                NSLog(@"已查到结果");
                
                
                QiuShi *qs;
                
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                    qs = [[QiuShi alloc]init];
                    qs.qiushiID = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 1)]];
                    
                    qs.imageURL = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 2)]];
                    qs.imageMidURL = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 3)]];
                    qs.tag = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 4)]];
                    qs.content = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 5)]];
                    qs.commentsCount = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 6)] intValue];
                    qs.upCount = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 7)] intValue];
                    qs.downCount = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 8)] intValue];
                    qs.anchor = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 9)]];
                    qs.fbTime = [self processString:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 10)]];
                    
                    
                    
                    
                    [selectArray addObject:qs];
                    
                }
                
            }
            else {
                
                
                
                [MyProgressHud showHUD:[NSString stringWithFormat:@"查询出错:%s",sqlite3_errmsg(qiushiDB)]];
                
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(qiushiDB);
    }
    
    if (selectArray.count > 0) {
        
        
        [MyProgressHud showHUD:[NSString stringWithFormat:@"查到%d条数据",selectArray.count]];
        
        if (selectArray.count > 200) {
            [self delNoSave];
            [MyProgressHud showHUD:[NSString stringWithFormat:@"数据超过200条，删除数据"]];
        }
        
        return selectArray;
    }
    return nil;
}

@end
