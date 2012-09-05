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
                
                
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSLog(@"已查到结果");
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
        
        
        DLog(@"查到%d条数据",selectArray.count);

               
        return selectArray;
    }
    return nil;
}


+ (BOOL)queryDbById:(NSString*)qiushiid
{
    BOOL isExist = NO;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT  * from QIUSHIS where QIUSHIID='%@'",qiushiid];
        
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(qiushiDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                
                DLog(@"已查到结果");
                
                isExist = YES;
                               
            }
            else {
                DLog(@"查询出错:%s",sqlite3_errmsg(qiushiDB));

                isExist = NO;
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(qiushiDB);
    }
    

    return isExist;
}




//===========update data=================
+ (BOOL) updateDataIsFavourite:(NSString *)qiushiid isFavourite:(NSString*)isSave
{
    
    BOOL updateOK = NO;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &qiushiDB) == SQLITE_OK)
    {
        NSString *updateSqlStr = [NSString stringWithFormat:@"UPDATE qiushis SET issave=? WHERE qiushiid=='%@'",qiushiid];
        
        
        const char *query_stmt = [updateSqlStr UTF8String];
        if (sqlite3_prepare_v2(qiushiDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_text(statement, 1, [isSave UTF8String], -1, SQLITE_TRANSIENT);
            
            
            int execUpdateSqlOk = sqlite3_step(statement);
            sqlite3_finalize(statement);
            
            if (execUpdateSqlOk == SQLITE_ERROR) {
                DLog(@"更新出错:%s",sqlite3_errmsg(qiushiDB));
                sqlite3_close(qiushiDB);
                updateOK = NO;
            }else{
                DLog(@"已更新");
                updateOK = YES;
            }
            
            
        }else{
            updateOK = NO;
             DLog(@"更新出错:%s",sqlite3_errmsg(qiushiDB));
        }
        
        sqlite3_close(qiushiDB);
    }

    return updateOK;


}

@end


//iphone  sqlite3 数据的增添，删除，查找，修改
//
//
//
//希望对大家有用，学习了就帮我顶顶啊
//比较充忙没有对每行代码写注释
////  Created by hhy on 12-4-18.
////  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
////
//
//
//
//
//#import "hhySqlite.h"
//
//
//@implementation hhySqlite
//
//
//@synthesize hhySqlite;
//
//
////=========database file path==================
//- (NSString *)DatabaseFilePath{
//    
//    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"hhyDB.sql"];
//    
//    //    NSBundle *boudle = [NSBundle mainBundle];
//    //    NSString *databasePath = [boudle pathForResource:@"hhyDB" ofType:@"sql"];
//    
//    
//    return databasePath;
//}
//
//
////=========open database========================
//- (BOOL) openDatabase{
//    NSString *DBPath = [self DatabaseFilePath];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL isFile = [fileManager fileExistsAtPath:DBPath];
//    //the databse is existed=======
//    if (isFile) {
//        printf("----------the databse is existed!-------------\r\n");
//        if (sqlite3_open([DBPath UTF8String], & hhySqlite) != SQLITE_OK) {
//            sqlite3_close(hhySqlite);
//            printf("----------the databse is open fail!-------------\r\n");
//            return NO;
//        }
//        else{
//            printf("----------the databse is open OK!-------------\r\n");
//            return YES;
//            
//            
//        }
//    }
//    //the database is not exited====
//    else{
//        printf("----------the databse is not existed!-------------\r\n");
//        
//        
//        if (sqlite3_open([DBPath UTF8String], &hhySqlite) == SQLITE_OK) {
//            printf("----------the databse is open OK!-------------\r\n");
//            return YES;
//        }
//        else{
//            printf("----------the databse is open fail!-------------\r\n");
//            sqlite3_close(hhySqlite);
//            return NO;
//        }
//    }
//    return NO;
//}
//
//
////========create tables=================
//- (BOOL) createTable:(sqlite3 *)nationalDB{
//    char *Infor_sql = "CREATE TABLE IF NOT EXISTS t_Infor(ID INTEGER PRIMARY KEY AUTOINCREMENT,UUIDName text,UUID text,deviceName text, peripheralInfo text)";
//    
//    sqlite3_stmt *statement;
//    NSInteger SqlOK = sqlite3_prepare_v2(hhySqlite, Infor_sql, -1, &statement, nil);
//    
//    if (SqlOK != SQLITE_OK) {
//        printf("----------create table sql is error!-------------\r\n");
//        return NO;
//    }
//    
//    int sqlCorrect = sqlite3_step(statement);
//    sqlite3_finalize(statement);
//    
//    if (sqlCorrect != SQLITE_DONE) {
//        printf("----------failed to create table!-------------\r\n");
//        return NO;
//    }
//    printf("----------create table t_Infor is OK!-------------\r\n");
//    return YES;
//}
//
//
////=========insert some data=============
//- (BOOL) insertData:(NSString *)tableName UUIDName:(NSString *)uuidName UUID:(NSString *)uuid DeviceName:(NSString *)deviceName PeripheralInfo:(NSString *)peripheralInfo {
//    if ([self openDatabase]) {
//        
//        sqlite3_stmt *statement;
//        NSString *insertSqlStr = [NSString stringWithFormat:@"INSERT INTO '%@'(UUIDName,UUID,deviceName,peripheralInfo) VALUES (?,?,?,?)",tableName];
//        c*****t char *insertSql = [insertSqlStr UTF8String];
//        int insertSqlOK = sqlite3_prepare_v2(hhySqlite, insertSql, -1, &statement, nil);
//        if (insertSqlOK != SQLITE_OK) {
//            printf("---------- insert sql is error!-------------\r\n");
//            sqlite3_close(hhySqlite);
//            return NO;
//        }
//        
//        sqlite3_bind_text(statement, 1, [uuidName       UTF8String], -1, nil);
//        sqlite3_bind_text(statement, 2, [uuid           UTF8String], -1, nil);
//        sqlite3_bind_text(statement, 3, [deviceName     UTF8String], -1, nil);
//        sqlite3_bind_text(statement, 4, [peripheralInfo UTF8String], -1, nil);
//        
//        int execInsertSqlOK = sqlite3_step(statement);
//        sqlite3_finalize(statement);
//        
//        if (execInsertSqlOK ==SQLITE_ERROR) {
//            printf("----------failed to insert data into t_Infor Database!-------------\r\n");
//            sqlite3_close(hhySqlite);
//            return  NO;
//        }
//    }
//    printf("----------insert data into t_Infor Database is OK!-------------\r\n");
//    sqlite3_close(hhySqlite);
//    return YES;
//}
//
//
////===========update data=================
//- (BOOL) updateData:(NSString *)tableName UUIDName:(NSString *)uuidName UUID:(NSString *)uuid DeviceName:(NSString *)deviceName PeripheralInfo:(NSString *)peripheralInfo {
//
//    
//    if ([self openDatabase]) {
//        sqlite3_stmt *statement = nil;
//        NSString *updateSqlStr = [NSString stringWithFormat:@"UPDATE '%@' SET uuidName=?,deviceName=?,peripheralInfo=? WHERE uuid=='%@'",tableName,uuid];
//        c*****t char *updateSql  = [updateSqlStr UTF8String];
//        int updateSqlOK = sqlite3_prepare_v2(hhySqlite, updateSql, -1, &statement, nil);
//        
//        if (updateSqlOK != SQLITE_OK) {
//            printf("---------- update sql is error!-------------\r\n");
//            sqlite3_close(hhySqlite);
//            return NO;
//        }
//        
//        sqlite3_bind_text(statement, 1, [uuidName       UTF8String], -1, SQLITE_TRANSIENT);
//        sqlite3_bind_text(statement, 2, [deviceName     UTF8String], -1, SQLITE_TRANSIENT);
//        sqlite3_bind_text(statement, 3, [peripheralInfo UTF8String], -1, SQLITE_TRANSIENT);
//        
//        int execUpdateSqlOk = sqlite3_step(statement);
//        sqlite3_finalize(statement);
//        
//        if (execUpdateSqlOk == SQLITE_ERROR) {
//            sqlite3_close(hhySqlite);
//            return NO;
//        }
//        
//    }
//    printf("----------update data  t_Infor Database is OK!-------------\r\n");
//    sqlite3_close(hhySqlite);
//    return YES;
//}
//
//
////===========delete data=================
//- (BOOL) deleteData:(NSString *)tableName UUID:(NSString *)uuid{
//    if ([self openDatabase]) {
//        sqlite3_stmt *statement = nil;
//        NSString *deleteSqlStr = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE  uuid=?",tableName];
//        c*****t char *deleteSql  = [deleteSqlStr UTF8String];
//        
//        int deleteSqlOk = sqlite3_prepare_v2(hhySqlite, deleteSql, -1, &statement, nil);
//        if (deleteSqlOk != SQLITE_OK) {
//            printf("---------- delete sql is error!-------------\r\n");
//            sqlite3_close(hhySqlite);
//            return NO;
//        }
//        
//        sqlite3_bind_text(statement, 1, [uuid UTF8String], -1, SQLITE_TRANSIENT);
//        
//        int execDeleteSqlOk = sqlite3_step(statement);
//        sqlite3_finalize(statement);
//        
//        if (execDeleteSqlOk == SQLITE_ERROR) {
//            sqlite3_close(hhySqlite);
//            return NO;
//        }
//        
//    }
//    printf("----------delete data t_Infor Database is OK!-------------\r\n");
//    sqlite3_close(hhySqlite);
//    return YES;
//    
//    
//}
//
//
////===========select uuid=================
//- (NSString *)selectUUIDData:(NSString *)tableName{
//    return nil;
//}
//
//
////===========select data==================
//- (NSMutableArray *)selectAllData:(NSString *)tableName{
//    NSMutableArray *selectArray    = [NSMutableArray arrayWithCapacity:10];
//    NSMutableDictionary *selectDic = [[NSMutableDictionary alloc] init];
//    
//    
//    NSString *selectSqlStr = [NSString stringWithFormat:@"SELECT * from '%@'",tableName];
//    
//    if ([self openDatabase]) {
//        
//        sqlite3_stmt *statement = nil;
//        c*****t char *selectSql = [selectSqlStr UTF8String];
//        if (sqlite3_prepare_v2(hhySqlite, selectSql, -1, &statement, nil) != SQLITE_OK) {
//            printf("----------select selectAllData sql is error!-------------\r\n");
//            return NO;
//        }
//        else{
//            while (sqlite3_step(statement) == SQLITE_ROW) {
//                char *str_uuidName       = (char *)sqlite3_column_text(statement, 1);
//                char *str_uuid           = (char *)sqlite3_column_text(statement, 2);
//                char *str_deviceName     = (char *)sqlite3_column_text(statement, 3);
//                char *str_peripheralInfo = (char *)sqlite3_column_text(statement, 4);
//                
//                NSString *uuidNameStr       = [[NSString alloc] initWithUTF8String: str_uuidName];
//                NSString *uuidStr           = [[NSString alloc] initWithUTF8String: str_uuid];
//                NSString *deviceNameStr     = [[NSString alloc] initWithUTF8String: str_deviceName];
//                NSString *peripheralInfoStr = [[NSString alloc] initWithUTF8String: str_peripheralInfo];
//                
//                [selectDic setObject:uuidNameStr       forKey:@"uuidName"];
//                [selectDic setObject:uuidStr           forKey:@"uuid"];
//                [selectDic setObject:deviceNameStr     forKey:@"deviceName"];
//                [selectDic setObject:peripheralInfoStr forKey:@"peripheralInfo"];
//                
//                [selectArray addObject:selectDic];
//                
//                NSLog(@"------------uuidNameStr = %@",uuidNameStr);
//                NSLog(@"----------------uuidStr = %@",uuidStr);
//                NSLog(@"----------deviceNameStr = %@",deviceNameStr);
//                NSLog(@"------peripheralInfoStr = %@",peripheralInfoStr);
//                printf("\r\n");
//            }
//        }
//        sqlite3_finalize(statement);
//        sqlite3_close(hhySqlite);
//    }
//    return [selectArray retain];
//}
//
//
//@end
//
//

