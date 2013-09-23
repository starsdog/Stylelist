//
//  StyleTimelineViewController.h
//  Stylelist
//
//  Created by Splashtop on 13/7/4.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyleAddDressViewController.h"
#import "StyleAddClothViewController.h"
#import "DBConnector.h"
#import "StyleFBWrapper.h"
#import "StyleDetailViewController.h"

@interface StyleTimelineViewController : UIViewController <UIScrollViewAccessibilityDelegate, StyleAddDressDelegate, StyleAddClothDelegate, FacebookHelperDelegate,StyleTimelineDetailDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *timelineScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *iPadTimelineScrollView;
@property int imageViewYPostion;
@property UIActivityIndicatorView *Waitingindicator;
@property BOOL isFBConnect;
@property (strong, nonatomic) UIAlertView* waitingView;

// prepare for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
//StyleAddDressDelegate
- (void)didCloseController:(NSDictionary*)result;

//fb related
//-(IBAction)FBLogin:(id)sender;
-(IBAction)ShareClick:(id)sender;

//FacebookHelperDelegate
-(void)SetLoginButton:(BOOL)isConnected;
- (void)updateUserProfile;
-(void)finishPostMessageResponse:(id)result;
-(void)finishPostImageResponse:(id)result :(int)ID :(int)index;
-(void)finishQueryImageResponse:(id)result :(int)ID :(int)index;
-(void)errorResponse;

//StyleTimelineDetailDelegate
- (void)updateCell:(NSDictionary*)result;

@end
