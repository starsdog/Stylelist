//
//  timelineTableViewCell.m
//  Stylelist
//
//  Created by Splashtop on 13/9/3.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import "timelineTableViewCell.h"
#define iphoneImageHeight 420
#define iphoneIamgeWideth 320

@implementation timelineTableViewCell
@synthesize clothImage, button, likeView, likelabel, profileView, commentView,commentlabel, timelabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.timelineCellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
        self.timelineCellView.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:231.0/255.0 blue:172.0/255.0 alpha:1.0];;
        
        //StyleButton tag=2: fbButton, tag=3:clothImageButton
        //Label tag=1:comment, tag=2:FBlike, tag=3:time
        //ImageView tag=1:comment, tag=2:FBlike, tag=4:profileImage

        int cellheight=iphoneImageHeight-15;
        int cellwidth=iphoneIamgeWideth-30;
        
        cellview=[[UIView alloc] initWithFrame:CGRectMake(15, 5, cellwidth, cellheight)];
        [cellview setBackgroundColor:[UIColor whiteColor]];
        
        clothImage=[StyleButton buttonWithType:UIButtonTypeCustom];
        clothImage.frame = CGRectMake(25, 70, 240, 320);
        clothImage.tag=2;

        button = [StyleButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(240, 30, 30, 30);
        button.tag=3;

        likeView=[[UIImageView alloc]initWithFrame:CGRectMake(190, 30, 30, 30)];
        likeView.tag=2;
        likelabel=[[UILabel alloc] initWithFrame:CGRectMake(225, 45, 10, 10)];
        [likelabel setFont:[UIFont systemFontOfSize:12]];
        likelabel.tag=2;
        
        profileView=[[UIImageView alloc]initWithFrame:CGRectMake(25,10, 50, 50)];
        profileView.contentMode=UIViewContentModeScaleAspectFit;
        profileView.tag=4;
        
        timelabel=[[UILabel alloc] initWithFrame:CGRectMake(85, 5, 150, 20)];
        [timelabel setFont:[UIFont systemFontOfSize:12]];
        timelabel.tag=3;

        commentView=[[UIImageView alloc]initWithFrame:CGRectMake(140, 30, 30, 30)];
        commentView.tag=1;
        commentlabel=[[UILabel alloc] initWithFrame:CGRectMake(175, 45, 10, 10)];
        [commentlabel setFont:[UIFont systemFontOfSize:12]];
        commentlabel.tag=1;

        [cellview addSubview:button];
        [cellview addSubview:likeView];
        [cellview addSubview:likelabel];
        [cellview addSubview:commentView];
        [cellview addSubview:commentlabel];
        [cellview addSubview:clothImage];
        [cellview addSubview:profileView];
        [cellview addSubview:timelabel];
        [cellview setUserInteractionEnabled:YES];

        [self.timelineCellView addSubview:cellview];
        [self addSubview:self.timelineCellView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
