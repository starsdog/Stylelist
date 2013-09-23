//
//  StyleLoginViewController.m
//  Stylelist
//
//  Created by ling on 13/8/13.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import "StyleLoginViewController.h"
#import "StyleAppDelegate.h"

@interface StyleLoginViewController ()
{
    StyleAppDelegate *appDelegate;
}

@end

@implementation StyleLoginViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)FBLogin:(id)sender
{
    BOOL isLogin=TRUE;
    [appDelegate.FBController LoginOrLogout:isLogin];
}

//FacebookHelperDelegate
-(void)SetLoginButton:(BOOL)isConnected
{
    if(isConnected)
    {
        NSLog(@"Login Page: FB login success. Enter main page");
        [self performSegueWithIdentifier:@"MainPage" sender:self];

    }
    else
    {
        NSLog(@"Login Page: FB login fail");
    }
}
@end
