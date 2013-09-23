//
//  DBConnector.m
//
//
//  Created by Splashtop on 13/6/25.
//  Copyright (c) 2013年 Gust Studio. All rights reserved.
//

#import "DBConnector.h"

@implementation DBConnector


-(NSDictionary*) insertClosetRecordofImagePath: (NSString*)imagePath Price: (int)price Type:(int)type Title:(NSString*)title Note:(NSString*)note Brand:(NSString*)brand Size:(NSString*)size Closet:(int)closet timelineImagePath: (NSString*)timelineImagePath
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *Dictionary = [documentPath stringByAppendingPathComponent:@"database"];
    NSString *DBPath = [Dictionary stringByAppendingPathComponent:@"stiary.sqlite"];
    
    //check dbstatus
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSNumber *timelineIDobj=[[NSNumber alloc]initWithInt:-1];
    
    if([fileManager fileExistsAtPath:DBPath] == NO)
    {
        NSLog(@"database doesn't exist, copy database to document");
        
        NSString *defaultDBpath = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"stiary.sqlite"];
        //NSLog(@"%@", defaultDBpath);
        
        if([fileManager fileExistsAtPath:defaultDBpath] == NO)
        {
            NSLog(@"cant find default db! please debug resource file!");
            //return NO;
            NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys: timelineIDobj, @"timelineID",@"",@"date",nil];
            return dict;
        }
        else
        { 
            // create dictionary
            if (![fileManager createDirectoryAtPath:Dictionary withIntermediateDirectories:YES attributes:nil error:&error])
            {
                NSLog(@"Create directory %@ error: %@", Dictionary, error);
                //return NO;
                NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys: timelineIDobj, @"timelineID",@"",@"date",nil];
                return dict;

            }
            
            // copy db
            if(![fileManager copyItemAtPath:defaultDBpath toPath:DBPath error:&error])
            {
                NSLog(@"create db fail: %@", error);
                //return NO;
                NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys: timelineIDobj, @"timelineID",@"",@"date",nil];
                return dict;

            }
        }
    }
    
    //connect DB
    FMDatabase *db = [FMDatabase databaseWithPath:DBPath];
    
    if(![db open])
    {
        NSLog(@"open db fail");
        //return NO;
        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys: timelineIDobj, @"timelineID",@"",@"date",nil];
        return dict;

    }
    //NSLog(@"open db success");
    
    // now, try to update db
    [db setShouldCacheStatements:YES];
    
    //NSLog(@"Now insert to closet");
    
    //(char*)imagePath Price: (int)price Type:(int)type Title:(char*)title Note:(char*)note Brand:(char*)brand Size:(char*)size Closet:(int)closet
    NSString *sql = [[NSString alloc] initWithFormat:@"INSERT INTO closet(date, path, price, type, note, link, closet, size, brand, count, title) VALUES(datetime(), '%@', %i, %i, '%@', null, %i, '%@', '%@', 0, '%@')", imagePath, price, type, note, closet, size, brand, title];
    
    NSLog(@"SQL:%@",sql);
    
    if(![db executeUpdate:sql])
    {
        NSLog(@"Fail to insert to closet: %@", [db lastError]);
        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys: timelineIDobj, @"timelineID",@"",@"date",nil];
        return dict;
    }

    // now update timeline db
    //NSLog(@"Now insert to timeline");
    
    sql = [[NSString alloc] initWithFormat:@"INSERT INTO timeline(date, path, type, FBImageID, FBLikeCount, CommentCount, note) VALUES(datetime(), '%@', 0, '', 0, 0,'%@')", timelineImagePath, note];
    
    NSLog(@"SQL:%@",sql);
    
    if(![db executeUpdate:sql])
    {
        NSLog(@"Fail to insert to timeline: %@", [db lastError]);
        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys: timelineIDobj, @"timelineID",@"",@"date",nil];
        return dict;
    }
    
    // exame insert result
    //NSLog(@"Now query");
    
    sql=[NSString stringWithFormat:@"SELECT tmlid, date FROM timeline where path='%@'",timelineImagePath];
    int timelineID=-1;
    NSString *date=[[NSString alloc]init];
    
    FMResultSet *s = [db executeQuery:sql];
    while([s next])
    {
        timelineID=[s intForColumn:@"tmlid"];
        date=[NSString stringWithFormat:@"%@",[s stringForColumn:@"date"]];
    }
    [db close];
    
    timelineIDobj=[[NSNumber alloc]initWithInt:timelineID]; 
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys: timelineIDobj, @"timelineID",date,@"date",nil];
    return dict;
    /*
    FMResultSet *s = [db executeQuery:@"SELECT * FROM closet"];
    
    while([s next])
    {
        NSLog(@"%@, %i, %@",[s stringForColumn:@"title"], [s intForColumn:@"price"], [s stringForColumn:@"path"]);
    }

    s = [db executeQuery:@"SELECT * FROM timeline"];
    
    while([s next])
    {
        NSLog(@"%@",[s stringForColumn:@"path"]);
    }
          
    return YES;
    */ 
    
}

-(NSDictionary*) insertDressRecordofImagePath: (NSString*)timelineImagePath Type:(int)type Note:(NSString*)note Clothes:(NSString*) clothes
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *Dictionary = [documentPath stringByAppendingPathComponent:@"database"];
    NSString *DBPath = [Dictionary stringByAppendingPathComponent:@"stiary.sqlite"];
    
    //check dbstatus
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSNumber *timelineIDobj=[[NSNumber alloc]initWithInt:-1];
    
    if([fileManager fileExistsAtPath:DBPath] == NO)
    {
        NSLog(@"database doesn't exist, copy database to document");
        
        NSString *defaultDBpath = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"stiary.sqlite"];
        //NSLog(@"%@", defaultDBpath);
        
        if([fileManager fileExistsAtPath:defaultDBpath] == NO)
        {
            NSLog(@"cant find default db! please debug resource file!");
            NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys: timelineIDobj, @"timelineID",@"",@"date",nil];
            return dict;
        }
        else
        {
            // create dictionary
            if (![fileManager createDirectoryAtPath:Dictionary withIntermediateDirectories:YES attributes:nil error:&error])
            {
                NSLog(@"Create directory %@ error: %@", Dictionary, error);
                NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys: timelineIDobj, @"timelineID",@"",@"date",nil];
                return dict;
            }
            
            // copy db
            if(![fileManager copyItemAtPath:defaultDBpath toPath:DBPath error:&error])
            {
                NSLog(@"create db fail: %@", error);
                NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys: timelineIDobj, @"timelineID",@"",@"date",nil];
                return dict;
            }
        }
    }
    
    //connect DB
    FMDatabase *db = [FMDatabase databaseWithPath:DBPath];
    
    if(![db open])
    {
        NSLog(@"open db fail");
        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys: timelineIDobj, @"timelineID",@"",@"date",nil];
        return dict;
    }
    //NSLog(@"open db success");
    
    // now, try to update db
    [db setShouldCacheStatements:YES];
    
    //NSLog(@"Now insert");
    
    //(char*)imagePath Price: (int)price Type:(int)type Title:(char*)title Note:(char*)note Brand:(char*)brand Size:(char*)size Closet:(int)closet
    
    //NSLog(@"Now insert to timeline");
    
    //NSString *sql = [[NSString alloc] initWithFormat:@"INSERT INTO timeline(date, path, type, note) VALUES(datetime(), '%@', 1, note)", timelineImagePath];

    NSString *sql = [[NSString alloc] initWithFormat:@"INSERT INTO timeline(date, path, type, FBImageID, FBLikeCount, clothes, CommentCount, note) VALUES(datetime(), '%@', 0, '', 0, '%@',0,'%@')", timelineImagePath, clothes,note];
    
    NSLog(@"SQL:%@",sql);
    
    if(![db executeUpdate:sql])
    {
        NSLog(@"Fail to insert to timeline: %@", [db lastError]);
        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys: timelineIDobj, @"timelineID",@"",@"date",nil];
        return dict;
    }
    
    // exame insert result
    //NSLog(@"Now query");
    
    sql=[NSString stringWithFormat:@"SELECT tmlid, date FROM timeline WHERE path='%@'",timelineImagePath];
    
    int timelineID=-1;
    NSString *date=[[NSString alloc]init];
    
    FMResultSet *s = [db executeQuery:sql];
    while([s next])
    {
        timelineID=[s intForColumn:@"tmlid"];
        date=[NSString stringWithFormat:@"%@",[s stringForColumn:@"date"]];
    }
    [db close];

    timelineIDobj=[[NSNumber alloc]initWithInt:timelineID];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys: timelineIDobj, @"timelineID",date,@"date",nil];
    return dict;
}

-(BOOL) increaseClothCountofImageName: (NSString*)imageName
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *Dictionary = [documentPath stringByAppendingPathComponent:@"database"];
    NSString *DBPath = [Dictionary stringByAppendingPathComponent:@"stiary.sqlite"];
    
    //check dbstatus
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:DBPath] == NO)
    {
        NSLog(@"database doesn't exist, copy database to document");
        
        NSString *defaultDBpath = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"stiary.sqlite"];
        NSLog(@"%@", defaultDBpath);
        
        if([fileManager fileExistsAtPath:defaultDBpath] == NO)
        {
            NSLog(@"cant find default db! please debug resource file!");
            return NO;
        }
        else
        {
            // create dictionary
            if (![fileManager createDirectoryAtPath:Dictionary withIntermediateDirectories:YES attributes:nil error:&error])
            {
                NSLog(@"Create directory %@ error: %@", Dictionary, error);
                return NO;
            }
            
            // copy db
            if(![fileManager copyItemAtPath:defaultDBpath toPath:DBPath error:&error])
            {
                NSLog(@"create db fail: %@", error);
                return NO;
            }
        }
    }
    
    //connect DB
    FMDatabase *db = [FMDatabase databaseWithPath:DBPath];
    
    if(![db open])
    {
        NSLog(@"open db fail");
        return NO;
    }
    //NSLog(@"open db success");
    
    // now, try to update db
    [db setShouldCacheStatements:YES];
    
    //NSLog(@"Now update");
    
    //(char*)imagePath Price: (int)price Type:(int)type Title:(char*)title Note:(char*)note Brand:(char*)brand Size:(char*)size Closet:(int)closet
    
    //NSLog(@"Now insert to timeline");
    
    //NSString *sql = [[NSString alloc] initWithFormat:@"INSERT INTO timeline(date, path, type, note) VALUES(datetime(), '%@', 1, note)", timelineImagePath];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"UPDATE closet SET count = count + 1 WHERE path = '%@'", imageName];
    
    //NSLog(@"sql=%@",sql);
    
    //insert FB postid into timeline
    if(![db executeUpdate:sql])
    {
        NSLog(@"Fail to update : %@", [db lastError]);
        return NO;
    }
    
    
    if(![db executeUpdate:sql])
    {
        NSLog(@"Fail to insert to timeline: %@", [db lastError]);
        return NO;
    }
    
    return YES;
  
}

-(BOOL) queryTimelineofFMResult: (FMResultSet*)FMResult
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *Dictionary = [documentPath stringByAppendingPathComponent:@"database"];
    NSString *DBPath = [Dictionary stringByAppendingPathComponent:@"stiary.sqlite"];
    
    //check dbstatus
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:DBPath] == NO)
    {
        NSLog(@"DB doesn't exist");
        return NO;
    }
    else
    {
        //connect DB
        FMDatabase *db = [FMDatabase databaseWithPath:DBPath];
    
        if(![db open])
        {
            NSLog(@"open db fail");
            return NO;
        }
        //NSLog(@"open db success");
    
        // now, query db
        [db setShouldCacheStatements:YES];
        
        FMResult = [db executeQuery:@"SELECT * FROM timeline"];
        
        
        while([FMResult next])
        {
            NSLog(@"%@",[FMResult stringForColumn:@"path"]);
        }
        
        
        [db close];
        
        return YES;
    }
}

-(BOOL) insertFBImageIDtoTimeline:(int)timelineID :(NSString*)postID
{
 
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *Dictionary = [documentPath stringByAppendingPathComponent:@"database"];
    NSString *DBPath = [Dictionary stringByAppendingPathComponent:@"stiary.sqlite"];
    
    //check dbstatus
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:DBPath] == NO)
    {
        NSLog(@"database doesn't exist, copy database to document");
        
        NSString *defaultDBpath = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"stiary.sqlite"];
        //NSLog(@"%@", defaultDBpath);
        
        if([fileManager fileExistsAtPath:defaultDBpath] == NO)
        {
            NSLog(@"cant find default db! please debug resource file!");
            return NO;
        }
        else
        {
            // create dictionary
            if (![fileManager createDirectoryAtPath:Dictionary withIntermediateDirectories:YES attributes:nil error:&error])
            {
                NSLog(@"Create directory %@ error: %@", Dictionary, error);
                return NO;
            }
            
            // copy db
            if(![fileManager copyItemAtPath:defaultDBpath toPath:DBPath error:&error])
            {
                NSLog(@"create db fail: %@", error);
                return NO;
            }
        }
    }
    
    //connect DB
    FMDatabase *db = [FMDatabase databaseWithPath:DBPath];
    
    if(![db open])
    {
        NSLog(@"open db fail");
        return NO;
    }
    //NSLog(@"open db success");
    
    // now, try to update db
    [db setShouldCacheStatements:YES];
    
    NSString *sql=[[NSString alloc]init];
    /*
    sql=[NSString stringWithFormat:@"SELECT tmlid FROM timeline where path = '%@'", path];
    NSLog(@"sql=%@",sql);
    
    //query timelineID from path
    FMResultSet *FMResult = [db executeQuery:sql];
    int timelineID=-1;
    
    while([FMResult next])
    {
        timelineID=[FMResult intForColumn:@"tmlid"];
        NSLog(@"%d",timelineID);
    }

    if(timelineID==-1)
        return NO;
    */
    sql=[NSString stringWithFormat:@"Update timeline Set FBImageID='%@' where tmlid=%d", postID, timelineID];
    //NSLog(@"sql=%@",sql);
    
    //insert FB postid into timeline
    if(![db executeUpdate:sql])
    {
        NSLog(@"Fail to insert : %@", [db lastError]);
        return NO;
    }
    
    // exame insert result
    //NSLog(@"Now query");
    /*
    sql=[NSString stringWithFormat:@"SELECT FBImageID FROM timeline where tmlid=%d", timelineID];
    NSLog(@"sql=%@",sql);
    FMResultSet *FMResult = [db executeQuery:sql];
    
    while([FMResult next])
    {
        NSLog(@"%d id=%@",timelineID, [FMResult stringForColumn:@"FBImageID"]);
    }
    */
    [db close];
    
    return YES;

}

-(BOOL) insertFBLiketoTimeline:(int)timelineID :(int)FBLike
{
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *Dictionary = [documentPath stringByAppendingPathComponent:@"database"];
    NSString *DBPath = [Dictionary stringByAppendingPathComponent:@"stiary.sqlite"];
    
    //check dbstatus
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:DBPath] == NO)
    {
        NSLog(@"database doesn't exist, copy database to document");
        
        NSString *defaultDBpath = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"stiary.sqlite"];
        //NSLog(@"%@", defaultDBpath);
        
        if([fileManager fileExistsAtPath:defaultDBpath] == NO)
        {
            NSLog(@"cant find default db! please debug resource file!");
            return NO;
        }
        else
        {
            // create dictionary
            if (![fileManager createDirectoryAtPath:Dictionary withIntermediateDirectories:YES attributes:nil error:&error])
            {
                NSLog(@"Create directory %@ error: %@", Dictionary, error);
                return NO;
            }
            
            // copy db
            if(![fileManager copyItemAtPath:defaultDBpath toPath:DBPath error:&error])
            {
                NSLog(@"create db fail: %@", error);
                return NO;
            }
        }
    }
    
    //connect DB
    FMDatabase *db = [FMDatabase databaseWithPath:DBPath];
    
    if(![db open])
    {
        NSLog(@"open db fail");
        return NO;
    }
    //NSLog(@"open db success");
    
    // now, try to update db
    [db setShouldCacheStatements:YES];
    
    NSString *sql=[[NSString alloc]init];
    /*
     sql=[NSString stringWithFormat:@"SELECT tmlid FROM timeline where path = '%@'", path];
     NSLog(@"sql=%@",sql);
     
     //query timelineID from path
     FMResultSet *FMResult = [db executeQuery:sql];
     int timelineID=-1;
     
     while([FMResult next])
     {
     timelineID=[FMResult intForColumn:@"tmlid"];
     NSLog(@"%d",timelineID);
     }
     
     if(timelineID==-1)
     return NO;
     */
    sql=[NSString stringWithFormat:@"Update timeline Set FBLikeCount=%d where tmlid=%d", FBLike, timelineID];
    //NSLog(@"sql=%@",sql);
    
    //insert FB postid into timeline
    if(![db executeUpdate:sql])
    {
        NSLog(@"Fail to insert : %@", [db lastError]);
        return NO;
    }
    
    // exame insert result
    //NSLog(@"Now query");
    /*
    sql=[NSString stringWithFormat:@"SELECT FBLikeCount FROM timeline where tmlid=%d", timelineID];
    NSLog(@"sql=%@",sql);
    FMResultSet *FMResult = [db executeQuery:sql];
    
    while([FMResult next])
    {
        NSLog(@"id=%d count=%d",timelineID, [FMResult intForColumn:@"FBLikeCount"]);
    }
    */
    [db close];
    
    return YES;
    
}

-(BOOL) updateClosetInfo :(int)closetID :(NSString*)detailTitle :(NSString*)detailBrand :(NSNumber*)detailPrice :(NSString*)detailNote
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *Dictionary = [documentPath stringByAppendingPathComponent:@"database"];
    NSString *DBPath = [Dictionary stringByAppendingPathComponent:@"stiary.sqlite"];
    
    //check dbstatus
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:DBPath] == NO)
    {
        NSLog(@"database doesn't exist, copy database to document");
        
        NSString *defaultDBpath = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"stiary.sqlite"];
        //NSLog(@"%@", defaultDBpath);
        
        if([fileManager fileExistsAtPath:defaultDBpath] == NO)
        {
            NSLog(@"cant find default db! please debug resource file!");
            return NO;
        }
        else
        {
            // create dictionary
            if (![fileManager createDirectoryAtPath:Dictionary withIntermediateDirectories:YES attributes:nil error:&error])
            {
                NSLog(@"Create directory %@ error: %@", Dictionary, error);
                return NO;
            }
            
            // copy db
            if(![fileManager copyItemAtPath:defaultDBpath toPath:DBPath error:&error])
            {
                NSLog(@"create db fail: %@", error);
                return NO;
            }
        }
    }
    
    //connect DB
    FMDatabase *db = [FMDatabase databaseWithPath:DBPath];
    
    if(![db open])
    {
        NSLog(@"open db fail");
        return NO;
    }
    //NSLog(@"open db success");
    
    // now, try to update db
    [db setShouldCacheStatements:YES];
    NSString *sql=[[NSString alloc]init];
    sql=[NSString stringWithFormat:@"Update closet Set title='%@', brand='%@', price=%d, note='%@' where cltid=%d", detailTitle, detailBrand, [detailPrice intValue], detailNote, closetID];
    //NSLog(@"sql=%@",sql);
    
    //insert FB postid into timeline
    if(![db executeUpdate:sql])
    {
        NSLog(@"Fail to insert : %@", [db lastError]);
        return NO;
    }
    
    // exame insert result
    //NSLog(@"Now query");
    /*
    sql=[NSString stringWithFormat:@"SELECT title FROM closet where cltid=%d", closetID];
    NSLog(@"sql=%@",sql);
    FMResultSet *FMResult = [db executeQuery:sql];
    
    
    while([FMResult next])
    {
        NSLog(@"id=%d title=%@",closetID, [FMResult stringForColumn:@"title"]);
    }
    */ 
    
    [db close];
    
    return YES;


}


-(BOOL) insertCommentCounttoTimeline :(int)timelineID :(int)commentNum
{
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *Dictionary = [documentPath stringByAppendingPathComponent:@"database"];
    NSString *DBPath = [Dictionary stringByAppendingPathComponent:@"stiary.sqlite"];
    
    //check dbstatus
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:DBPath] == NO)
    {
        NSLog(@"database doesn't exist, copy database to document");
        
        NSString *defaultDBpath = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"stiary.sqlite"];
        //NSLog(@"%@", defaultDBpath);
        
        if([fileManager fileExistsAtPath:defaultDBpath] == NO)
        {
            NSLog(@"cant find default db! please debug resource file!");
            return NO;
        }
        else
        {
            // create dictionary
            if (![fileManager createDirectoryAtPath:Dictionary withIntermediateDirectories:YES attributes:nil error:&error])
            {
                NSLog(@"Create directory %@ error: %@", Dictionary, error);
                return NO;
            }
            
            // copy db
            if(![fileManager copyItemAtPath:defaultDBpath toPath:DBPath error:&error])
            {
                NSLog(@"create db fail: %@", error);
                return NO;
            }
        }
    }
    
    //connect DB
    FMDatabase *db = [FMDatabase databaseWithPath:DBPath];
    
    if(![db open])
    {
        NSLog(@"open db fail");
        return NO;
    }
    //NSLog(@"open db success");
    
    // now, try to update db
    [db setShouldCacheStatements:YES];
    
    NSString *sql=[[NSString alloc]init];
    sql=[NSString stringWithFormat:@"Update timeline Set CommentCount=%d where tmlid=%d", commentNum, timelineID];
    //NSLog(@"sql=%@",sql);
    
    //insert FB postid into timeline
    if(![db executeUpdate:sql])
    {
        NSLog(@"Fail to insert : %@", [db lastError]);
        return NO;
    }
    
    // exame insert result
    //NSLog(@"Now query");
    /*
    sql=[NSString stringWithFormat:@"SELECT CommentCount FROM timeline where tmlid=%d", timelineID];
    NSLog(@"sql=%@",sql);
    FMResultSet *FMResult = [db executeQuery:sql];
    
    
    while([FMResult next])
    {
        NSLog(@"id=%d count=%d",timelineID, [FMResult intForColumn:@"CommentCount"]);
    }*/
    
    [db close];
    
    return YES;
    
}


@end
