//
//  StyleTimelineViewController.m
//  Stylelist
//
//  Created by Splashtop on 13/7/4.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import "StyleTimelineViewController.h"
#import "StyleAppDelegate.h"
#import "StyleButton.h"
#import "StyleDetailViewController.h"
#import "StyleFBWrapper.h"

@interface StyleTimelineViewController ()
{
    StyleAppDelegate *appDelegate;
    NSString *DBPath;
    NSMutableArray* TimelineArray;
    NSInteger imageViewYPosition;
    NSString* profilePath;
    FacebookHelper *FBController;
    NSString* defaultprofilePath;
    BOOL isProfileExist;
    BOOL isAutoShare;
    NSString* settingPlistPath;
}
@end

@implementation StyleTimelineViewController
@synthesize imageViewYPostion;
#define ipadImageHeight 680
#define ipadImageWidth  630
#define iphoneImageHeight 420
#define iphoneIamgeWideth 320


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
    
    NSLog(@"refrash timeline");
    
   	// Do any additional setup after loading the view.
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self.timelineScrollView setPagingEnabled:NO];
        [self.timelineScrollView setShowsHorizontalScrollIndicator:NO];
        [self.timelineScrollView setShowsVerticalScrollIndicator:NO];
        [self.timelineScrollView setScrollsToTop:NO];
        [self.timelineScrollView setDelegate:self];
        [self.timelineScrollView setFrame:CGRectMake(10, 20, 300, 400)];
    }
    else
    {
        [self.iPadTimelineScrollView setPagingEnabled:NO];
        [self.iPadTimelineScrollView setShowsHorizontalScrollIndicator:NO];
        [self.iPadTimelineScrollView setShowsVerticalScrollIndicator:NO];
        [self.iPadTimelineScrollView setScrollsToTop:NO];
        [self.iPadTimelineScrollView setDelegate:self];
        [self.iPadTimelineScrollView setFrame:CGRectMake(0, 40, 600, 800)];
    }
    //[self refreshScrollView];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *Dictionary = [documentPath stringByAppendingPathComponent:@"database"];
    DBPath = [Dictionary stringByAppendingPathComponent:@"stiary.sqlite"];
    TimelineArray=[[NSMutableArray alloc]init];
    NSString *timelineDirectory = [documentPath stringByAppendingPathComponent:@"timeline"];
    profilePath=[timelineDirectory stringByAppendingPathComponent:@"profile.png"];
    settingPlistPath = [documentPath stringByAppendingPathComponent:@"StyleSetting.plist"];
   
    appDelegate = (StyleAppDelegate *)[[UIApplication sharedApplication] delegate];
    //appDelegate.FBController.delegate=self;
    //[appDelegate.FBController initcontroller];
    //_isFBConnect=[appDelegate.FBController checkIsConnected];

    FBController=[[FacebookHelper alloc]init];
    FBController.delegate=self;
    //[FBController initcontroller];
    //_isFBConnect=[FBController checkIsConnected];
   
     //query timeline event
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    isProfileExist=NO;
    
     if([fileManager fileExistsAtPath:DBPath] == NO)
     {
         NSLog(@"Timeline page: DB doesn't exist");
     }
     else
     {
         //connect DB
         FMDatabase *db = [FMDatabase databaseWithPath:DBPath];
     
         if(![db open])
         {
             NSLog(@"Timeline page: open db fail");
             return;
         }
         //NSLog(@"Timeline page: open db success");
     
         // now, query db
         [db setShouldCacheStatements:YES];
     
         FMResultSet *FMResult = [db executeQuery:@"SELECT * FROM timeline ORDER BY date ASC"];
        
         int index=0;
         while([FMResult next])
         {
             NSString *closetPath = [timelineDirectory stringByAppendingPathComponent:[FMResult stringForColumn:@"path"]];
             NSNumber *timelineID = [[NSNumber alloc]initWithInt:[FMResult intForColumn:@"tmlid"]];
             NSString *fbImageID = [NSString stringWithFormat:@"%@",[FMResult stringForColumn:@"FBImageID"]];
             NSNumber *fbLike = [[NSNumber alloc]initWithInt:[FMResult intForColumn:@"FBLikeCount"]];
             NSString *date=[NSString stringWithFormat:@"%@",[FMResult stringForColumn:@"date"]];
             NSNumber *CommentCount = [[NSNumber alloc]initWithInt:[FMResult intForColumn:@"CommentCount"]];
             NSString *note=[NSString stringWithFormat:@"%@",[FMResult stringForColumn:@"note"]];

             NSNumber *indexobj=[[NSNumber alloc]initWithInt:index];
             NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:indexobj, @"PathIndex", closetPath, @"imagepath", timelineID, @"timelineID", fbImageID, @"fbID", fbLike, @"fbLikeCount", date, @"createTime", CommentCount, @"commentNum", note, @"note",nil];
             
             //NSLog(@"%@, index=%d",closetPath, [indexobj intValue]);
             [self insertToTop:dict];
             index+=1;
             [TimelineArray addObject:dict];
             
         }
         [db close];
     
     }
   	
     imageViewYPosition=0;
     isAutoShare=NO;
    	
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Timeline Page: network status=%d",[appDelegate isNetworkConnect]);

    [FBController initcontroller];
    BOOL originStatus=_isFBConnect;
    _isFBConnect=[FBController checkIsConnected];
    NSLog(@"Timeline Page: viewDidAppear, check is connected %d",(int)_isFBConnect);
    if(originStatus!=_isFBConnect)
    {
        NSLog(@"Timeline Page: viewDidAppear, need to update");
        [self SetLoginButton:_isFBConnect];
    }
    
    //read auto share setting
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *plistDict;
    if ([fileManager fileExistsAtPath: settingPlistPath]) //檢查檔案是否存在
    {
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingPlistPath];
        isAutoShare=[[plistDict objectForKey:@"AutoShare"] boolValue];
        NSLog(@"Timeline Page: read auto share value =%d", isAutoShare);
    }

    
 }

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// prepare for segue, this works for both add dress and add cloth
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowDetails"])
    {
        NSLog(@"prepareForSegue ShowDetails");
        NSArray *detailData=sender;
        
        StyleDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.DetailModel=@[[detailData objectAtIndex:0],[detailData objectAtIndex:1],[detailData objectAtIndex:2],[detailData objectAtIndex:3],[detailData objectAtIndex:4], [detailData objectAtIndex:5], [detailData objectAtIndex:6], [detailData objectAtIndex:7]] ;
        
        [detailViewController setValue:self forKey:@"delegate"];
    }
    else if ([[segue identifier] isEqualToString:@"AddDress"])
    {
        id addDressViewController = segue.destinationViewController;
        [addDressViewController setValue:self forKey:@"delegate"];
    }
    else if ([[segue identifier] isEqualToString:@"AddCloth"])
    {
        id addClothViewController = segue.destinationViewController;
        [addClothViewController setValue:self forKey:@"delegate"];
    }
    else if ([[segue identifier] isEqualToString:@"ShowFBLogin"])
    {
        //id StyleSettingsFacebokTableViewController = segue.destinationViewController;
    }
}

//StyleAddDressDelegate and StyleAddClothDelegate, the same name for addDress and addCloth
- (void)didCloseController:(NSDictionary*)result
{
    NSLog(@"refresh timeline since AddDress or addCloth is done");
    
    int index=[TimelineArray count];
    if(index==0)
        imageViewYPosition=0;
    else
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            imageViewYPosition=index*iphoneImageHeight;
        else
            imageViewYPosition=index*ipadImageHeight;
    }
    NSNumber *indexobj=[[NSNumber alloc]initWithInt:index];
    NSString *closetPath=[result objectForKey:@"imagepath"];
    NSNumber *timelineobj=[result objectForKey:@"DBid"];
    NSString *date=[result objectForKey:@"date"];
    NSString *note=[result objectForKey:@"note"];

    NSLog(@"TimelineArray count=%d, timelineID=%d",index, [timelineobj intValue]);
    NSNumber *number=[[NSNumber alloc]initWithInt:0];
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:indexobj, @"PathIndex", closetPath, @"imagepath", timelineobj, @"timelineID", @"", @"fbID", number, @"fbLikeCount",date, @"createTime", number, @"commentNum", note, @"note", nil];
    [TimelineArray addObject:dict];
        
    [self insertToTop:dict];
    
    if(isAutoShare)
    {
        NSLog(@"Timeline Page: auto share is ture");
        StyleButton *button=[[StyleButton alloc]init];
        [button setUserData:[timelineobj intValue]:closetPath:[indexobj intValue]:note];
        [self ShareClick:(id)button];
    }
}

- (void)updateCell:(NSDictionary*)result
{
    int timelineID=[[result objectForKey:@"DBid"] intValue];
    int index=[[result objectForKey:@"index"] intValue];
    int commentNum=[[result objectForKey:@"commentNum"] intValue];
    int fblikeNum=[[result objectForKey:@"fbLikeNum"] intValue];
    NSString *fbID=[result objectForKey:@"fbID"];

    NSLog(@"updateCell commentNum%d",commentNum);
    if(commentNum>0)
        [self updateComment:timelineID:index:commentNum];
    if([fbID length])
        [self updateFacebookID:timelineID:index:fbID];
    if(fblikeNum>0)
        [self updateFacebookLike:timelineID:index:fblikeNum];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

- (void)insertNew:(NSDictionary*)dict
{
    UIImageView *clothImageView;
    NSString *closetPath = [dict objectForKey:@"imagepath"];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        clothImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageViewYPosition, 600, 800)];
        [clothImageView setImage:[UIImage imageWithContentsOfFile:closetPath]];
        [self.iPadTimelineScrollView addSubview:clothImageView];
        imageViewYPosition += 830;
        [self.iPadTimelineScrollView setContentSize:CGSizeMake(600, imageViewYPosition)];
    }
    else
    {
        clothImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageViewYPosition, 300, 400)];
        [clothImageView setImage:[UIImage imageWithContentsOfFile:closetPath]];
        [self.timelineScrollView addSubview:clothImageView];
        imageViewYPosition += 430;
        [self.timelineScrollView setContentSize:CGSizeMake(300, imageViewYPosition)];
    }
    
}

- (void) insertToTop:(NSDictionary*)dict
{
    UIView* cellview=[[UIView alloc] init];
    //UIImageView *clothImageView=[[UIImageView alloc]init];
    StyleButton *clothImage=[StyleButton buttonWithType:UIButtonTypeCustom];
    StyleButton *button = [StyleButton buttonWithType:UIButtonTypeCustom];
    UIImageView* likeView=[[UIImageView alloc]init];
    UILabel* likelabel=[[UILabel alloc] init];
    UIImageView* profileView=[[UIImageView alloc]init];
    UILabel* timelabel=[[UILabel alloc] init];
    UIImageView* commentView=[[UIImageView alloc]init];
    UILabel* commentlabel=[[UILabel alloc] init];
    
    //StyleButton tag=2: fbButton, tag=3:clothImageButton
    //Label tag=1:comment, tag=2:FBlike, tag=3:time
    //ImageView tag=1:comment, tag=2:FBlike, tag=4:profileImage
        
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        for (UIView *subview in [self.iPadTimelineScrollView subviews])
        {
            //NSLog(@"view.y=%f,view.tag=%d",subview.frame.origin.y, subview.tag);
            CGRect movedViewFrame=subview.frame;
            movedViewFrame.origin.y += ipadImageHeight;
            //NSLog(@"adject view.new.y=%f, size=%f", subview.frame.origin.y, subview.frame.size.height);
            [subview setFrame:movedViewFrame];
        }
    }
    else
    {
        for (UIView *subview in [self.timelineScrollView subviews])
        {
            //NSLog(@"view.y=%f,view.tag=%d",subview.frame.origin.y, subview.tag);
            CGRect movedViewFrame=subview.frame;
            movedViewFrame.origin.y += iphoneImageHeight;
            //NSLog(@"adject view.new.y=%f, size=%f", subview.frame.origin.y, subview.frame.size.height);
            [subview setFrame:movedViewFrame];
        }
        
    }
    
    NSNumber* indexobj=[dict objectForKey:@"PathIndex"];
    int index=[indexobj intValue];
    NSNumber* timelineIDobj=[dict objectForKey:@"timelineID"];
    int timelineID=[timelineIDobj intValue];
    //NSLog(@"inserttoTop %d",timelineID);
    NSString *closetPath = [dict objectForKey:@"imagepath"];
    NSString *fbImageID = [dict objectForKey:@"fbID"];
    NSNumber *fbLike =[dict objectForKey:@"fbLikeCount"];
    NSString *date=[dict objectForKey:@"createTime"];
    NSNumber *commentNum =[dict objectForKey:@"commentNum"];
    NSString* label=[[NSString alloc]init];
    NSString *note=[dict objectForKey:@"note"];
    
    //query FB like
    /*
    if ([fbImageID length]!= 0 && _isFBConnect)
    {
        [FBController QueryImageLike:fbImageID:timelineID:index];
        [FBController QueryImageComment:fbImageID:timelineID:index];

        NSLog(@"query FBlike and comment of timelineID=%d", timelineID);
    }*/

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
       NSLog(@"insertToTop: iPAD");
       cellview.frame=CGRectMake(10, 5, 600, 650);
       clothImage.frame =CGRectMake(30, 30, 450, 600);
       button.frame=CGRectMake(500, 30, 50, 50);
       [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
       [button setTitle:@"share" forState:UIControlStateNormal];
       likelabel.frame=CGRectMake(500, 100, 90, 50);
       [likelabel setFont:[UIFont systemFontOfSize:15]];
       label=[NSString stringWithFormat:@"%d", [fbLike intValue]];
       [likelabel setText:label];
       likelabel.tag=2;

       /*
       if ([fbImageID length]!= 0 )
       {
           [button setTitle:@"shared" forState:UIControlStateNormal];
           likelabel.frame=CGRectMake(500, 100, 50, 50);
           [likelabel setFont:[UIFont systemFontOfSize:15]];
           label=[NSString stringWithFormat:@"%d people like", [fbLike intValue]];
           [likelabel setText:label];
       }
       else
       {
           [button setTitle:@"share" forState:UIControlStateNormal];
           likelabel.frame=CGRectMake(500, 100, 50, 50);
       }*/
    }
    else
    {
       int cellheight=iphoneImageHeight-15;
       int cellwidth=iphoneIamgeWideth-30;
       cellview.frame=CGRectMake(15, 5, cellwidth, cellheight);
       profileView.frame=CGRectMake(25,10, 50, 50);
       clothImage.frame = CGRectMake(25, 70, 240, 320);
        
        commentView.frame=CGRectMake(140, 30, 30, 30);
        commentView.image=[UIImage imageNamed:@"timeline-reply.png"];
        commentlabel.frame=CGRectMake(175, 45, 10, 10);
        [commentlabel setFont:[UIFont systemFontOfSize:12]];
        label=[NSString stringWithFormat:@"%d",[commentNum intValue]];
        [commentlabel setText:label];
        commentlabel.tag=1;
        commentView.tag=1;
        
        likeView.frame=CGRectMake(190, 30, 30, 30);
        likeView.image=[UIImage imageNamed:@"timeline-like.png"];
        likelabel.frame=CGRectMake(225, 45, 10, 10);
        [likelabel setFont:[UIFont systemFontOfSize:12]];
        label=[NSString stringWithFormat:@"%d", [fbLike intValue]];
        [likelabel setText:label];
        likelabel.tag=2;
        likeView.tag=2;

       if ([fbImageID length]!= 0 ) //has comment and like icon
       {
                    
           button.frame=CGRectMake(240, 30, 30, 30);
           [button setBackgroundImage:[UIImage imageNamed:@"timeline-fb-shared.png"] forState:UIControlStateNormal];
           [button setUserData:timelineID:closetPath:index:note];
           [button addTarget:self action:@selector(ShareClick:) forControlEvents:UIControlEventTouchDown];
           button.tag=2;
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
    }
    
    [cellview setBackgroundColor:[UIColor whiteColor]];
    cellview.tag=index;
    
    [clothImage setImage:[UIImage imageWithContentsOfFile:closetPath] forState:UIControlStateNormal];
    
    NSArray *timelineDetail = [ [ NSArray alloc ] initWithObjects:date, fbImageID, likelabel.text, commentlabel.text, note, nil];
    [clothImage setTimelineDetail:timelineID:closetPath:index:timelineDetail];
    [clothImage addTarget:self action:@selector(ViewDetail:) forControlEvents:UIControlEventTouchDown];
    clothImage.tag=3;
    
    if(isProfileExist)
        profileView.image=[UIImage imageWithContentsOfFile:profilePath];
    else
        profileView.image=[UIImage imageNamed:@"defaultprofile.png"];
    profileView.contentMode=UIViewContentModeScaleAspectFit;
    profileView.tag=4;
      
    //NSLog(@"insert tag=%d", button.tag);
    
    [cellview addSubview:button];
    [cellview addSubview:likeView];
    [cellview addSubview:likelabel];
    [cellview addSubview:commentView];
    [cellview addSubview:commentlabel];
    [cellview addSubview:clothImage];
    [cellview addSubview:profileView];
    [cellview addSubview:timelabel];
    [cellview setUserInteractionEnabled:YES];
    
    //adject Y position of previous view
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self.iPadTimelineScrollView addSubview:cellview];
        imageViewYPosition = imageViewYPosition + ipadImageHeight;
        [self.iPadTimelineScrollView setContentSize:CGSizeMake(iphoneIamgeWideth, imageViewYPosition)];
        //NSLog(@"contentsize=%d",imageViewYPosition);
    }
    else
    {
        [self.timelineScrollView addSubview:cellview];
        imageViewYPosition += iphoneImageHeight;
        [self.timelineScrollView setContentSize:CGSizeMake(iphoneIamgeWideth, imageViewYPosition)];
        //NSLog(@"contentsize=%d",imageViewYPosition);
    }

    
}

-(IBAction)ViewDetail:(id) sender
{
    StyleButton *button = sender;
    
    NSDictionary *dict = [TimelineArray objectAtIndex:button.imageIndex];
    NSString* index=[NSString stringWithFormat:@"%d",button.DBid];
    NSString* imageindex=[NSString stringWithFormat:@"%d",button.imageIndex];
    NSString *imagepath=[dict objectForKey:@"imagepath"];
    NSString* time=[dict objectForKey:@"createTime"];
    NSString* FBID=[dict objectForKey:@"fbID"];
    NSString* likeNum=[NSString stringWithFormat:@"%d",[[dict objectForKey:@"fbLikeCount"] intValue]];
    NSString* commentNum=[NSString stringWithFormat:@"%d",[[dict objectForKey:@"commentNum"] intValue]];
    NSString* note=[dict objectForKey:@"note"];

    /*
    NSString* imagepath=[NSString stringWithFormat:@"%@",button.imagepath];
    NSString* time=[NSString stringWithFormat:@"%@",[button.timelineDetail objectAtIndex:0]];
    NSString* FBID=[NSString stringWithFormat:@"%@",[button.timelineDetail objectAtIndex:1]];
    NSString* likeNum=[NSString stringWithFormat:@"%@",[button.timelineDetail objectAtIndex:2]];
    NSString* commentNum=[NSString stringWithFormat:@"%@",[button.timelineDetail objectAtIndex:3]];
    NSString* note=[NSString stringWithFormat:@"%@",[button.timelineDetail objectAtIndex:4]];
    */
    
    NSArray *detailData=[[NSArray alloc]initWithObjects:index, imagepath, imageindex, time, FBID, likeNum, commentNum, note, nil];
    [self performSegueWithIdentifier:@"ShowDetails" sender:(id)detailData];
}

- (void)updateUserProfile
{
    //query profile
    NSLog(@"updateUserProfile");
    if(isProfileExist==NO)
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
        if(NO == [imageData writeToFile:profilePath atomically:NO])
        {
            NSLog(@"Timeline Page: save profile fail");
            isProfileExist=NO;
        }
        else
        {
            isProfileExist=YES;
        }
        
    }

}

- (void)SetLoginButton:(BOOL)isConnected
{
    NSLog(@"Timeline Page: SetLoginButton, %d",(int)isConnected);
        
    if(isConnected && [appDelegate isNetworkConnect])
    {
            _isFBConnect=YES;
        
            //query FBlike and comment
            int count=[TimelineArray count];
            for (int i=0;i<count;i++)
            {
                NSDictionary *dict=[TimelineArray objectAtIndex:i];
                NSNumber* index=[dict objectForKey:@"PathIndex"];
                NSNumber* timelineIDobj=[dict objectForKey:@"timelineID"];
                NSString *fbImageID = [dict objectForKey:@"fbID"];
                if ([fbImageID length]!= 0)
                {
                   
                    [FBController QueryImageLike:fbImageID:[timelineIDobj intValue]:[index intValue]];
                    [FBController QueryImageComment:fbImageID:[timelineIDobj intValue]:[index intValue]];
                }
            }
              
    }
    else
    {
        [self dismisswaiting];
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

/*
- (IBAction)FBLogin:(id)sender
{
    BOOL isLogin=TRUE;
    [FBController LoginOrLogout:isLogin];
}
*/ 

-(IBAction)ShareClick:(id)sender
{
    StyleButton *button = sender;
    NSLog(@"Timeline Page: ShareClick tiemlineID=%d",button.DBid);
    NSLog(@"Timeline Page: ShareClick path=%@",button.imagepath);
    NSLog(@"Timeline Page: ShareClick note=%@",button.imagenote);
       
    if(!_isFBConnect)
    {
        NSLog(@"Timeline Page: ShareClick, FB not connect, LoginFB, change to setting page");
        //BOOL isLogin=TRUE;
        //[FBController LoginOrLogout:isLogin];
        //[appDelegate changeTab:2];
        [self performSegueWithIdentifier:@"ShowFBLogin" sender:(id)self];

    }
    else if ( ![appDelegate isNetworkConnect])
    {
        NSString *alertText=[NSString stringWithFormat:@"Access Not Available, can't share photo"];
        [[[UIAlertView alloc] initWithTitle:@"Result"
                                    message:alertText
                                   delegate:self
                          cancelButtonTitle:@"OK!"
                          otherButtonTitles:nil]
         show];
    }
    else
    {
    
    /*
    NSDictionary *dict=[TimelineArray objectAtIndex:button.tag];
    NSString *closetPath = [dict objectForKey:@"imagepath"];
    
    NSArray *array = [closetPath componentsSeparatedByString:@"/"];
    int count=[array count];
    NSString* name=[[NSString alloc]init];
    name=[array objectAtIndex:(count-1)];
    NSLog(@"name=%@",name);
    */
    UIImage* image=[UIImage imageWithContentsOfFile:button.imagepath];
    
    [FBController PublishImage:image:button.DBid:button.imageIndex:button.imagenote];
    
    [self popupwaiting];
    }
    /*
    NSString* postID=@"100000234396358_631911106826697";
    NSString* name=@"timeline1374747128.605285.jpg";

    DBConnector *stairyDB = [DBConnector new];

    [stairyDB insertFBImageIDtoTimeline:name:postID];
    */
}

#pragma mark – FacebookHelperDelegate
-(void)finishPostImageResponse:(id)result :(int)timelineID :(int)index
{
    //NSLog(@"Timeline Page: Post Image successed!");
    NSLog(@"%@", result);
    
    NSString* post_id=[NSString stringWithFormat:@"%@", [result valueForKey:@"id"]];
    NSLog(@"Timeline Page: post_id=%@",post_id);
    
    [self updateFacebookID:timelineID:index:post_id];
    [self dismisswaiting];

}

-(void)finishQueryImageResponse:(id)result :(int)timelineID :(int)index
{
   
    //NSLog(@"%@", result);
    
    NSMutableArray *data=[[NSMutableArray alloc]init];
    
    data=[result valueForKey:@"data"];
    
    NSDictionary* likeInfo=[[NSDictionary alloc]init];
    
    likeInfo=[data valueForKey:@"like_info"];
    
    NSArray *count=[[NSArray alloc]init];
    count=[likeInfo valueForKey:@"like_count"];
    NSString *countstring=[NSString stringWithFormat:@"%@",[count objectAtIndex:0]];
    int likecount = [countstring intValue];
    
    NSLog(@"Timeline Page: Query FB like successed! timelineID=%d, index=%d, like count=%d",timelineID, index, likecount);
    
    [self updateFacebookLike:timelineID:index:likecount];

}

-(void)finishQueryCommentResponse:(id)result :(int)timelineID :(int)index
{
   
    //NSLog(@"%@", result);
    
    NSMutableArray *data=[[NSMutableArray alloc]init];
    
    data=[result valueForKey:@"data"];
    int commentNum=[data count];

    NSLog(@"Timeline Page: Query Comment successed! timelineID=%d, index=%d, commentnum=%d",timelineID, index, commentNum);

    [self updateComment:timelineID:index:commentNum];
}

-(void)finishPostMessageResponse:(id)result
{
    
}

-(void)errorResponse:(NSString*)errorStatus
{
    NSLog(@"Timeline Page: error Reponse Receive");
    [[[UIAlertView alloc] initWithTitle:@"Result"
                                message:errorStatus
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil]
     show];
    

    [self dismisswaiting];
}

-(void)updateFacebookID: (int)timelineID :(int)index :(NSString*)fbID
{
    //update id to DB
    DBConnector *stairyDB = [DBConnector new];
    //BOOL bret=[stairyDB insertFBImageIDtoTimeline:timelineID:fbID];
    //NSLog(@"Timeline Page: updateFBID DB result=%d",bret);
    [stairyDB insertFBImageIDtoTimeline:timelineID:fbID];
	    
    //update cell
    int viewIndex=0;
    UIScrollView* timeline=[[UIScrollView alloc]init];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        timeline=self.iPadTimelineScrollView;
    else
        timeline=self.timelineScrollView;
    
    for (UIView *subview in [timeline subviews])
    {
        if (viewIndex==index)
        {
            for(id view in [subview subviews])
            {
                if( [view isMemberOfClass:[StyleButton class]]==YES)
                {
                    StyleButton* button=view;
                    //NSLog(@"button tag=%d",button.tag);
                    
                    if(button.tag==2) //fb button
                        [button setBackgroundImage:[UIImage imageNamed:@"timeline-fb-shared.png"] forState:UIControlStateNormal];
                    
                    if(button.tag==3) //clothes button
                    {
                        //NSLog(@"update timeline detail information %@",button.imagepath);
                        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                        NSMutableDictionary *oldDict=[TimelineArray objectAtIndex:button.imageIndex];
                        [newDict addEntriesFromDictionary:oldDict];
                        [newDict setObject:fbID forKey:@"fbID"];
                        [TimelineArray replaceObjectAtIndex:button.imageIndex withObject:newDict];
                        NSDictionary *dict = [TimelineArray objectAtIndex:button.imageIndex];
                        NSLog(@"Timeline Page: updateFacebookID, new FBID=%@",[dict objectForKey:@"fbID"]);
                        
                    }
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
            break;
        }
        viewIndex += 1;
    }

}

-(void)updateComment :(int)timelineID :(int)index :(int)commentNum
{
    //update cell
    int viewIndex=0;
    UIScrollView* timeline=[[UIScrollView alloc]init];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        timeline=self.iPadTimelineScrollView;
    else
        timeline=self.timelineScrollView;
    
    for (UIView *subview in [timeline subviews])
    {
        if (viewIndex==index)
        {
            for(id view in [subview subviews])
            {
                if( [view isMemberOfClass:[StyleButton class]]==YES)
                {
                    StyleButton* button=view;
                    if(button.tag==3) //clothes button
                    {
                        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                        NSMutableDictionary *oldDict=[TimelineArray objectAtIndex:button.imageIndex];
                        [newDict addEntriesFromDictionary:oldDict];
                        NSNumber *commentobj=[[NSNumber alloc]initWithInt:commentNum];
                        [newDict setObject:commentobj forKey:@"commentNum"];
                        [TimelineArray replaceObjectAtIndex:button.imageIndex withObject:newDict];
                        NSDictionary *dict = [TimelineArray objectAtIndex:button.imageIndex];
                        NSLog(@"Timeline Page: updateComment,  new comment Count=%d",[[dict objectForKey:@"commentNum"] intValue]);
                        
                    }
                    
                }
                
                if( [view isMemberOfClass:[UILabel class]]==YES)
                {
                    UILabel* labelview=view;
                    if(labelview.tag==1)
                    {
                        UILabel* labelview=view;
                        NSString* newlabel=[NSString stringWithFormat:@"%d",commentNum];
                        [labelview setText:newlabel];
                    }
                }
            }
            break;
        }
        viewIndex += 1;
    }
    
    //update comment count to DB
    DBConnector *stairyDB = [DBConnector new];
    
    //BOOL bret=[stairyDB insertCommentCounttoTimeline:timelineID:commentNum];
    [stairyDB insertCommentCounttoTimeline:timelineID:commentNum];
    
    //NSLog(@"updateDB result=%d",bret);
    
}

-(void) updateFacebookLike :(int)timelineID :(int)index :(int)fblikeNum
{
    //update cell
    int viewIndex=0;
    UIScrollView* timeline=[[UIScrollView alloc]init];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        timeline=self.iPadTimelineScrollView;
    else
        timeline=self.timelineScrollView;
    
    for (UIView *subview in [timeline subviews])
    {
        if (viewIndex==index)
        {
            for(id view in [subview subviews])
            {
                if( [view isMemberOfClass:[StyleButton class]]==YES)
                {
                    StyleButton* button=view;
                    if(button.tag==3) //clothes button
                    {
                        //NSLog(@"update timeline detail information %@",button.imagepath);
                        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                        NSMutableDictionary *oldDict=[TimelineArray objectAtIndex:button.imageIndex];
                        [newDict addEntriesFromDictionary:oldDict];
                        NSNumber *likeobj=[[NSNumber alloc]initWithInt:fblikeNum];
                        [newDict setObject:likeobj forKey:@"fbLikeCount"];
                        [TimelineArray replaceObjectAtIndex:button.imageIndex withObject:newDict];
                        NSDictionary *dict = [TimelineArray objectAtIndex:button.imageIndex];
                        NSLog(@"Timeline Page: updateFacebookLike, new FB LikeCount=%d",[[dict objectForKey:@"fbLikeCont"] intValue]);
                        
                    }
                    
                }
                if( [view isMemberOfClass:[UILabel class]]==YES)
                {
                    UILabel* labelview=view;
                    //NSLog(@"label tag=%d",labelview.tag);
                    if(labelview.tag==2)
                    {
                        UILabel* labelview=view;
                        //NSLog(@"currnt label=%@",labelview.text);
                        NSString* newlabel=[NSString stringWithFormat:@"%d",fblikeNum];
                        [labelview setText:newlabel];
                        
                    }
                }
            }
            break;
        }
        viewIndex += 1;
    }
    
    //update like count to DB
    DBConnector *stairyDB = [DBConnector new];
    
    //BOOL bret=[stairyDB insertFBLiketoTimeline:timelineID:fblikeNum];
    [stairyDB insertFBLiketoTimeline:timelineID:fblikeNum];
    
    //NSLog(@"Timeline Page: updateFacebookLike DB result=%d",bret);
}

@end
