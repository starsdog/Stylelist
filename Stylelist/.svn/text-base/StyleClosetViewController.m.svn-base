//
//  StyleClosetViewController.m
//  Stylelist
//
//  Created by ling on 13/7/22.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import "StyleClosetViewController.h"
#import "StyleButton.h"
#import "StyleClosetDetailViewController.h"

@interface StyleClosetViewController ()
@end

@implementation StyleClosetViewController
#define iPadScrollWidth 770
#define iPhoneScrollWidth 320
#define iphoneCategoryWidth 290
#define iphoneCategoryHeight 390
#define iphone5CategoryHeight 500

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
    NSNumber *initvalueX;
    NSNumber *initvalueY;
    _category=2;
    _categoryName=[[NSArray alloc]initWithObjects:@"Short Tops",@"Long Tops",@"Jacket",@" Pants",@"Skirts",@"Dress",@"Accessory", nil];

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self.closetScrollView setPagingEnabled:YES];
        [self.closetScrollView setShowsHorizontalScrollIndicator:NO];
        [self.closetScrollView setShowsVerticalScrollIndicator:NO];
        [self.closetScrollView setScrollsToTop:NO];
        [self.closetScrollView setDelegate:self];
        //[self.closetScrollView setFrame:CGRectMake(0, 36, iPhoneScrollWidth, 400)];
        [self.closetPageControl setNumberOfPages:_category];
        [self.closetPageControl setCurrentPage:0];
        [self.closetScrollView setContentSize:CGSizeMake(iPhoneScrollWidth*_category,400)];
        [self.closetScrollView setUserInteractionEnabled:YES];
        
        initvalueX=[[NSNumber alloc]initWithInt:15];
        initvalueY=[[NSNumber alloc]initWithInt:0];
    }
    else
    {
        [self.iPadclosetScrollView setPagingEnabled:YES];
        [self.iPadclosetScrollView setShowsHorizontalScrollIndicator:NO];
        [self.iPadclosetScrollView setShowsVerticalScrollIndicator:NO];
        [self.iPadclosetScrollView setScrollsToTop:NO];
        [self.iPadclosetScrollView setDelegate:self];
        [self.iPadclosetScrollView setFrame:CGRectMake(10, 0, iPadScrollWidth, 800)];
        [self.iPadclosetPageControl setNumberOfPages:_category];
        [self.iPadclosetPageControl setCurrentPage:0];
        [self.iPadclosetScrollView setContentSize:CGSizeMake(iPadScrollWidth*_category,800)];

        initvalueX=[[NSNumber alloc]initWithInt:15];
        initvalueY=[[NSNumber alloc]initWithInt:0];

    }
    //categroy name
    NSString *Name=[_categoryName objectAtIndex:0];
    [self.categoryLabel setText:Name];
    
    _imagePositionX=[[NSMutableArray alloc]initWithObjects:initvalueX, initvalueX, nil];
    _imagePositionY=[[NSMutableArray alloc]initWithObjects:initvalueY, initvalueY, nil];
   
    //create category item array
    _categoryArray=[[NSMutableArray alloc] init];
    for( int i=0;i<_category;i++)
    {
        NSMutableArray* itemArray=[[NSMutableArray alloc] init];
        [_categoryArray addObject:itemArray];
    }
    
    //create subview for each category
    int imageXPosition;
    CGRect frame;
    for( int i=0;i<_category;i++)
    {

        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            imageXPosition=iPadScrollWidth*i+30;
            frame = CGRectMake(imageXPosition,0, iPadScrollWidth, 800);
        }
        else
        {
            imageXPosition=iPhoneScrollWidth*i+15;
            NSLog(@"imagexPostion=%d",imageXPosition);
            if([[UIScreen mainScreen] bounds].size.height == 568)
            {
                frame = CGRectMake(imageXPosition,0, iphoneCategoryWidth, iphone5CategoryHeight);
            }
            else
            {
                frame = CGRectMake(imageXPosition,0, iphoneCategoryWidth, iphoneCategoryHeight);
            }
        }
        
        UIScrollView *view = [[UIScrollView alloc]initWithFrame:frame];
        [view setBackgroundColor:[UIColor colorWithRed:22.0/255.0 green:21.0/255.0 blue:16.0/255.0 alpha:1]];
        //[view setBackgroundColor:[UIColor redColor]];
        view.tag=i;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [self.iPadclosetScrollView addSubview:view];
        }
        else
        {
            [self.closetScrollView addSubview:view];
        }
        
    }
    
    
    
    //prepare layout
    _pLayoutlist=[self prepareLayout];
    [self prepareCategory:0];
    
    [self dismissDetailView];
    
    if([self.comingAction isEqualToString:@"pickClothFromDressView"])
    {
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            self.dismissViewButton.hidden = NO;
        }
        else
        {
            self.iPadDismissViewButton.hidden = NO;
        }
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    int page;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        page=self.iPadclosetPageControl.currentPage;
        
    }
    else
    {
        page=self.closetPageControl.currentPage;
        
    }
    [self updateCategory:page];
}

- (void) updateCategory :(int)categoryIndex
{
    NSLog(@"Closet page: updateCategory %d",categoryIndex);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *Dictionary = [documentPath stringByAppendingPathComponent:@"database"];
    NSString *DBPath = [Dictionary stringByAppendingPathComponent:@"stiary.sqlite"];
    
    //query closet item
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:DBPath] == NO)
    {
        NSLog(@"DB doesn't exist");
    }
    else
    {
        //connect DB
        FMDatabase *db = [FMDatabase databaseWithPath:DBPath];
        
        if(![db open])
        {
            NSLog(@"open db fail");
            return;
        }
        NSLog(@"open db success");
        
        // now, query db
        [db setShouldCacheStatements:YES];
        
        NSMutableArray* itemArray=[_categoryArray objectAtIndex:categoryIndex];
        int count=[itemArray count];
        if(count==0)
            return;
        NSDictionary* dict=[itemArray objectAtIndex:(count-1)];
        int closetID=[[dict objectForKey:@"closetID"] intValue];
        
        NSString *sql=[[NSString alloc]init];
        
        //sql=[NSString stringWithFormat:@"SELECT * FROM closet where type=1 and cltid > %d ORDER BY date ASC", closetID];
        sql=[NSString stringWithFormat:@"SELECT * FROM closet where closet=%d and cltid > %d ORDER BY date ASC", categoryIndex, closetID];
        NSLog(@"sql=%@",sql);
        
        NSString *closetDirectory = [documentPath stringByAppendingPathComponent:@"closet"];
        FMResultSet *FMResult = [db executeQuery:sql];
        int closetIndex = count;
        BOOL isNewItem=NO;
        while([FMResult next])
        {
            NSString *closetPath = [closetDirectory stringByAppendingPathComponent:[FMResult stringForColumn:@"path"]];
            NSNumber *closetID = [[NSNumber alloc]initWithInt:[FMResult intForColumn:@"cltid"]];
            NSNumber *indexobj=[[NSNumber alloc]initWithInt:closetIndex];
            NSString *closeBrand = [NSString stringWithFormat:@"%@",[FMResult stringForColumn:@"brand"]];
            NSString *closeTitle = [NSString stringWithFormat:@"%@",[FMResult stringForColumn:@"title"]];
            NSNumber *closePrice = [[NSNumber alloc]initWithInt:[FMResult intForColumn:@"price"]];
            NSString *closeTime = [NSString stringWithFormat:@"%@",[FMResult stringForColumn:@"date"]];
            NSString *filename = [NSString stringWithFormat:@"%@",[FMResult stringForColumn:@"path"]];
            NSString *closetNote = [NSString stringWithFormat:@"%@",[FMResult stringForColumn:@"note"]];

            NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:indexobj, @"PathIndex", closetPath, @"imagepath", closetID, @"closetID", closeBrand, @"brand", closeTitle, @"title", closePrice, @"price", closeTime, @"time", filename, @"imagename", closetNote, @"note",nil];
            
            //NSLog(@"%@, index=%d",closetPath, [indexobj intValue]);
            closetIndex+=1;
            [itemArray addObject:dict];
            isNewItem=YES;
        }
        
        [db close];
        
        if(isNewItem==YES)
        {
            [self updateItemwithLayout:itemArray:categoryIndex:count:_pLayoutlist];
        }
    }
   
}

- (void) prepareCategory :(int)categoryIndex
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *Dictionary = [documentPath stringByAppendingPathComponent:@"database"];
    NSString *DBPath = [Dictionary stringByAppendingPathComponent:@"stiary.sqlite"];
    
    //query closet item
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:DBPath] == NO)
    {
        NSLog(@"DB doesn't exist");
    }
    else
    {
        //connect DB
        FMDatabase *db = [FMDatabase databaseWithPath:DBPath];
        
        if(![db open])
        {
            NSLog(@"open db fail");
            return;
        }
        NSLog(@"open db success");
        
        // now, query db
        [db setShouldCacheStatements:YES];
        
        NSString *sql=[[NSString alloc]init];
        {
            //sql=[NSString stringWithFormat:@"SELECT * FROM closet where type=%d ORDER BY date ASC", (categoryIndex+1)];
            sql=[NSString stringWithFormat:@"SELECT * FROM closet where closet=%d ORDER BY date ASC", categoryIndex];
            
            FMResultSet *FMResult = [db executeQuery:sql];
            NSString *closetDirectory = [documentPath stringByAppendingPathComponent:@"closet"];
            
            int closetIndex = 0;
            NSMutableArray* itemArray=[_categoryArray objectAtIndex:categoryIndex];
            while([FMResult next])
            {
                NSString *closetPath = [closetDirectory stringByAppendingPathComponent:[FMResult stringForColumn:@"path"]];
                NSNumber *closetID = [[NSNumber alloc]initWithInt:[FMResult intForColumn:@"cltid"]];
                NSNumber *indexobj=[[NSNumber alloc]initWithInt:closetIndex];
                NSString *closeBrand = [NSString stringWithFormat:@"%@",[FMResult stringForColumn:@"brand"]];
                NSString *closeTitle = [NSString stringWithFormat:@"%@",[FMResult stringForColumn:@"title"]];
                NSNumber *closePrice = [[NSNumber alloc]initWithInt:[FMResult intForColumn:@"price"]];
                NSString *closeTime = [NSString stringWithFormat:@"%@",[FMResult stringForColumn:@"date"]];
                NSString *filename = [NSString stringWithFormat:@"%@",[FMResult stringForColumn:@"path"]];
                NSString *closetNote = [NSString stringWithFormat:@"%@",[FMResult stringForColumn:@"note"]];
                
                NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:indexobj, @"PathIndex", closetPath, @"imagepath", closetID, @"closetID", closeBrand, @"brand", closeTitle, @"title", closePrice, @"price", closeTime, @"time", filename, @"imagename", closetNote, @"note",nil];
                
                //NSLog(@"%@, index=%d",closetPath, [indexobj intValue]);
                closetIndex+=1;
                [itemArray addObject:dict];
            }
        }
        [db close];
        
    }
    
    {
        NSMutableArray* itemArray=[_categoryArray objectAtIndex:categoryIndex];
        NSLog(@"item count=%d",[itemArray count]);
        [self prepareClosetwithLayout:itemArray:categoryIndex:_pLayoutlist];
    }
    
}

- (NSMutableDictionary*)prepareLayout
{
    CGFloat templateFrameWidth, templateFrameHeight, templateRate;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        templateFrameWidth = 600.0f;
        templateFrameHeight = 800.0f;
        templateRate = 2;
    }
    else
    {
        templateFrameWidth = 300.0f;
        templateFrameHeight = 400.0f;
        templateRate = 1;
    }
    
    // read plist
    NSString *defaultPlistPath = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"StyleLayoutTemplate.plist"];
    NSLog(@"%@", defaultPlistPath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *plistDict;
    if ([fileManager fileExistsAtPath: defaultPlistPath]) //檢查檔案是否存在
    {
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:defaultPlistPath];
    }
    else
    {
        NSLog(@"No Plist, time to debug");
    }
    
    return plistDict;
}

// UIScrollViewAccessibilityDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //prepare page
    CGFloat pageWidth = scrollView.frame.size.width;
    
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    NSMutableArray* itemArray=[_categoryArray objectAtIndex:page];
    int count=[itemArray count];
    if(count==0)
    {
        NSLog(@"Closet Page: change page, scrollViewDidEndDragging=%d",page);
        [self popupwaiting];
        [NSThread detachNewThreadSelector:@selector(updatetask) toTarget:self withObject:nil];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    NSMutableArray* itemArray=[_categoryArray objectAtIndex:page];
    int count=[itemArray count];
    if(count==0)
    {
        NSLog(@"Closet Page: change page, scrollViewDidEndDecelerating=%d",page);
        [self popupwaiting];
        [NSThread detachNewThreadSelector:@selector(updatetask) toTarget:self withObject:nil];
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    CGFloat pageWidth = scrollView.frame.size.width;
    
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
       
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.iPadclosetPageControl.currentPage = page;

    }
    else
    {
        self.closetPageControl.currentPage = page;
       
    }

    NSString *Name=[_categoryName objectAtIndex:page];
    [self.categoryLabel setText:Name];
    
    /*
    NSMutableArray* itemArray=[categoryArray objectAtIndex:page];
    int count=[itemArray count];
    if(count==0)
    {
        NSLog(@"Closet Page: change page, updateCurrentPageDisplay=%d",page);
        [NSThread detachNewThreadSelector:@selector(updatetask) toTarget:self withObject:nil];
    }
    */
    
}

- (void)updatetask
{
    [self performSelectorOnMainThread:@selector(popupwaiting) withObject:nil waitUntilDone:NO];
    
    int page;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        page=self.iPadclosetPageControl.currentPage;
        
    }
    else
    {
        page=self.closetPageControl.currentPage;
        
    }
    
    [self prepareCategory:page];
    
    [self performSelectorOnMainThread:@selector(dismisswaiting) withObject:nil waitUntilDone:NO];

}


- (void)popupwaiting
{
    NSLog(@"popup wiating");
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
                                   self.waitingView.bounds.size.height - 45);
    [indicator startAnimating];
    [self.waitingView addSubview:indicator];
    
}

-(void)dismisswaiting
{
    [self.waitingView dismissWithClickedButtonIndex:0 animated:YES];
    self.waitingView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareCloset:(NSMutableArray*)array :(int)arrayIndex
{
    int imageXPosition;
    CGRect frame;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        imageXPosition=iPadScrollWidth*arrayIndex;
        frame = CGRectMake(imageXPosition,0, iPadScrollWidth, 800);
    }
    else
    {
        imageXPosition=iPhoneScrollWidth*arrayIndex;
        frame = CGRectMake(imageXPosition,0, iPhoneScrollWidth, 400);
    }
    UIScrollView *view = [[UIScrollView alloc]initWithFrame:frame];
    [view setBackgroundColor:[UIColor redColor]];
    
    int total=[array count];
    NSLog(@"prepareCloset=%d %d",total, arrayIndex);
    for(int i=0;i<total;i++)
    {
        NSDictionary* dict=[array objectAtIndex:i];
        [self prepareThumbnail:view:dict:arrayIndex];
    }
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self.iPadclosetScrollView addSubview:view];
    }
    else
    {
        [self.closetScrollView addSubview:view];
    }
   
}

- (void) prepareClosetwithLayout:(NSMutableArray*)array :(int)arrayIndex :(NSMutableDictionary*)pDict
{
    CGFloat templateRate;
       if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        templateRate = 2;
    }
    else
    {
        templateRate = 1;
    }

    
    NSString *objectkey = [[NSString alloc]initWithFormat: @"template1"];
    NSMutableDictionary *plistTemplateDict = [pDict objectForKey:objectkey];
    
    objectkey = [[NSString alloc]initWithFormat: @"cellNumber"];
    NSInteger cellNumber = [[plistTemplateDict objectForKey:objectkey] integerValue];
    objectkey = [[NSString alloc]initWithFormat: @"templateHeight"];
    NSInteger templateHight= [[plistTemplateDict objectForKey:objectkey] integerValue];

    NSMutableArray *positionArrary=[[NSMutableArray alloc]init];
    
    for(NSInteger i = 0; i < cellNumber; i++)
    {
        objectkey = [[NSString alloc]initWithFormat: @"cell%d",i];
        NSMutableDictionary *plistCellDict = [plistTemplateDict objectForKey:objectkey];
        
        NSInteger cellX, cellY, cellWidth, cellHeight;
        cellX = [[plistCellDict objectForKey:@"x"]integerValue] * templateRate;
        cellY = [[plistCellDict objectForKey:@"y"]integerValue] * templateRate;
        cellWidth = [[plistCellDict objectForKey:@"width"]integerValue] * templateRate;
        cellHeight = [[plistCellDict  objectForKey:@"height"]integerValue] * templateRate;
        
        NSNumber *xobj=[[NSNumber alloc]initWithInt:cellX];
        NSNumber *yobj=[[NSNumber alloc]initWithInt:cellY];
        NSNumber *widthobj=[[NSNumber alloc]initWithInt:cellWidth];
        NSNumber *heightobj=[[NSNumber alloc]initWithInt:cellHeight];
    
        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:xobj, @"x", yobj, @"y", widthobj, @"width", heightobj, @"height",nil];
        [positionArrary addObject:dict];
    }
    
    /*
    int imageXPosition;
    CGRect frame;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        imageXPosition=iPadScrollWidth*arrayIndex+30;
        frame = CGRectMake(imageXPosition,0, iPadScrollWidth, 800);
    }
    else
    {
        //imageXPosition=iPhoneScrollWidth*arrayIndex+15;
        imageXPosition=iPhoneScrollWidth*arrayIndex+15;
        NSLog(@"imagexPostion=%d",imageXPosition);
        frame = CGRectMake(imageXPosition,0, iphoneCategoryWidth, iphoneCategoryHeight);
    }
    
    
    UIScrollView *view = [[UIScrollView alloc]initWithFrame:frame];
    [view setBackgroundColor:[UIColor colorWithRed:22.0/255.0 green:21.0/255.0 blue:16.0/255.0 alpha:1]];
    view.tag=arrayIndex;
    */
    
    //[self popupwaiting];
    
    UIScrollView* closetview=[[UIScrollView alloc]init];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        closetview=self.iPadclosetScrollView;
    else
        closetview=self.closetScrollView;
    
    UIScrollView *subview=[[UIScrollView alloc]init];
    BOOL isFindSubView=NO;
    for (subview in [closetview subviews])
    {
        NSLog(@"subview tag=%d",subview.tag);
        if(subview.tag==arrayIndex)
        {
            isFindSubView=YES;
            break;
        }
    }

    int total=[array count];
    NSLog(@"prepareCloset=%d %d",total, arrayIndex);
    for(int i=0;i<total;i++)
    {
        NSDictionary* dict=[array objectAtIndex:i];
        [self prepareThumbnailwithLayout:subview:dict:arrayIndex:positionArrary:cellNumber:templateHight:i];
    }
    
    /*
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self.iPadclosetScrollView addSubview:view];
    }
    else
    {
        [self.closetScrollView addSubview:view];
    }*/
 
}

- (void) updateItemwithLayout :(NSMutableArray*)array :(int)categoryIndex :(int)startindex :(NSMutableDictionary*)pDict
{
    CGFloat templateRate;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        templateRate = 2;
    }
    else
    {
        templateRate = 1;
    }
    
    
    NSString *objectkey = [[NSString alloc]initWithFormat: @"template1"];
    NSMutableDictionary *plistTemplateDict = [pDict objectForKey:objectkey];
    
    objectkey = [[NSString alloc]initWithFormat: @"cellNumber"];
    NSInteger cellNumber = [[plistTemplateDict objectForKey:objectkey] integerValue];
    objectkey = [[NSString alloc]initWithFormat: @"templateHeight"];
    NSInteger templateHight= [[plistTemplateDict objectForKey:objectkey] integerValue];
    
    NSMutableArray *positionArrary=[[NSMutableArray alloc]init];
    
    for(NSInteger i = 0; i < cellNumber; i++)
    {
        objectkey = [[NSString alloc]initWithFormat: @"cell%d",i];
        NSMutableDictionary *plistCellDict = [plistTemplateDict objectForKey:objectkey];
        
        NSInteger cellX, cellY, cellWidth, cellHeight;
        cellX = [[plistCellDict objectForKey:@"x"]integerValue] * templateRate;
        cellY = [[plistCellDict objectForKey:@"y"]integerValue] * templateRate;
        cellWidth = [[plistCellDict objectForKey:@"width"]integerValue] * templateRate;
        cellHeight = [[plistCellDict  objectForKey:@"height"]integerValue] * templateRate;
        
        NSNumber *xobj=[[NSNumber alloc]initWithInt:cellX];
        NSNumber *yobj=[[NSNumber alloc]initWithInt:cellY];
        NSNumber *widthobj=[[NSNumber alloc]initWithInt:cellWidth];
        NSNumber *heightobj=[[NSNumber alloc]initWithInt:cellHeight];
        
        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:xobj, @"x", yobj, @"y", widthobj, @"width", heightobj, @"height",nil];
        [positionArrary addObject:dict];
    }

    
    UIScrollView* closetview=[[UIScrollView alloc]init];

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        closetview=self.iPadclosetScrollView;
    else
        closetview=self.closetScrollView;
    
    UIScrollView *subview=[[UIScrollView alloc]init];
    BOOL isFindSubView=NO;
    for (subview in [closetview subviews])
    {
        NSLog(@"subview tag=%d",subview.tag);
        if(subview.tag==categoryIndex)
        {
            isFindSubView=YES;
            break;
        }
    }
    
    int total=[array count];
    if(isFindSubView)
    {
        for(int i=startindex;i<total;i++)
        {
            NSDictionary* dict=[array objectAtIndex:i];
            [self prepareThumbnailwithLayout:subview:dict:categoryIndex:positionArrary:cellNumber:templateHight:i];
        }
   
    }
    
}

- (void) prepareThumbnailwithLayout:(UIScrollView*)view :(NSDictionary*)dict :(int)arrayIndex :(NSMutableArray*)position :(int)cellNum :(int)LayoutHeight :(int)itemIndex
{
 
    UIScrollView* cellView=[[UIScrollView alloc]init];
    StyleButton *button =[StyleButton buttonWithType:UIButtonTypeCustom];
    
    int positionIndex=(itemIndex%cellNum);
    int positionPage=(itemIndex/cellNum);
    //NSLog(@"prepareThumbnailwithLayout page=%d, index=%d",positionPage, positionIndex);
    NSDictionary *posDict=[position objectAtIndex:positionIndex];
    int x=[[posDict objectForKey:@"x"] intValue];
    int y=[[posDict objectForKey:@"y"] intValue]+positionPage*LayoutHeight;
    int width=[[posDict objectForKey:@"width"] intValue];
    int height=[[posDict objectForKey:@"height"] intValue];
    
    NSLog(@"x=%d, y=%d, width=%d, height=%d",x, y, width, height);

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        //button.frame=CGRectMake(x, y , width, height);
        cellView.frame=CGRectMake(x, y , width, height);
    }
    else
    {
        //button.frame=CGRectMake(x, y, width, height);
        cellView.frame=CGRectMake(x, y , width, height);
    }
    [cellView setBackgroundColor:[UIColor colorWithRed:106.0/255.0 green:102.0/255.0 blue:79.0/255.0 alpha:1.0]];
    [cellView setUserInteractionEnabled:NO];
    

    if(height==65)//means small
    {
        button.frame=CGRectMake(5, 5, width-10, 120);
    }
    else if(height==130)
    {
        button.frame=CGRectMake(5, 5, width-10, height-10);
    }
    else if(height==260)
    {
        button.frame=CGRectMake(5, 5, width-10, height-10);
    }
    NSNumber* indexobj=[dict objectForKey:@"PathIndex"];
    int index=[indexobj intValue];
    NSNumber* timelineIDobj=[dict objectForKey:@"closetID"];
    int timelineID=[timelineIDobj intValue];
    NSString *imagepath = [dict objectForKey:@"imagepath"];
    NSString *imagename = [dict objectForKey:@"imagename"];
    
    NSString *title = [dict objectForKey:@"title"];
    NSString *brand = [dict objectForKey:@"brand"];
    NSString *createdtime = [dict objectForKey:@"time"];
    NSNumber* priceobj=[dict objectForKey:@"Price"];
    NSString* price=[NSString stringWithFormat:@"%d",[priceobj intValue]];
    NSString* note= [dict objectForKey:@"note"];
    NSArray *closeDetail = [ [ NSArray alloc ] initWithObjects:title,brand, createdtime, price, note, nil];
    
    //NSLog(@"param: index=%d, %@",index, imagepath);
    UIImage* closetimage=[UIImage imageWithContentsOfFile:imagepath];
    button.tag=index;
    [button setImage:closetimage forState:UIControlStateNormal];
    if(arrayIndex==0)
        [button setBackgroundColor:[UIColor grayColor]];
    else
        [button setBackgroundColor:[UIColor blackColor]];
    [button setCloseDetail:timelineID:imagepath:index:imagename:closeDetail];
    [button addTarget:self action:@selector(ViewDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    [cellView addSubview:button];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
    
    }
    else
    {
        //[view addSubview:button];
        [view addSubview:cellView];
        
        //NSLog(@"content size=%d",y+height);
        
        [view setContentSize:CGSizeMake(iphoneCategoryWidth,y+height)];
    }

}

//- (void) prepareThumbnail:(UIScrollView*)view :(NSString*)imagepath :(int)index :(int)arrayIndex
- (void) prepareThumbnail:(UIScrollView*)view :(NSDictionary*)dict :(int)arrayIndex
{
    
    NSNumber *numberobj=[_imagePositionX objectAtIndex:arrayIndex];
    int imageXPosition=[numberobj intValue];
    numberobj=[_imagePositionY objectAtIndex:arrayIndex];
    int imageYPosition=[numberobj intValue];

    //NSLog(@"Thumbnail %d, %d",imageXPosition, imageYPosition);
    
    StyleButton *button =[StyleButton buttonWithType:UIButtonTypeCustom];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        button.frame=CGRectMake(imageXPosition, imageYPosition, 225, 300);
    }
    else
    {
        button.frame=CGRectMake(imageXPosition, imageYPosition, 90, 120);
    }
    
    NSNumber* indexobj=[dict objectForKey:@"PathIndex"];
    int index=[indexobj intValue];
    NSNumber* timelineIDobj=[dict objectForKey:@"closetID"];
    int timelineID=[timelineIDobj intValue];
    NSString *imagepath = [dict objectForKey:@"imagepath"];
    NSString *imagename = [dict objectForKey:@"imagename"];

   
    NSString *title = [dict objectForKey:@"title"];
    NSString *brand = [dict objectForKey:@"brand"];
    NSString *createdtime = [dict objectForKey:@"time"];
    NSNumber* priceobj=[dict objectForKey:@"Price"];
    NSString* price=[NSString stringWithFormat:@"%d",[priceobj intValue]];
    NSArray *closeDetail = [ [ NSArray alloc ] initWithObjects:title,brand, createdtime, price,nil];
    
    //NSLog(@"param: index=%d, %@",index, imagepath);
    UIImage* closetimage=[UIImage imageWithContentsOfFile:imagepath];
    button.tag=index;
    [button setImage:closetimage forState:UIControlStateNormal];
    if(arrayIndex==0)
        [button setBackgroundColor:[UIColor grayColor]];
    else
        [button setBackgroundColor:[UIColor blackColor]];
    [button setCloseDetail:timelineID:imagepath:index:imagename:closeDetail];
    [button addTarget:self action:@selector(ViewDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [view addSubview:button];
    
        if((index%3)==2)
        {
            imageYPosition += 320;
            imageXPosition = 30;
        }
        else
            imageXPosition+=245;
        
        
        NSNumber *NewNumberobj=[[NSNumber alloc]initWithInt:imageXPosition];
        [_imagePositionX removeObjectAtIndex:arrayIndex];
        [_imagePositionX insertObject:NewNumberobj atIndex:arrayIndex];
        NewNumberobj=[[NSNumber alloc]initWithInt:imageYPosition];
        [_imagePositionY removeObjectAtIndex:arrayIndex];
        [_imagePositionY insertObject:NewNumberobj atIndex:arrayIndex];
        
        [view setContentSize:CGSizeMake(iPadScrollWidth,imageYPosition+250)];

        
    }
    else
    {
        [view addSubview:button];
               
        if((index%3)==2)
        {
            imageYPosition += 130;
            imageXPosition = 15;
            //NSLog(@"imageYPosition += 130");
        }
        else
            imageXPosition+=100;
        
       
        NSNumber *NewNumberobj=[[NSNumber alloc]initWithInt:imageXPosition];
        [_imagePositionX removeObjectAtIndex:arrayIndex];
        [_imagePositionX insertObject:NewNumberobj atIndex:arrayIndex];
        NewNumberobj=[[NSNumber alloc]initWithInt:imageYPosition];
        [_imagePositionY removeObjectAtIndex:arrayIndex];
        [_imagePositionY insertObject:NewNumberobj atIndex:arrayIndex];
    
        [view setContentSize:CGSizeMake(iPhoneScrollWidth,imageYPosition+130)];
        //NSLog(@"setContentSize=%d",imageYPosition+130);
    }
}

-(IBAction)ViewDetail:(id) sender
{
    StyleButton *button = sender;
    NSLog(@"ViewDetail %d",button.tag);
    NSLog(@"closetID=%d",button.DBid);
    NSLog(@"closet path=%@",button.imagepath);
    NSLog(@"closet name=%@",button.imagename);
    //NSMutableArray* itemArray=[categoryArray objectAtIndex:self.iPadclosetPageControl.currentPage];

    if([self.comingAction isEqualToString:@"pickClothFromDressView"])
    {
        NSLog(@"From addAdressView");
        /*
        NSString* imagePath;
        
        //now query photoPath
        imagePath=[itemArray objectAtIndex:button.tag];
        
        switch (self.iPadclosetPageControl.currentPage )
        {
            case 0:
            {
                imagePath=[ShortArray objectAtIndex:button.tag];
                break;
            }
            case 1:
            {
                imagePath=[ShortTopArray objectAtIndex:button.tag];
                break;
            }
            default:
            {
                break;
            }
        }
        */ 
        [self.delegate didCloseClosetViewController:button.imagepath andPhotoName:button.imagename];
        //dismiss this view.
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
    else
    {
        //open detail view
        int page=self.closetPageControl.currentPage;
        NSMutableArray* itemArray=[_categoryArray objectAtIndex:page];
        
        NSDictionary *dict = [itemArray objectAtIndex:button.imageIndex];
        
        //detailTitle=[NSString stringWithFormat:[button.closeDetail objectAtIndex:0]];
        //detailBrand=[NSString stringWithFormat:[button.closeDetail objectAtIndex:1]];
        //detailPrice=[NSString stringWithFormat:[button.closeDetail objectAtIndex:3]];
        NSString* detailTitle=[dict objectForKey:@"title"];
        NSString* detailBrand=[dict objectForKey:@"brand"];
        NSString *detailPrice=[dict objectForKey:@"price"];
        NSString* detailNote=[dict objectForKey:@"note"];
        NSNumber *DBid=[[NSNumber alloc]initWithInt:button.DBid];
        NSNumber *imageIndex=[[NSNumber alloc]initWithInt:button.imageIndex];
        NSArray *detailData=[[NSArray alloc]initWithObjects:detailTitle, detailBrand, [button.closeDetail objectAtIndex:2], detailPrice, detailNote, button.imagepath, DBid, imageIndex, nil];
        
        [self performSegueWithIdentifier:@"ShowClosetDetail" sender:(id)detailData];
        
        /*
        self.detailbackgroundView=[[UIScrollView alloc]init];
        UITextField* title=[[UITextField alloc]init];
        UILabel* date=[[UILabel alloc]init];
        UITextField* brand=[[UITextField alloc]init];
        UITextField* price=[[UITextField alloc]init];
       
        UIButton* donebutton=[[UIButton alloc]init];
        StyleButton* deletebutton=[StyleButton buttonWithType:UIButtonTypeCustom];
        StyleButton* savebutton=[StyleButton buttonWithType:UIButtonTypeCustom];
        UIImageView* closetView=[[UIImageView alloc]init];
        UIImageView* detailView=[[UIImageView alloc]init];
        */
        //self.detailbackgroundView.frame=CGRectMake(10, 5, 300, 425);
        //[self.detailbackgroundView setBackgroundColor:[UIColor colorWithRed:104.0/255.0 green:97.0/255.0 blue:68.0/255.0 alpha:0.8]];
        
                
        //title.frame=CGRectMake(5, 5, 290, 30);
        //[title setBackgroundColor:[UIColor colorWithRed:253.0/255.0 green:252.0/255.0 blue:245.0/255.0 alpha:1]];
               
        //detailView.frame=CGRectMake(5, 40, 290, 345);
        //[detailView setBackgroundColor:[UIColor colorWithRed:253.0/255.0 green:252.0/255.0 blue:245.0/255.0 alpha:1]];
        /*CGRect newframe=self.detailView.frame;
        NSLog(@"old size=%f",self.detailView.frame.size.height);
        //newframe.size.height= newframe.size.height+note.contentSize.height+5;
        newframe.size.height= newframe.size.height+self.noteView.contentSize.height+5;
        self.detailView.frame=newframe;
        NSLog(@"new size=%f",self.detailView.frame.size.height);
        */
       
        
        //self.dateField.frame=CGRectMake(5, 0, 280, 30);
        
        
        //brand.frame=CGRectMake(5, 30, 150, 30);
               
        //price.frame=CGRectMake(155, 30, 150, 30);
                
        //closetView.frame=CGRectMake(40, 60, 210, 280);
       
        /*
        [detailView setUserInteractionEnabled:YES];
        [detailView addSubview:date];
        [detailView addSubview:brand];
        [detailView addSubview:price];
        [detailView addSubview:closetView];
        [detailView addSubview:self.noteView];
        */         
        //CGRect newframe =note.frame;
        //newframe.size.height=note.contentSize.height;
        //NSLog(@"note content size=%f",note.contentSize.height);
        //note.frame=newframe;
        
        /*
        newframe=self.detailView.frame;
        NSLog(@"old size=%f",self.detailView.frame.size.height);
        //newframe.size.height= newframe.size.height+note.contentSize.height+5;
        newframe.size.height= newframe.size.height+35+5 ;
        self.detailView.frame=newframe;
        NSLog(@"new size=%f",self.detailView.frame.size.height);
        */
        
        //NSLog(@"buttonY=%f",buttonY);
        //deletebutton.frame=CGRectMake(5,buttonY, 50, 30);
        //[deletebutton setBackgroundImage:[UIImage imageNamed:@"closet-detail-cancel.png"] forState:UIControlStateNormal];
        //NSLog(@"deletebutton x=%f, y=%f",self.deletebutton.frame.origin.x, self.deletebutton.frame.origin.y);
        
        
        //savebutton.frame=CGRectMake(60, buttonY, 235, 30);
        //[savebutton setBackgroundColor:[UIColor colorWithRed:253.0/255.0 green:252.0/255.0 blue:245.0/255.0 alpha:1]];
        //[savebutton setBackgroundImage:[UIImage imageNamed:@"closet-detail-ok.png"] forState:UIControlStateNormal];
        //DBid:imagepath:cellIndex:itemdetail:imagename
        //NSLog(@"savebutton x=%f, y=%f",self.savebutton.frame.origin.x, self.savebutton.frame.origin.y);
                
        //[self.detailbackgroundView addSubview:title];
        //[self.detailbackgroundView addSubview:detailView];
        //[self.detailbackgroundView addSubview:deletebutton];
        //[self.detailbackgroundView addSubview:savebutton];
        //[self.pageView addSubview:self.detailbackgroundView];
        
        //[self showDetailView];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowClosetDetail"])
    {
        NSLog(@"prepareForSegue ShowDetails");
        NSArray *detailData=sender;
        
        StyleClosetDetailViewController *detailViewController = [segue destinationViewController];
        //1. title 2. brand 3. date 4. price 5. note 6. imagepath 7. DBid 8. imageIndex
        detailViewController.DetailModel=@[[detailData objectAtIndex:0],[detailData objectAtIndex:1],[detailData objectAtIndex:2],[detailData objectAtIndex:3],[detailData objectAtIndex:4], [detailData objectAtIndex:5], [detailData objectAtIndex:6], [detailData objectAtIndex:7]] ;
        
        [detailViewController setValue:self forKey:@"delegate"];

    }
}

-(void)showDetailView
{
    self.shadowView.hidden=NO;
    self.detailbackgroundView.hidden=NO;
   
    self.detailView.hidden=NO;
    self.titleField.hidden=NO;
    self.dateField.hidden=NO;
    self.brandField.hidden=NO;
    self.priceField.hidden=NO;
    self.closetView.hidden=NO;
    self.noteView.hidden=NO;
    
    self.deletebutton.hidden=NO;
    self.savebutton.hidden=NO;
   
}

-(void)dismissDetailView
{
    self.shadowView.hidden=YES;
    self.detailbackgroundView.hidden=YES;
    self.detailView.hidden=YES;
    self.titleField.hidden=YES;
    self.dateField.hidden=YES;
    self.brandField.hidden=YES;
    self.priceField.hidden=YES;
    self.closetView.hidden=YES;
    self.noteView.hidden=YES;
    self.deletebutton.hidden=YES;
    self.savebutton.hidden=YES;
    self.noteView=nil;
  
}

- (void)updateCell:(NSDictionary*)result
{
    //update button info
    int page=self.closetPageControl.currentPage;
    NSMutableArray* itemArray=[_categoryArray objectAtIndex:page];
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    int imageIndex=[[result objectForKey:@"index"] intValue];
    NSString* detailTitle=[result objectForKey:@"title"];
    NSString* detailBrand=[result objectForKey:@"brand"];
    NSNumber* detailPrice=[result objectForKey:@"price"];
    NSString* detailNote=[result objectForKey:@"note"];

    NSDictionary *oldDict = [itemArray objectAtIndex:imageIndex];
    NSLog(@"old title=%@",[oldDict objectForKey:@"title"]);
    
    [newDict addEntriesFromDictionary:oldDict];
    [newDict setObject:detailTitle forKey:@"title"];
    [newDict setObject:detailBrand forKey:@"brand"];
    [newDict setObject:detailPrice forKey:@"price"];
    [newDict setObject:detailNote forKey:@"note"];
    [itemArray replaceObjectAtIndex:imageIndex withObject:newDict];
    NSDictionary *dict=[itemArray objectAtIndex:imageIndex];
    NSLog(@"new title=%@",[dict objectForKey:@"title"]);
 
}


- (IBAction)dismissClosetView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
