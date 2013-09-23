//
//  StyleDetailViewController.h
//  Stylelist
//
//  Created by ling on 13/6/25.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyleTextViewController.h"
#import "StylePickViewController.h"
#import "StyleFBWrapper.h"

@protocol StyleTimelineDetailDelegate <NSObject>
@optional
- (void)updateCell:(NSDictionary*)result;
@end


@interface StyleDetailViewController : UIViewController <FacebookHelperDelegate>

@property (weak, nonatomic) id<StyleTimelineDetailDelegate> delegate;

@property (strong, nonatomic) NSArray *DetailModel;
@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (strong, nonatomic) UIAlertView* waitingView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIView *rootView;

- (IBAction)close:(id)sender;

//FacebookHelperDelegate
-(void)SetLoginButton:(BOOL)isConnected;
-(void)updateUserProfile;
-(void)finishQueryCommentResponse:(id)result :(int)timelineID :(int)index;
-(void)errorResponse:(NSString*)errorStatus;
-(void)finishPostMessageResponse:(id)result;
-(void)finishPostImageResponse:(id)result :(int)ID :(int)index;
-(void)finishQueryImageResponse:(id)result :(int)ID :(int)index;

@end
