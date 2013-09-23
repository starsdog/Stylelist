//
//  StyleTimelineTableViewController.m
//  Stylelist
//
//  Created by Splashtop on 13/9/3.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import "StyleTimelineTableViewController.h"
#import "StyleAppDelegate.h"

@interface StyleTimelineTableViewController ()
{
    StyleAppDelegate *appDelegate;
    NSString *DBPath;
    NSMutableArray* TimelineArray;
    NSString* profilePath;
    FacebookHelper *FBController;
    NSString* defaultprofilePath;
    BOOL isProfileExist;
    BOOL isAutoShare;
    NSString* settingPlistPath;
    BOOL isFBConnect;
}
@end

@implementation StyleTimelineTableViewController
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
	// Do any additional setup after loading the view.
    appDelegate = (StyleAppDelegate *)[[UIApplication sharedApplication] delegate];
    FBController=[[FacebookHelper alloc]init];
    FBController.delegate=self;

    [self initTimelineViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    // init tableViews inside timelineCategorySrollView
    NSLog(@"Timeline Page: network status=%d",[appDelegate isNetworkConnect]);
    
    [FBController initcontroller];
    BOOL originStatus=isFBConnect;
    isFBConnect=[FBController checkIsConnected];
    NSLog(@"Timeline Page: viewDidAppear, check is fb connected %d",(int)isFBConnect);
    if(originStatus!=isFBConnect)
    {
        NSLog(@"Timeline Page: viewDidAppear, need to update");
        [self SetLoginButton:isFBConnect];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initTimelineViews
{
    // must set delegate & dataSource, otherwise the the table will be empty and not responsive
    self.timelineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.timelineTableView.delegate = self;
    self.timelineTableView.dataSource = self;
    self.timelineTableView.bouncesZoom = NO;
    self.timelineTableView.bounces = YES;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *Dictionary = [documentPath stringByAppendingPathComponent:@"database"];
    DBPath = [Dictionary stringByAppendingPathComponent:@"stiary.sqlite"];
    TimelineArray=[[NSMutableArray alloc]init];
    NSString *timelineDirectory = [documentPath stringByAppendingPathComponent:@"timeline"];
    profilePath=[timelineDirectory stringByAppendingPathComponent:@"profile.png"];
    settingPlistPath = [documentPath stringByAppendingPathComponent:@"StyleSetting.plist"];

    //query timeline event
    NSFileManager *fileManager = [NSFileManager defaultManager];
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
            NSNumber *isCache=[[NSNumber alloc]initWithInt:0];
            UIImage *image=[[UIImage alloc]init];
                       
            NSNumber *indexobj=[[NSNumber alloc]initWithInt:index];
            NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:indexobj, @"PathIndex", closetPath, @"imagepath", timelineID, @"timelineID", fbImageID, @"fbID", fbLike, @"fbLikeCount", date, @"createTime", CommentCount, @"commentNum", note, @"note",isCache,@"imagecache", image, @"image",nil];
            
            //NSLog(@"%@, index=%d",closetPath, [indexobj intValue]);
            index+=1;
            [TimelineArray addObject:dict];
            
        }
        [db close];
    }
   
    isProfileExist=NO;
    
}

// table view deledate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    int total=[TimelineArray count];
    return total;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return [self getCellHeightWithCategory [indexPath indexAtPosition:[indexPath length] - 1]];
    return iphoneImageHeight;
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HistoryCell";
    
    timelineTableViewCell *cell = (timelineTableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[timelineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
        
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    theTableView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:231.0/255.0 blue:172.0/255.0 alpha:1.0];
   
    // Yiling please create cell content here
    //[self produceCellContentWithUIView:cell.timelineCellView:[indexPath indexAtPosition:[indexPath length] - 1]:indexPath];
    [self produceCell:cell:indexPath];
    
    return cell;
}

- (void)produceCell: (timelineTableViewCell*)theCell :(NSIndexPath *)indexPath
{
    int total=[TimelineArray count];
    int arrayindex=total-1-[indexPath indexAtPosition:[indexPath length] - 1];
    NSDictionary *dict=[TimelineArray objectAtIndex:arrayindex];
    
    NSNumber* indexobj=[dict objectForKey:@"PathIndex"];
    int index=[indexobj intValue];
    NSNumber* timelineIDobj=[dict objectForKey:@"timelineID"];
    int timelineID=[timelineIDobj intValue];
    NSString *closetPath = [dict objectForKey:@"imagepath"];
    NSString *fbImageID = [dict objectForKey:@"fbID"];
    NSNumber *fbLike =[dict objectForKey:@"fbLikeCount"];
    NSString *date=[dict objectForKey:@"createTime"];
    NSNumber *commentNum =[dict objectForKey:@"commentNum"];
    NSString *note=[dict objectForKey:@"note"];
    int isImageCache=[[dict objectForKey:@"imagecache"]intValue];
    
    theCell.commentView.image=[UIImage imageNamed:@"timeline-reply.png"];
    NSString* commentlabel=[NSString stringWithFormat:@"%d",[commentNum intValue]];
    theCell.commentlabel.text=commentlabel;
    theCell.likeView.image=[UIImage imageNamed:@"timeline-like.png"];
    NSString* likelabel=[NSString stringWithFormat:@"%d", [fbLike intValue]];
    theCell.likelabel.text=likelabel;
    theCell.timelabel.text=date;
    if(isImageCache)
    {
        UIImage* img=[dict objectForKey:@"image"];
        [theCell.clothImage setBackgroundImage:img forState:UIControlStateNormal];
    }
    else
    {
        [self performSelectorInBackground:@selector(LoadImage:) withObject:[NSArray arrayWithObjects:indexPath, closetPath, indexobj, nil]];
    }
    NSArray *timelineDetail = [ [ NSArray alloc ] initWithObjects:date, fbImageID, likelabel, commentlabel, note, nil];
    [theCell.clothImage setTimelineDetail:timelineID:closetPath:index:timelineDetail];
    [theCell.clothImage addTarget:self action:@selector(ViewDetail:) forControlEvents:UIControlEventTouchDown];

    if ([fbImageID length]!= 0 ) //has comment and like icon
    {
        [theCell.button setBackgroundImage:[UIImage imageNamed:@"timeline-fb-shared.png"] forState:UIControlStateNormal];
        theCell.commentView.hidden=NO;
        theCell.commentlabel.hidden=NO;
        theCell.likeView.hidden=NO;
        theCell.likelabel.hidden=NO;

    }
    else
    {
        theCell.commentView.hidden=YES;
        theCell.commentlabel.hidden=YES;
        theCell.likeView.hidden=YES;
        theCell.likelabel.hidden=YES;
        [theCell.button setBackgroundImage:[UIImage imageNamed:@"timeline-fb-unshared.png"] forState:UIControlStateNormal];
    }
    [theCell.button setUserData:timelineID:closetPath:index:note];
    [theCell.button addTarget:self action:@selector(ShareClick:) forControlEvents:UIControlEventTouchDown];

    if(isProfileExist)
        theCell.profileView.image=[UIImage imageWithContentsOfFile:profilePath];
    else
        theCell.profileView.image=[UIImage imageNamed:@"defaultprofile.png"];
    
}

- (void) produceCellContentWithUIView: (UIView*)theUIView :(NSInteger)index :(NSIndexPath *)indexPath
{
    theUIView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:231.0/255.0 blue:172.0/255.0 alpha:1.0];
    int total=[TimelineArray count];
    int arrayindex=total-1-index;
    NSDictionary *dict=[TimelineArray objectAtIndex:arrayindex];
    //NSLog(@"produceCell dict index=%d, timtlineID=%d",index, [[dict objectForKey:@"timelineID"] intValue]);
    [self insertToTop:theUIView:dict:indexPath];
}

- (void)LoadImage:(NSArray*)array
{
    UIImage* img=[UIImage imageWithContentsOfFile:[array objectAtIndex:1]];
    
    int index=[[array objectAtIndex:2] intValue];
    NSDictionary *dict=[TimelineArray objectAtIndex:index];
    //NSLog(@"LoadImage dict %d",[[dict objectForKey:@"imagecache"]intValue]);
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    [newDict addEntriesFromDictionary:dict];
    NSNumber *isCache=[[NSNumber alloc]initWithInt:1];
    [newDict setObject:isCache forKey:@"imagecache"];
    [newDict setObject:img forKey:@"image"];
    [TimelineArray replaceObjectAtIndex:index withObject:newDict];
     
    [self performSelectorOnMainThread:@selector(UpdateImage:) withObject:[NSArray arrayWithObjects:[array objectAtIndex:0], img, nil] waitUntilDone:NO];

}

- (void)UpdateImage:(NSArray*)array
{
    
    timelineTableViewCell *cell  = (timelineTableViewCell*)[self.timelineTableView cellForRowAtIndexPath:[array objectAtIndex:0]];
    [cell.clothImage setBackgroundImage:[array objectAtIndex:1] forState:UIControlStateNormal];
    
    /*
    if (cell != nil)
	{
        for(UIView* cellview in [cell.timelineCellView subviews])
        {
        
            for(id view in [cellview subviews])
            {
                if( [view isMemberOfClass:[StyleButton class]]==YES)
                {
                    StyleButton* button=view;
                    if(button.tag==30)
                    {
                        //NSLog(@"LoadImage setImage %@",[array objectAtIndex:1]);
                        [button setImage:[array objectAtIndex:1] forState:UIControlStateNormal];
                        
                    }
                }
            
            }
        }
    }*/
                
}

- (void) insertToTop :(UIView*)theUIView :(NSDictionary*)dict :(NSIndexPath *)indexPath
{
    UIView* cellview=[[UIView alloc] init];
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
    int isImageCache=[[dict objectForKey:@"imagecache"]intValue];
    
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
    
    
    if(isImageCache)
    {
        //NSLog(@"setimage from cache");
        UIImage *img=[dict objectForKey:@"image"];
        [clothImage setImage:img forState:UIControlStateNormal];
    }
    else
    {
        //NSLog(@"LoadImage from background");
        [self performSelectorInBackground:@selector(LoadImage:) withObject:[NSArray arrayWithObjects:indexPath, closetPath, indexobj, nil]];
    }
    
    
    NSArray *timelineDetail = [ [ NSArray alloc ] initWithObjects:date, fbImageID, likelabel.text, commentlabel.text, note, nil];
    [clothImage setTimelineDetail:timelineID:closetPath:index:timelineDetail];
    [clothImage addTarget:self action:@selector(ViewDetail:) forControlEvents:UIControlEventTouchDown];
    clothImage.tag=30;
    
    
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

    {
        [theUIView  addSubview:cellview];
        /*
        [theUIView  addSubview:button];
        [theUIView  addSubview:likeView];
        [theUIView  addSubview:likelabel];
        [theUIView  addSubview:commentView];
        [theUIView  addSubview:commentlabel];
        [theUIView  addSubview:clothImage];
        [theUIView  addSubview:profileView];
        [theUIView  addSubview:timelabel];
        [theUIView  setUserInteractionEnabled:YES];
        */
    }
    
    
}

- (CGFloat) getCellHeightWithCategory:(NSInteger)index
{
    return 400;
}

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


-(IBAction)ShareClick:(id)sender
{
    StyleButton *button = sender;
    NSLog(@"Timeline Page: ShareClick tiemlineID=%d",button.DBid);
    NSLog(@"Timeline Page: ShareClick path=%@",button.imagepath);
    NSLog(@"Timeline Page: ShareClick note=%@",button.imagenote);
    
    if(!isFBConnect)
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
        
        UIImage* image=[UIImage imageWithContentsOfFile:button.imagepath];
        
        [FBController PublishImage:image:button.DBid:button.imageIndex:button.imagenote];
        
        [self popupwaiting];
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
    
    NSArray *detailData=[[NSArray alloc]initWithObjects:index, imagepath, imageindex, time, FBID, likeNum, commentNum, note, nil];
    [self performSegueWithIdentifier:@"ShowDetails" sender:(id)detailData];
}

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

#pragma mark – StyleAddClothDelegate
- (void)didCloseController:(NSDictionary*)result
{
    NSLog(@"refresh timeline since AddDress or addCloth is done");
    
    int index=[TimelineArray count];
    NSNumber *indexobj=[[NSNumber alloc]initWithInt:index];
    NSString *closetPath=[result objectForKey:@"imagepath"];
    NSNumber *timelineobj=[result objectForKey:@"DBid"];
    NSString *date=[result objectForKey:@"date"];
    NSString *note=[result objectForKey:@"note"];
    NSNumber *isCache=[[NSNumber alloc]initWithInt:0];
    UIImage *image=[[UIImage alloc]init];
    
    NSLog(@"TimelineArray count=%d, timelineID=%d",index, [timelineobj intValue]);
    NSNumber *number=[[NSNumber alloc]initWithInt:0];
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:indexobj, @"PathIndex", closetPath, @"imagepath", timelineobj, @"timelineID", @"", @"fbID", number, @"fbLikeCount",date, @"createTime", number, @"commentNum", note, @"note", isCache,@"imagecache", image, @"image",nil];
    [TimelineArray insertObject:dict atIndex:index];
    
    if(isAutoShare)
    {
        NSLog(@"Timeline Page: auto share is ture");
        StyleButton *button=[[StyleButton alloc]init];
        [button setUserData:[timelineobj intValue]:closetPath:[indexobj intValue]:note];
        [self ShareClick:(id)button];
    }
    
    [self.timelineTableView reloadData];
}

#pragma mark – StyleTimelineDetailDelegate
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

#pragma mark – FacebookHelperDelegate
- (void)updateUserProfile
{
    //query profile
    NSLog(@"updateUserProfile");
    if(isProfileExist==NO)
    {
        NSLog(@"No profile, need to download");
        NSDictionary* dict=[[NSDictionary alloc]init];
        dict=[FBController GetUserInfo];
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
        isFBConnect=YES;
        
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
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *oldDict=[TimelineArray objectAtIndex:index];
    [newDict addEntriesFromDictionary:oldDict];
    [newDict setObject:fbID forKey:@"fbID"];
    [TimelineArray replaceObjectAtIndex:index withObject:newDict];
    NSDictionary *dict = [TimelineArray objectAtIndex:index];
    NSLog(@"Timeline Page: updateFacebookID, new FBID=%@",[dict objectForKey:@"fbID"]);
    [self.timelineTableView reloadData];
 
}

-(void)updateComment :(int)timelineID :(int)index :(int)commentNum
{
    //update cell
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *oldDict=[TimelineArray objectAtIndex:index];
    [newDict addEntriesFromDictionary:oldDict];
    NSNumber *commentobj=[[NSNumber alloc]initWithInt:commentNum];
    [newDict setObject:commentobj forKey:@"commentNum"];
    [TimelineArray replaceObjectAtIndex:index withObject:newDict];
    NSDictionary *dict = [TimelineArray objectAtIndex:index];
    NSLog(@"Timeline Page: updateComment,  new comment Count=%d",[[dict objectForKey:@"commentNum"] intValue]);
    [self.timelineTableView reloadData];

    //update comment count to DB
    DBConnector *stairyDB = [DBConnector new];
    
    //BOOL bret=[stairyDB insertCommentCounttoTimeline:timelineID:commentNum];
    [stairyDB insertCommentCounttoTimeline:timelineID:commentNum];
    
    //NSLog(@"updateDB result=%d",bret);
    
}

-(void) updateFacebookLike :(int)timelineID :(int)index :(int)fblikeNum
{
    //update cell
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *oldDict=[TimelineArray objectAtIndex:index];
    [newDict addEntriesFromDictionary:oldDict];
    NSNumber *likeobj=[[NSNumber alloc]initWithInt:fblikeNum];
    [newDict setObject:likeobj forKey:@"fbLikeCount"];
    [TimelineArray replaceObjectAtIndex:index withObject:newDict];
    NSDictionary *dict = [TimelineArray objectAtIndex:index];
    NSLog(@"Timeline Page: updateFacebookLike, new FB LikeCount=%d",[[dict objectForKey:@"fbLikeCont"] intValue]);
    [self.timelineTableView reloadData];
    
    //update like count to DB
    DBConnector *stairyDB = [DBConnector new];
    
    //BOOL bret=[stairyDB insertFBLiketoTimeline:timelineID:fblikeNum];
    [stairyDB insertFBLiketoTimeline:timelineID:fblikeNum];
    
    //NSLog(@"Timeline Page: updateFacebookLike DB result=%d",bret);
}
@end
