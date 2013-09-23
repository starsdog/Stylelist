//
//  StyleClosetTableViewController.m
//  Stylelist
//
//  Created by Splashtop on 13/8/21.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import "StyleClosetTableViewController.h"
#import "DBConnector.h"
#import "StyleButton.h"
#import "StyleClosetDetailViewController.h"

const int constCategoryNumber = 2;
const int constCellNum = 8;

// a cell is composed by 100x3 width and 65x6 height
const int constCategoryTableViewXOffset = 10;
const int constCategoryTableViewYOffset = 0;
const int constCategoryCellWidth = 300;
const int constCategoryCellHeight = 390;


@interface StyleClosetTableViewController ()

@end

@implementation StyleClosetTableViewController
{
    NSMutableArray *closetCategoryTableViewArray;
    NSInteger currentCategory;
    NSMutableArray *categoryArray;
    NSMutableDictionary *pLayoutlist;
    BOOL firstLoad;
}

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
    //[self prepareCategory:0];
    currentCategory = 0;
    firstLoad=YES;
    //read layout plist
    pLayoutlist=[self prepareLayout];
    
    //create category item array
    NSLog(@"create categroy item");
    categoryArray=[[NSMutableArray alloc] init];
    for( int i=0;i<constCategoryNumber;i++)
    {
        NSMutableArray* itemArray=[[NSMutableArray alloc] init];
        [categoryArray addObject:itemArray];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    // init timelineCategorySrollView
    if(firstLoad)
    {
        [self initClosetCategoryScrollView];
        
        closetCategoryTableViewArray = [[NSMutableArray alloc]init];
        
        // init tableViews inside timelineCategorySrollView
        [self initClosetCategoryTableViews];
        firstLoad=NO;
    }
    [self updateCategory:currentCategory];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Begin --- Timeline scrollview
- (void)initClosetCategoryScrollView
{
    // prepare scroll view
    [self.closetCategoryScrollView setPagingEnabled:YES];
    [self.closetCategoryScrollView setShowsHorizontalScrollIndicator:NO];
    [self.closetCategoryScrollView setShowsVerticalScrollIndicator:NO];
    [self.closetCategoryScrollView setScrollsToTop:YES];
    [self.closetCategoryScrollView setDelegate:self];
    [self.closetCategoryScrollView setContentSize:CGSizeMake(([[UIScreen mainScreen] bounds].size.width * constCategoryNumber), ([[UIScreen mainScreen] bounds].size.height - 70))];
    
    NSLog(@"%f, %f", self.closetCategoryScrollView.contentSize.width, self.closetCategoryScrollView.contentSize.height);
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.closetCategoryScrollView)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        currentCategory = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        //NSLog(@"scrollViewDidScroll currentCategory=%d", currentCategory);
        
        self.closetCategoryPageControl.currentPage = currentCategory;
        
    }
    else
    {
        //NSLog(@"from table view");
    }

}
// End --- Timeline scrollview

- (void)initClosetCategoryTableViews
{
    for(int i = 0; i < constCategoryNumber; i++)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake((self.closetCategoryScrollView.frame.size.width * i) + constCategoryTableViewXOffset, constCategoryTableViewYOffset + 35, self.closetCategoryScrollView.frame.size.width - (2 * constCategoryTableViewXOffset), self.closetCategoryScrollView.frame.size.height - (2 * constCategoryTableViewYOffset)) style:UITableViewStylePlain];
        
        NSLog(@"table view: %f, %f, %f, %f", tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.frame.size.height);
        [tableView setBackgroundColor:[UIColor colorWithRed:106.0/255.0 green:102.0/255.0 blue:79.0/255.0 alpha:1.0]];

        
        // must set delegate & dataSource, otherwise the the table will be empty and not responsive
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.bouncesZoom = NO;
        tableView.bounces = YES;
        
        // add to canvas
        [self.closetCategoryScrollView addSubview:tableView];
        [closetCategoryTableViewArray addObject:tableView];
        //NSLog(@"tableview%d id=%@", i,(id)tableView);
        [self prepareCategory:i];
    }
    
}

// table view deledate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    int i = 0;
    NSLog(@"numberOfRowsInSection tableview id=%@", (id)theTableView);
    while (i < constCategoryNumber)
    {
        if(theTableView == closetCategoryTableViewArray[i])
        {
            break;
        }
        else
        {
            i++;
        }
    }
    return [self getCellNumberWithCategory:i];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return constCategoryCellHeight;
    int i = 0;
    
    while (i < constCategoryNumber)
    {
        if(tableView == closetCategoryTableViewArray[i])
        {
            break;
        }
        else
        {
            i++;
        }
    }
    
    return [self getCellHeightWithCategory:i index:[indexPath indexAtPosition:[indexPath length] - 1]];
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int i = 0;
    
    while (i < constCategoryNumber)
    {
        if(theTableView == closetCategoryTableViewArray[i])
        {
            break;
        }
        else
        {
            i++;
        }
    }
    
    currentCategory=i;
    
    static NSString *cellIdentifier = @"HistoryCell";
    
    closetTableViewCell *cell = (closetTableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[closetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.descriptionLabel.text = [[NSString alloc]initWithFormat: @"Test cell: %i", [indexPath indexAtPosition:[indexPath length] - 1]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Yiling please create cell content here
    [self produceCellContentWithUIView: cell.closetCellView category:currentCategory index:[indexPath indexAtPosition:[indexPath length] - 1] indexPath:indexPath];
    
    return cell;
}

- (void) produceCellContentWithUIView: (UIView*)theUIView category:(NSInteger)category index:(NSInteger)index indexPath:(NSIndexPath*)indexPath
{
    NSMutableArray *itemArray=[[NSMutableArray alloc]init];
    itemArray=[categoryArray objectAtIndex:category];
    int arrayStartIndex=index*constCellNum;
    NSLog(@"produceCellContentWithUIView category=%d, count=%d", category, [itemArray count]);
    [self prepareClosetwithLayout:theUIView:itemArray:arrayStartIndex:pLayoutlist:indexPath];
}


- (void)LoadImage:(NSArray*)array
{
    UIImage* img=[UIImage imageWithContentsOfFile:[array objectAtIndex:1]];
    
    
    int index=[[array objectAtIndex:2] intValue];
    NSMutableArray *itemArray=[[NSMutableArray alloc]init];
    itemArray=[categoryArray objectAtIndex:currentCategory];
    NSDictionary* dict=[itemArray objectAtIndex:index];

    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    [newDict addEntriesFromDictionary:dict];
    NSNumber *isCache=[[NSNumber alloc]initWithInt:1];
    [newDict setObject:isCache forKey:@"imagecache"];
    [newDict setObject:img forKey:@"image"];
    [itemArray replaceObjectAtIndex:index withObject:newDict];
   
    [self performSelectorOnMainThread:@selector(UpdateImage:) withObject:[NSArray arrayWithObjects:[array objectAtIndex:0], img, [array objectAtIndex:2], nil] waitUntilDone:NO];
    
}

- (void)UpdateImage:(NSArray*)array
{
    UITableView *tableview=[closetCategoryTableViewArray objectAtIndex:currentCategory];
    closetTableViewCell *cell  = (closetTableViewCell*)[tableview cellForRowAtIndexPath:[array objectAtIndex:0]];
    int index=[[array objectAtIndex:2] intValue];
    
    if (cell != nil)
	{
        for(UIView* cellview in [cell.closetCellView subviews])
        {
            
            if(cellview.tag==index)
            {
                for(StyleButton* button in [cellview subviews])
                {
                        //NSLog(@"LoadImage setImage %@",[array objectAtIndex:1]);
                        [button setBackgroundImage:[array objectAtIndex:1] forState:UIControlStateNormal];
                        
                }
            
            }
        }
    }
    
}

- (CGFloat) getCellHeightWithCategory:(NSInteger)category index:(NSInteger)index
{
    return 390;
}

- (CGFloat) getCellNumberWithCategory:(NSInteger)category
{
    
    NSMutableArray *itemArray=[[NSMutableArray alloc]init];
    itemArray=[categoryArray objectAtIndex:category];
    int count=[itemArray count];
    int cellNum=count/constCellNum;
    int left=count%constCellNum;
    if(left!=0) cellNum=cellNum+1;
    NSLog(@"getCellNumberWithCategory category=%d, count=%d cellNum=%d, left=%d",category, count, cellNum, left);

    return cellNum;
    //return 100;
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
        
        NSMutableArray* itemArray=[categoryArray objectAtIndex:categoryIndex];
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
            UITableView *tableview=[closetCategoryTableViewArray objectAtIndex:currentCategory];
            [tableview reloadData];
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
            NSString *closetDirectory = [documentPath stringByAppendingPathComponent:@"closetPreview"];
            
            int closetIndex = 0;
            NSMutableArray* itemArray=[categoryArray objectAtIndex:categoryIndex];
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
                NSNumber *isCache=[[NSNumber alloc]initWithInt:0];
                UIImage *image=[[UIImage alloc]init];

                
                NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:indexobj, @"PathIndex", closetPath, @"imagepath", closetID, @"closetID", closeBrand, @"brand", closeTitle, @"title", closePrice, @"price", closeTime, @"time", filename, @"imagename", closetNote, @"note",isCache,@"imagecache", image, @"image",nil];
                
                //NSLog(@"%@, index=%d",closetPath, [indexobj intValue]);
                closetIndex+=1;
                [itemArray addObject:dict];
            }
        }
        [db close];
        
    }
        
}

- (void) prepareClosetwithLayout :(UIView*)currentView :(NSMutableArray*)array :(int)arrayStartIndex :(NSMutableDictionary*)pDict :(NSIndexPath*)indexPath
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
    
    int total=[array count];
    NSLog(@"prepareCloset=%d %d",total, arrayStartIndex);
    for(int i=0;i<cellNumber;i++)
    {
        int index=arrayStartIndex+i;
        if(index==total)
        {
            NSLog(@"already reach total number");
            break;
        }
       
        NSDictionary* dict=[array objectAtIndex:index];
        //NSLog(@"index=%d, image=%@", index, [dict objectForKey:@"imagepath"]);
        [self prepareThumbnailwithLayout:currentView:dict:positionArrary:cellNumber:templateHight:i:indexPath];
    }
}

- (void) prepareThumbnailwithLayout:(UIView*)view :(NSDictionary*)dict :(NSMutableArray*)position :(int)cellNum :(int)LayoutHeight :(int)itemIndex :(NSIndexPath*)indexPath
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
    
    cellView.scrollEnabled=NO;
    
    int buttonX, buttonY, buttonHeight, buttonWidth;
    buttonHeight=height;
    buttonWidth=width;
    if(x==0)
    {
        buttonX=5;
        buttonWidth=width-10;
    }
    else
    {
        buttonX=0;
        buttonWidth=width-5;
    }
    
    buttonY=5;
    buttonHeight=height-5;
    
    
    if(height==65)//means small
    {
        button.frame=CGRectMake(buttonX, buttonY, buttonWidth, 120);
 
    }
    else if(height==130)
    {
        button.frame=CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
    }
    else if(height==260)
    {
        button.frame=CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
    }
    
    NSNumber* indexobj=[dict objectForKey:@"PathIndex"];
    int index=[indexobj intValue];
   
    NSNumber* timelineIDobj=[dict objectForKey:@"closetID"];
    int timelineID=[timelineIDobj intValue];
    NSString *imagepath = [dict objectForKey:@"imagepath"];
    NSString *imagename= [dict objectForKey:@"imagename"];
    int isImageCache=[[dict objectForKey:@"imagecache"]intValue];
    
    NSString *title = [dict objectForKey:@"title"];
    NSString *brand = [dict objectForKey:@"brand"];
    NSString *createdtime = [dict objectForKey:@"time"];
    NSNumber* priceobj=[dict objectForKey:@"Price"];
    NSString* price=[NSString stringWithFormat:@"%d",[priceobj intValue]];
    NSString* note= [dict objectForKey:@"note"];
    NSArray *closeDetail = [ [ NSArray alloc ] initWithObjects:title,brand, createdtime, price, note, nil];
    
    //NSLog(@"param: index=%d, %@",index, imagepath);
    //UIImage* closetimage=[UIImage imageWithContentsOfFile:imagepath];
    //[button setImage:closetimage forState:UIControlStateNormal];

    button.tag=index;
   
    if(isImageCache)
    {
        NSLog(@"setimage from cache");
        UIImage *img=[dict objectForKey:@"image"];
        [button setBackgroundImage:img forState:UIControlStateNormal];
    }
    else
    {
        NSLog(@"LoadImage from background");
        [self performSelectorInBackground:@selector(LoadImage:) withObject:[NSArray arrayWithObjects:indexPath, imagepath, indexobj, nil]];
    }
    
    [button setCloseDetail:timelineID:imagepath:index:imagename:closeDetail];
    [button addTarget:self action:@selector(ViewDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    cellView.tag=index;
    [cellView addSubview:button];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        
    }
    else
    {
        //[view addSubview:button];
        [view addSubview:cellView];
        
        //NSLog(@"content size=%d",y+height);
    }
    
}

- (void)updateCell:(NSDictionary*)result
{
    //update button info
    NSMutableArray* itemArray=[categoryArray objectAtIndex:currentCategory];
    
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

-(IBAction)ViewDetail:(id) sender
{
    StyleButton *button = sender;
    NSLog(@"closetID=%d",button.DBid);
    NSLog(@"closet path=%@",button.imagepath);
    NSLog(@"closet name=%@",button.imagename);
   
    if([self.comingAction isEqualToString:@"pickClothFromDressView"])
    {
        NSLog(@"From addAdressView");
        [self.delegate didCloseClosetViewController:button.imagepath andPhotoName:button.imagename];
        //dismiss this view.
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
    else
    {
        //open detail view
        NSMutableArray* itemArray=[categoryArray objectAtIndex:currentCategory];
    
        NSDictionary *dict = [itemArray objectAtIndex:button.imageIndex];
    
        NSString* detailTitle=[dict objectForKey:@"title"];
        NSString* detailBrand=[dict objectForKey:@"brand"];
        NSString *detailPrice=[dict objectForKey:@"price"];
        NSString* detailNote=[dict objectForKey:@"note"];
        NSNumber *DBid=[[NSNumber alloc]initWithInt:button.DBid];
        NSNumber *imageIndex=[[NSNumber alloc]initWithInt:button.imageIndex];
        NSArray *detailData=[[NSArray alloc]initWithObjects:detailTitle, detailBrand, [button.closeDetail objectAtIndex:2], detailPrice, detailNote, button.imagepath, DBid, imageIndex, button.imagename, nil];
    
        [self performSegueWithIdentifier:@"ShowClosetDetail" sender:(id)detailData];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowClosetDetail"])
    {
        NSLog(@"prepareForSegue ShowDetails");
        NSArray *detailData=sender;
        
        StyleClosetDetailViewController *detailViewController = [segue destinationViewController];
        //1. title 2. brand 3. date 4. price 5. note 6. imagepath 7. DBid 8. imageIndex 9. imagename
        detailViewController.DetailModel=@[[detailData objectAtIndex:0],[detailData objectAtIndex:1],[detailData objectAtIndex:2],[detailData objectAtIndex:3],[detailData objectAtIndex:4], [detailData objectAtIndex:5], [detailData objectAtIndex:6], [detailData objectAtIndex:7], [detailData objectAtIndex:8]] ;
        
        [detailViewController setValue:self forKey:@"delegate"];
        
    }
}

@end
