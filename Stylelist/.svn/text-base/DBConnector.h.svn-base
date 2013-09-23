//
//  WP02DBConnector.h
//  World Puzzle 02
//
//  Created by Splashtop on 13/6/25.
//  Copyright (c) 2013年 Gust Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DBConnector : NSObject

-(NSDictionary*) insertClosetRecordofImagePath: (NSString*)imagePath Price: (int)price Type:(int)type Title:(NSString*)title Note:(NSString*)note Brand:(NSString*)brand Size:(NSString*)size Closet:(int)closet timelineImagePath: (NSString*)timelineImagePath;

-(NSDictionary*) insertDressRecordofImagePath: (NSString*)timelineImagePath Type:(int)type Note:(NSString*)note Clothes:(NSString*) clothes;

-(BOOL) increaseClothCountofImageName: (NSString*)imageName;
 
-(BOOL) queryTimelineofFMResult: (FMResultSet*)FMResult;

-(BOOL) insertFBImageIDtoTimeline:(int)timelineID :(NSString*)postID;

-(BOOL) insertFBLiketoTimeline:(int)timelineID :(int)FBLike;

-(BOOL) updateClosetInfo :(int)closetID :(NSString*)detailTitle :(NSString*)detailBrand :(NSNumber*)detailPrice :(NSString*)detailNote;

-(BOOL) insertCommentCounttoTimeline :(int)timelineID :(int)commentNum;

@end
