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
    }else
    {
        DLog(@"数据库已存在");
    }
    
}

+ (void)saveDb:(QiuShi*)qs
{
    
    sqlite3_stmt *statement;
    
    
//    NSLog(@"%@",databasePath);
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &qiushiDB)==SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO QIUSHIS (qiushiid,imageurl,imagemidurl,tag,content,commentscount,upcount,downcount,anchor,fbtime) VALUES( \"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\")",qs.qiushiID,qs.imageURL,qs.imageMidURL,qs.tag,qs.content,qs.commentsCount,qs.upCount,qs.downCount,qs.anchor,qs.fbTime];
        
               
        DLog(@"%@",insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(qiushiDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement)==SQLITE_DONE) {
            NSLog(@"已存储到数据库");
            
        }
        else
        {
            NSLog(@"保存失败");
            
            NSLog(@"Error:%s",sqlite3_errmsg(qiushiDB));
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
// qs.qiushiID,qs.imageURL,qs.imageMidURL,qs.tag,qs.content,qs.commentsCount,qs.upCount,qs.downCount,qs.anchor,qs.fbTime
//
                
                QiuShi *qs = [[QiuShi alloc]init];
//                NSDictionary *qs = [[NSDictionary alloc]init];
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    
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

                    DLog(@"%@",qs.qiushiID);
                    DLog(@"%@",qs.imageURL);
                    DLog(@"%@",qs.imageMidURL);

                    DLog(@"%@",qs.tag);
                    DLog(@"%@",qs.content);
                    DLog(@"%d",qs.commentsCount);
                    DLog(@"%d",qs.upCount);
                    DLog(@"%d",qs.downCount);
                    DLog(@"%@",qs.anchor);
                    DLog(@"%@",qs.fbTime);
                    
                    
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
                
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(qiushiDB);
    }
    
    if (selectArray.count > 0) {
        
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
@end
