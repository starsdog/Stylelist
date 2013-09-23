//
//  StyleButton.m
//  Stylelist
//
//  Created by ling on 13/7/25.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import "StyleButton.h"

@implementation StyleButton
@synthesize DBid;
@synthesize imagepath;
@synthesize imageIndex;
@synthesize closeDetail;
@synthesize timelineDetail;
@synthesize imagename;
@synthesize imagenote;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setUserData:(int)ID :(NSString*)path :(int)index :(NSString*)note
{
    DBid=ID;
    imagepath=[NSString stringWithFormat:@"%@",path];
    imageIndex=index;
    imagenote=[NSString stringWithFormat:@"%@",note];
    //NSLog(@"setUserData:%@",imagenote);

}

- (void)setCloseDetail:(int)ID :(NSString*)path :(int)index :(NSString*)name :(NSArray*)ItemDetail
{
    DBid=ID;
    imagepath=[NSString stringWithFormat:@"%@",path];
    imageIndex=index;
    imagename=[NSString stringWithFormat:@"%@",name];
    closeDetail=[[NSMutableArray alloc]init];
    //0:title, 1:brand, 2:time 3:price 4:note
    for(int i=0;i<[ItemDetail count];i++)
    {
        NSString* item=[ItemDetail objectAtIndex:i];
        //NSLog(@"setCloseDetail=%@",item);
        [closeDetail addObject:item];
    }
}

- (void)setTimelineDetail:(int)ID :(NSString*)path :(int)index :(NSArray*)ItemDetail
{
    DBid=ID;
    imagepath=[NSString stringWithFormat:@"%@",path];
    imageIndex=index;
    
    //0:createtime, 1:FBID 2:fblike 3:commentnumber 4:note
    //timelineDetail=[[NSDictionary alloc]initWithObjectsAndKeys:ItemDetail[0],@"date",ItemDetail[1],@"FBID",ItemDetail[2],@"FBLike",ItemDetail[3],"CommentNum",ItemDetail[4],@"note",nil];
    
    for(int i=0;i<[ItemDetail count];i++)
    {
        NSString* item=[ItemDetail objectAtIndex:i];
        //NSLog(@"settimelineDetail=%@",item);
        [timelineDetail addObject:item];
    }
}

@end
