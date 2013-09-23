//
//  StyleSettingViewController.h
//  Stylelist
//
//  Created by ling on 13/8/26.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyleFBWrapper.h"

@interface StyleSettingViewController : UIViewController <FacebookHelperDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *FBLoginSwitch;
- (IBAction)FBLogin:(id)sender;

//FacebookHelperDelegate
-(void)SetLoginButton:(BOOL)isConnected;
-(void)finishPostMessageResponse:(id)result;
-(void)finishPostImageResponse:(id)result :(int)ID :(int)index;
-(void)finishQueryImageResponse:(id)result :(int)ID :(int)index;
-(void)finishQueryCommentResponse:(id)result :(int)ID :(int)index;
-(void)errorResponse;

@end
