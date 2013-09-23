//
//  StyleDetailViewController.m
//  Stylelist
//
//  Created by ling on 13/6/25.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import "StyleDetailViewController.h"
#import "StyleButton.h"
#import "StyleAppDelegate.h"

#define iphoneImageHeight 420
#define iphoneIamgeWidth 320


@interface StyleDetailViewController ()
{
    StyleAppDelegate *appDelegate;
    NSString *timelineDirectory;
    NSString *userProfile;
    BOOL isFBConnect;
    float commentY;
    BOOL isProfileExist;
    int commentNum;
    int fbLikeNum;
    NSString *fbID;
    FacebookHelper *FBController;
}

@end

@implementation StyleDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    /*
    NSLog(@"DetailView, imagepath=%@",self.DetailModel[1]);
    NSLog(@"DetailView, imageindex=%@",self.DetailModel[2]);
    NSLog(@"DetailView, date=%@",self.DetailModel[3]);
    NSLog(@"DetailView, FBID=%@",self.DetailModel[4]);
    NSLog(@"DetailView, FBlike=%@",self.DetailModel[5]);
    NSLog(@"DetailView, comment=%@",self.DetailModel[6]);
    NSLog(@"DetailView, note=%@",self.DetailModel[7]);
    */
    
    appDelegate = (StyleAppDelegate *)[[UIApplication sharedApplication] delegate];
    //appDelegate.FBController.delegate=self;
    //[appDelegate.FBController initcontroller];
    FBController=[[FacebookHelper alloc]init];
    FBController.delegate=self;
    //[FBController initcontroller];
    //isFBConnect=[FBController checkIsConnected];
   
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    timelineDirectory = [documentPath stringByAppendingPathComponent:@"timeline"];
    userProfile = [timelineDirectory stringByAppendingPathComponent:@"profile.png"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
       
    if([fileManager fileExistsAtPath:userProfile] == NO)
        isProfileExist=NO;
    else
        isProfileExist=YES;

    //for update cell usage
    commentNum=0;
    fbID=[NSString stringWithFormat:@""];
  
    [self drawDetail];

}

-(void)viewDidAppear:(BOOL)animated
{
    [FBController initcontroller];
    BOOL originStatus=isFBConnect;
    isFBConnect=[FBController checkIsConnected];
    NSLog(@"Timeline Detail Page: viewDidAppear, check is connected %d",(int)isFBConnect);
    if(originStatus!=isFBConnect)
    {
        NSLog(@"Timeline Detail Page: viewDidAppear, need to update");
        [self SetLoginButton:isFBConnect];
    }

}

- (void)drawDetail
{
      
    UIView* cellview=[[UIView alloc] init];
    UIImageView *clothImageView=[[UIImageView alloc]init];
    StyleButton *button = [StyleButton buttonWithType:UIButtonTypeCustom];
    UIImageView* likeView=[[UIImageView alloc]init];
    UILabel* likelabel=[[UILabel alloc] init];
    UIImageView* profileView=[[UIImageView alloc]init];
    UILabel* timelabel=[[UILabel alloc] init];
    UIImageView* commentView=[[UIImageView alloc]init];
    UILabel* commentlabel=[[UILabel alloc] init];
    
    int cellheight=iphoneImageHeight-15;
    int cellwidth=iphoneIamgeWidth-30;
    cellview.frame=CGRectMake(15, 5, cellwidth, cellheight);
    
    profileView.frame=CGRectMake(25,10, 50, 50);
       
    int timelineID=[self.DetailModel[0] intValue];
    int index=[self.DetailModel[2] intValue];
    
    NSString *closetPath = self.DetailModel[1];
    NSString *date=self.DetailModel[3];
    NSString *fbImageID = self.DetailModel[4];
    NSString *note=[NSString stringWithFormat:@"%@",self.DetailModel[7]];
       
    int fbLike =[self.DetailModel[5] intValue];
    int commentLike =[self.DetailModel[6] intValue];
    NSString* label=[[NSString alloc]init];
    
    //query FB like
    /*
    if ([fbImageID length]!= 0 && isFBConnect)
    {
       [FBController QueryImageComment:fbImageID:timelineID:index];
            
        NSLog(@"Timeline Detail page: query comment of timelineID=%d", timelineID);
    }*/
    
    commentView.frame=CGRectMake(140, 30, 30, 30);
    commentView.image=[UIImage imageNamed:@"timeline-reply.png"];
    commentlabel.frame=CGRectMake(175, 45, 10, 10);
    [commentlabel setFont:[UIFont systemFontOfSize:12]];
    label=[NSString stringWithFormat:@"%d", commentLike];
    [commentlabel setText:label];
    commentlabel.tag=1;
    commentView.tag=1;
    
    likeView.frame=CGRectMake(190, 30, 30, 30);
    likeView.image=[UIImage imageNamed:@"timeline-like.png"];
    likelabel.frame=CGRectMake(225, 45, 10, 10);
    [likelabel setFont:[UIFont systemFontOfSize:12]];
    label=[NSString stringWithFormat:@"%d", fbLike];
    [likelabel setText:label];
    likelabel.tag=2;
    likeView.tag=2;
    
    if ([fbImageID length]!= 0 ) //has comment and like icon
    {
    
        button.frame=CGRectMake(240, 30, 30, 30);
        [button setBackgroundImage:[UIImage imageNamed:@"timeline-fb-shared.png"] forState:UIControlStateNormal];
        [button setUserData:timelineID:closetPath:index:note];
        [button addTarget:self action:@selector(ShareClick:) forControlEvents:UIControlEventTouchDown];
    }
    else //has share button
    {
        commentView.hidden=YES;
        commentlabel.hidden=YES;
        likeView.hidden=YES;
        likelabel.hidden=YES;
        button.frame=CGRectMake(240, 30, 30, 30);
        [button setBackgroundImage:[UIImage imageNamed:@"timeline-fb-unshared.png"] forState:UIControlStateNormal];
        [button setUserData:timelineID:closetPath:index:note];
        [button addTarget:self action:@selector(ShareClick:) forControlEvents:UIControlEventTouchDown];
        button.tag=2;
    }
    
    timelabel.frame=CGRectMake(85, 5, 150, 20);
    [timelabel setFont:[UIFont systemFontOfSize:12]];
    [timelabel setText:date];
    timelabel.tag=3;
    
    [cellview setBackgroundColor:[UIColor whiteColor]];
    
    //noteview
    UITextView *noteView=[[UITextView alloc]init];
    float noteY=commentView.frame.origin.y+commentView.frame.size.height+5;
    //NSLog(@"titlefield height %f, origin.y=%f, noteY=%f",self.titleField.frame.size.height, self.detailView.frame.origin.y, noteY);
    noteView.frame=CGRectMake(5, noteY, cellwidth, 5);
    [noteView setBackgroundColor:[UIColor clearColor]];
    noteView.text=@"";
    if ([self.DetailModel[7] length]!=0)
    {
        [noteView setText:self.DetailModel[7]];
    }
    [noteView setEditable:NO];
    [noteView sizeToFit];
    [noteView setFont:[UIFont systemFontOfSize:14]];
    
    [cellview addSubview:noteView];
    
    CGRect newframe =noteView.frame;
    newframe.size.height=noteView.contentSize.height;
    //NSLog(@"note content size=%f",noteView.contentSize.height);
    [noteView setFrame:newframe];
    //NSLog(@"note frame height=%f",noteView.frame.size.height);
    
    noteY=noteView.frame.origin.y+noteView.frame.size.height+5;
    clothImageView.frame = CGRectMake(25, noteY, 240, 320);
    clothImageView.image=[UIImage imageWithContentsOfFile:closetPath];
    commentY=clothImageView.frame.origin.y+clothImageView.frame.size.height+10;
    //NSLog(@"commentY=%f",commentY);
    
    newframe=cellview.frame;
    newframe.size.height=commentY;
    cellview.frame=newframe;
    cellview.tag=0;
    
    if(isProfileExist)
        profileView.image=[UIImage imageWithContentsOfFile:userProfile];
    else
        profileView.image=[UIImage imageNamed:@"defaultprofile.png"];
    profileView.contentMode=UIViewContentModeScaleAspectFit;

    [cellview addSubview:button];
    [cellview addSubview:likeView];
    [cellview addSubview:likelabel];
    [cellview addSubview:commentView];
    [cellview addSubview:commentlabel];
    [cellview addSubview:clothImageView];
    [cellview addSubview:timelabel];
    [cellview addSubview:profileView];
    [cellview setUserInteractionEnabled:YES];
        
    [self.detailScrollView addSubview:cellview];
    
    /*
    UIView* backview=[[UIView alloc] init];
    backview.frame=CGRectMake(0, 0, iphoneIamgeWidth, 40);
    [backview setBackgroundColor:[UIColor colorWithRed:22.0/255.0 green:21.0/255.0 blue:16.0/255.0 alpha:0.6]];
    
    StyleButton *backbutton = [StyleButton buttonWithType:UIButtonTypeCustom];
    backbutton.frame=CGRectMake(5, 5, 60, 25);
    [backbutton.titleLabel setFont:[UIFont systemFontOfSize:15]];

    [backbutton setTitle:@"back" forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchDown];

    [backview addSubview:backbutton];
    
    [self.detailScrollView addSubview:backview];
    */
    [self.rootView bringSubviewToFront:self.backView];
    
    commentY=cellview.frame.size.height+10;
    
}

- (void)addComment: (NSString*)profilePath :(NSString*)comment :(NSString*)date
{
    UIView* cellview=[[UIView alloc] init];
    UIImageView* profileView=[[UIImageView alloc]init];
    UILabel* datelabel=[[UILabel alloc] init];
    UILabel* commentlabel=[[UILabel alloc] init];
    int cellwidth=iphoneIamgeWidth-30;
    
    //NSLog(@"addComment %f %@", commentY, date);
    cellview.frame=CGRectMake(15, commentY, cellwidth, 80);
    [cellview setBackgroundColor:[UIColor whiteColor]];
    
    profileView.frame=CGRectMake(5,5, 50, 50);
    profileView.image=[UIImage imageWithContentsOfFile:profilePath];
    
    datelabel.frame = CGRectMake(60, 5, 225, 30);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString* time=[NSString stringWithFormat:@"%@",date];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    long timeValue=[time longLongValue];
    NSDate *dateValue = [NSDate dateWithTimeIntervalSince1970:timeValue];
    time=[dateFormatter stringFromDate:dateValue];
    [datelabel setText:time];
    [datelabel setFont:[UIFont systemFontOfSize:14]];	
    
    commentlabel.frame = CGRectMake(60, 35, 225, 50);
    [commentlabel setText:comment];
    [commentlabel setFont:[UIFont systemFontOfSize:14]];
    
    // FLT_MAX here simply means no constraint in height
    CGSize maximumLabelSize = CGSizeMake(225, FLT_MAX);
    CGSize expectedLabelSize = [comment sizeWithFont:commentlabel.font constrainedToSize:maximumLabelSize lineBreakMode:commentlabel.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect newFrame = commentlabel.frame;
    newFrame.size.height = expectedLabelSize.height;
    commentlabel.frame = newFrame;
    //NSLog(@"new content size=%f",expectedLabelSize.height);
    
    newFrame = cellview.frame;
    newFrame.size.height=10+datelabel.frame.size.height+expectedLabelSize.height;
    cellview.frame=newFrame;
    cellview.tag=1;
    //NSLog(@"new frame size=%f",cellview.frame.size.height);

    [cellview addSubview:profileView];
    [cellview addSubview:datelabel];
    [cellview addSubview:commentlabel];
    
    commentY = commentY+cellview.frame.size.height+10;
    //NSLog(@"new content size=%f",commentY);
    
    [self.detailScrollView setContentSize:CGSizeMake(iphoneIamgeWidth,commentY)];
    
    [self.detailScrollView addSubview:cellview];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    
    NSNumber *commentobj=[[NSNumber alloc]initWithInt:commentNum];
    NSNumber *timelineobj=[[NSNumber alloc]initWithInt:[self.DetailModel[0] intValue]];
    NSNumber *indexobj=[[NSNumber alloc]initWithInt:[self.DetailModel[2] intValue]];
    NSNumber *fblikeobj=[[NSNumber alloc]initWithInt:fbLikeNum];
    NSDictionary* dict=[[NSDictionary alloc]initWithObjectsAndKeys:timelineobj,@"DBid", indexobj, @"index", commentobj, @"commentNum", fbID, @"fbID", fblikeobj, @"fbLikeNum",nil];
    [self.delegate updateCell:dict];

    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowFBLogin"])
    {
        //id StyleSettingsFacebokTableViewController = segue.destinationViewController;
    }

}

- (IBAction)ShareClick:(id)sender
{
    StyleButton *button = sender;
    NSLog(@"Detail Page: ShareClick tiemlineID=%d",button.DBid);
    NSLog(@"Detail Page: ShareClick path=%@",button.imagepath);
    NSLog(@"Detail Page: ShareClick note=%@",button.imagenote);
    
    if(!isFBConnect)
    {
        NSLog(@"Timeline Detail page: ShareClick, FB not connect, ShowLogin Page");
        [self performSegueWithIdentifier:@"ShowFBLogin" sender:(id)self];
        
    }
    else
    {
        UIImage* image=[UIImage imageWithContentsOfFile:button.imagepath];
        
        [FBController PublishImage:image:button.DBid:button.imageIndex:button.imagenote];
        
        [self popupwaiting];
    }
}

- (void) popupwaiting
{
    self.waitingView = [[UIAlertView alloc]
                        initWithTitle:@"waiting..."
                        message:nil
                        delegate:nil
                        cancelButtonTitle:@"cancel"
                        otherButtonTitles:nil];
    [self.waitingView show];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
                                          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    indicator.center = CGPointMake(self.waitingView.bounds.size.width / 2,
                                   self.waitingView.bounds.size.height - 20);
    
    NSLog(@"popup waiting");
    
    [indicator startAnimating];
    [self.waitingView addSubview:indicator];
    
}

-(void)dismisswaiting
{
    [self.waitingView dismissWithClickedButtonIndex:0 animated:YES];
    self.waitingView = nil;
}

- (void)SetLoginButton:(BOOL)isConnected
{
    if(isConnected)
    {
        isFBConnect=YES;
        
        //query profile
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath: userProfile]) //檢查檔案是否存在
        {
            NSLog(@"profile exist");
            isProfileExist=YES;
        }
        else
        {
            NSLog(@"No profile, need to download");
            NSDictionary* dict=[[NSDictionary alloc]init];
            dict=[appDelegate.FBController GetUserInfo];
            NSString *imageURL=[dict objectForKey:@"imagepath"];
            NSLog(@"Timeline Page: imageURL =%@",imageURL);
            UIImage* profileimage=[[UIImage alloc]init];
            profileimage=[self getImageFromURL:imageURL];
            
            //prepare profile
            NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(profileimage, 1)];
            if(NO == [imageData writeToFile:userProfile atomically:NO])
            {
                NSLog(@"Timeline Page: save profile fail");
                isProfileExist=NO;

            }
            else
                isProfileExist=YES;
            
        }
        
        
        //query FBlike and comment
        if([self.DetailModel[4] length])
        {
            [FBController QueryImageLike:self.DetailModel[4]:[self.DetailModel[0] intValue]:[self.DetailModel[2] intValue]];
            [FBController QueryImageComment:self.DetailModel[4]:[self.DetailModel[0] intValue]:[self.DetailModel[2] intValue]];
        }
    }
    else
    {
        [self dismisswaiting];
    }
}

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

-(void)finishQueryCommentResponse:(id)result :(int)timelineID :(int)index
{
    NSLog(@"Timeline Detail page: Query Comment successed! timelineID=%d, index=%d",timelineID, index);
    NSLog(@"%@", result);
    
    NSMutableArray *data=[[NSMutableArray alloc]init];
    
    data=[result valueForKey:@"data"];
    
    int count=[data count];
    
    //NSLog(@"comment number%d", commentNum);
    
    //update cell
    for (int i=0;i<count;i++)
    {
        NSMutableDictionary *dict=[data objectAtIndex:i];
        NSString *fromID=[dict valueForKey:@"fromid"];
        NSString *comment=[dict valueForKey:@"text"];
        NSString *dateValue=[dict valueForKey:@"time"];
        NSString *profileURL=[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal",fromID];
        UIImage *profileimage=[self getImageFromURL:profileURL];
        //NSLog(@"comment %d, fromID=%@, comment%@, date=%@",i, profileURL, comment, dateValue);
        
        //prepare profile
        NSString* filename=[NSString stringWithFormat:@"%@.png",fromID];
        NSString* profilePath=[timelineDirectory stringByAppendingPathComponent:filename];
        NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(profileimage, 1)];
        if(NO == [imageData writeToFile:profilePath atomically:NO])
        {
            NSLog(@"Timeline Detail page: finishQueryCommentResponse, save profile fail");
        }

        [self addComment:profilePath:comment:dateValue];
    }
    
    for (UIView *subview in [self.detailScrollView subviews])
    {
        if(subview.tag==0)
        {
            for(id view in [subview subviews])
            {
                if( [view isMemberOfClass:[UILabel class]]==YES)
                {
                    UILabel* labelview=view;
                    
                    if(labelview.tag==1)
                    {
                        NSString* newlabel=[NSString stringWithFormat:@"%d",count];
                        [labelview setText:newlabel];
                    }
                }
            }
        }
    }

    
    commentNum=count;
}

-(void)errorResponse:(NSString*)errorStatus
{
    NSLog(@"Timeline Detail Page: error Reponse Receive");
    [[[UIAlertView alloc] initWithTitle:@"Result"
                                message:errorStatus
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil]
     show];
    

}

-(void)finishPostMessageResponse:(id)result
{
    
}

-(void)finishPostImageResponse:(id)result :(int)ID :(int)index
{
    NSLog(@"Timeline Detail page: Post Image successed!");
    NSLog(@"%@", result);
    
    NSString* post_id=[NSString stringWithFormat:@"%@", [result valueForKey:@"id"]];
    NSLog(@"Timeline Detail page: post_id=%@",post_id);
    
    fbID=[NSString stringWithFormat:@"%@",post_id];
    
    //update cell
    for (UIView *subview in [self.detailScrollView subviews])
    {
        if(subview.tag==0)
        {
            for(id view in [subview subviews])
            {
  
                if( [view isMemberOfClass:[StyleButton class]]==YES)
                {
                    StyleButton* button=view;
                    [button setBackgroundImage:[UIImage imageNamed:@"timeline-fb-shared.png"] forState:UIControlStateNormal];
                    
                }
                
                if( [view isMemberOfClass:[UILabel class]]==YES)
                {
                    UILabel* labelview=view;
                    labelview.hidden=NO;
                }
                
                if( [view isMemberOfClass:[UIImageView class]]==YES)
                {
                    UIImageView* imageview=view;
                    imageview.hidden=NO;
                }
            }
            
        }
        
    }
    [self dismisswaiting];
}

-(void)finishQueryImageResponse:(id)result :(int)timelineID :(int)index
{
    NSLog(@"Timeline Detail Page: Query FB like successed! timelineID=%d, index=%d",timelineID, index);
    
    NSMutableArray *data=[[NSMutableArray alloc]init];
    
    data=[result valueForKey:@"data"];
    
    NSDictionary* likeInfo=[[NSDictionary alloc]init];
    
    likeInfo=[data valueForKey:@"like_info"];
    
    NSArray *count=[[NSArray alloc]init];
    count=[likeInfo valueForKey:@"like_count"];
    NSString *countstring=[NSString stringWithFormat:@"%@",[count objectAtIndex:0]];
    fbLikeNum = [countstring intValue];
    NSLog(@"Timeline Detail Page: like count=%d",fbLikeNum);
    
    //update cell
    for (UIView *subview in [self.detailScrollView subviews])
    {
        if(subview.tag==0)
        {
            for(id view in [subview subviews])
            {
                if( [view isMemberOfClass:[UILabel class]]==YES)
                {
                    UILabel* labelview=view;
                    
                    if(labelview.tag==2)
                    {
                        NSString* newlabel=[NSString stringWithFormat:@"%d",fbLikeNum];
                        [labelview setText:newlabel];
                    }
                }
            }
        }
    }

}

-(void)updateUserProfile
{
    
}
@end
