//
//  StyleButton.h
//  Stylelist
//
//  Created by ling on 13/7/25.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StyleButton : UIButton
{
    int DBid;
    NSString* imagepath;
    int imageIndex;
    NSString* imagename;
    NSString* imagenote;

    NSMutableArray* closeDetail;
    NSMutableArray* timelineDetail;
}

@property int DBid;
@property NSString* imagepath;
@property NSString* imagename;
@property int imageIndex;
@property NSString* imagenote;
@property NSMutableArray* closeDetail;
@property NSMutableArray* timelineDetail;

- (void)setUserData:(int)ID :(NSString*)path :(int)index :(NSString*)note;
- (void)setCloseDetail:(int)ID :(NSString*)path :(int)index :(NSString*)name :(NSArray*)ItemDetail;
- (void)setTimelineDetail:(int)ID :(NSString*)path :(int)index :(NSArray*)ItemDetail;

@end
