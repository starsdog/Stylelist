//
//  StyleSettingsFacebokTableViewController.m
//  Stylelist
//
//  Created by Splashtop on 13/8/28.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import "StyleSettingsFacebokTableViewController.h"

@interface StyleSettingsFacebokTableViewController ()
{
    NSString *settingPlistPath;
}
@end

@implementation StyleSettingsFacebokTableViewController
{
    StyleAppDelegate *appDelegate;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    appDelegate = (StyleAppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSLog(@"FB Setting Page set delegate to self");
    appDelegate.FBController.delegate = self;
    //	NSLog(@"FB Setting Page %@",self);
    
    [appDelegate.FBController initcontroller];
    
    //read setting
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    settingPlistPath = [documentPath stringByAppendingPathComponent:@"StyleSetting.plist"];
    NSString *defaultPlistPath = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"StyleSetting.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *plistDict;
    BOOL isAutoShare=NO;
    NSError *error;
    if ([fileManager fileExistsAtPath: settingPlistPath]) //檢查檔案是否存在
    {
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingPlistPath];
        isAutoShare=[[plistDict objectForKey:@"AutoShare"] boolValue];
        NSLog(@"FB Setting Page: read auto share value =%d", isAutoShare);
    }
    else
    {
        //copy file to document path
        if(![fileManager copyItemAtPath:defaultPlistPath toPath:settingPlistPath error:&error])
        {
            NSLog(@"FB setting Page:copy setting file fail: %@", error);
        
        }
    }
    
    if(isAutoShare)
        [_AutoShareSwtich setOn:YES];
    else
        [_AutoShareSwtich setOn:NO];

}

- (void)viewDidAppear:(BOOL)animated
{
    if (![appDelegate.FBController checkIsConnected] || ![appDelegate isNetworkConnect])
    {
        self.fbLoggedInEmailInfoLabel.text = @"Disconnected";
        
        self.fbLoginButton.hidden = NO;
        self.fbLogoutButton.hidden = YES;
    }
    else
    {
        NSDictionary *fbUserInfo=[[NSDictionary alloc]init];
        fbUserInfo = [appDelegate.FBController GetUserInfo];
        self.fbLoggedInEmailInfoLabel.text = [fbUserInfo objectForKey:@"username"];
        
        NSLog(@"FB Setting Page:%@", fbUserInfo);
        
        self.fbLoginButton.hidden = YES;
        self.fbLogoutButton.hidden = NO;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)AutoShareAction:(id)sender
{
    NSLog(@"FB Setting Page: write auto share value %d",[_AutoShareSwtich isOn]);
    //write to file
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *plistDict;
    BOOL isShare=[_AutoShareSwtich isOn];
    BOOL bret=NO;
    if ([fileManager fileExistsAtPath: settingPlistPath]) //檢查檔案是否存在
    {
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingPlistPath];
        [plistDict setObject:[NSNumber numberWithBool:isShare] forKey:@"AutoShare"];
        bret=[plistDict writeToFile:settingPlistPath atomically:NO];
    }
    
    plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingPlistPath];
    BOOL isAutoShare=[[plistDict objectForKey:@"AutoShare"] boolValue];
    NSLog(@"FB Setting Page: write value after %d %d",isAutoShare, bret);
}

- (IBAction)backButton:(id)sender
{
    if([self.sourceController isEqualToString:@"SettingsTableViewController"])
    {
        NSLog(@"%@",self.navigationController);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
    
    [self.delegate didCloseSettingsFacebookController:[appDelegate.FBController checkIsConnected]];
}

- (IBAction)fbLoginButtonTouchInside:(id)sender
{
    NSLog(@"try to log in %d",[appDelegate isNetworkConnect]);

    [appDelegate.FBController LoginOrLogout:YES];
    [self.tableView reloadData];
}

- (IBAction)fbLogoutButtonTouchInside:(id)sender
{
    NSLog(@"try to log out %d",[appDelegate isNetworkConnect]);
    [appDelegate.FBController LoginOrLogout:NO];
    [self.tableView reloadData];
}

-(void)finishPostMessageResponse:(id)result
{
    
}

-(void)finishPostImageResponse:(id)result :(int)ID :(int)index
{

}

-(void)finishQueryImageResponse:(id)result :(int)ID :(int)index
{

}

-(void)finishQueryCommentResponse:(id)result :(int)ID :(int)index
{
    [appDelegate.FBController GetUserInfo];
}

-(void)errorResponse:(NSString*)errorStatus
{
    NSLog(@"FB Setting Page: error Reponse Receive");
    [[[UIAlertView alloc] initWithTitle:@"Result"
                                message:errorStatus
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil]
     show];
    
}

-(void)SetLoginButton:(BOOL)isConnected
{
    //NSLog(@"SetLoginButton SetLoginButton");

    if (!isConnected)
    {
        self.fbLoggedInEmailInfoLabel.text = @"Disconnected";
        
        self.fbLoginButton.hidden = NO;
        self.fbLogoutButton.hidden = YES;
    }
    else
    {
        NSDictionary *fbUserInfo=[[NSDictionary alloc]init];
        fbUserInfo = [appDelegate.FBController GetUserInfo];
        self.fbLoggedInEmailInfoLabel.text = [fbUserInfo objectForKey:@"username"];
        
        self.fbLoginButton.hidden = YES;
        self.fbLogoutButton.hidden = NO;
    }
}

-(void)updateUserProfile
{
    
}
@end
