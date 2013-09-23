//
//  StyleSettingViewController.m
//  Stylelist
//
//  Created by ling on 13/8/26.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import "StyleSettingViewController.h"
#import "StyleAppDelegate.h"

@interface StyleSettingViewController ()
{
    StyleAppDelegate *appDelegate;
    BOOL isFBConnect;
}
@end

@implementation StyleSettingViewController

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
    appDelegate.FBController.delegate=self;
   
    [appDelegate.FBController initcontroller];
    isFBConnect=[appDelegate.FBController checkIsConnected];
    NSLog(@"Setting Page: FBController isFBConnect=%d",isFBConnect);
    if (!isFBConnect)
        [_FBLoginSwitch setOn:NO];
    else
        [_FBLoginSwitch setOn:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)SetLoginButton:(BOOL)isConnected
{
    isFBConnect=[appDelegate.FBController checkIsConnected];
    if(isFBConnect)
    {
        [_FBLoginSwitch setOn:YES];
    }
    else
        [_FBLoginSwitch setOn:NO];

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
    
}

-(void)errorResponse
{
    NSLog(@"error Reponse Receive");   
}




- (IBAction)FBLogin:(id)sender
{
    BOOL isLogin=NO;
    if([_FBLoginSwitch isOn])
    {
        NSLog(@"Setting Page: FBLogin");
        isLogin=YES;
        [appDelegate.FBController LoginOrLogout:isLogin];
    }
    else
    {
        NSLog(@"Setting Page: FBLogout");
        isLogin=NO;
        [appDelegate.FBController LoginOrLogout:isLogin];

    }
}
@end
