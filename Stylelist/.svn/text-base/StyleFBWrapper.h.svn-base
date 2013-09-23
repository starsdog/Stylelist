//
//  StyleLoginViewController.h
//  Stylelist
//
//  Created by ling on 13/7/9.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "FBConnect.h"
//#import "Facebook.h"
#import <FacebookSDK/FacebookSDK.h>

@protocol FacebookHelperDelegate <NSObject>
- (void)SetLoginButton:(BOOL)isConnected;
- (void)updateUserProfile;
//Post Message to FB Wall Delegate
-(void)finishPostMessageResponse:(id)result;
-(void)finishPostImageResponse:(id)result :(int)ID :(int)index;
-(void)finishQueryImageResponse:(id)result :(int)ID :(int)index;
-(void)finishQueryCommentResponse:(id)result :(int)ID :(int)index;
-(void)errorResponse:(NSString*)errorStatus;
@end

typedef enum FBApiCallType
{
    FBApiCallNone = 0,
    FBApiCallGetUserInfo = 1,
    FBApiCallGetUserFriend = 2,
    FBApiCallPostMessage = 3,
    FBApiCallPostPicture = 4,
    FBApiCallQueryPicture = 5,
    FBApiCallQueryComment = 6
       
} FBApiCallType;

@interface FacebookHelper : NSObject
{
    //FBLoginView *loginView;
    NSArray *permissions;
    BOOL isConnected;
    FBApiCallType currentApiCallType;
    
}

@property (nonatomic , weak) id<FacebookHelperDelegate> delegate;

@property (retain, nonatomic) NSArray *permissions;
@property (nonatomic) BOOL isConnected;
//@property (nonatomic) FBLoginView* loginView;


- (void)LoginOrLogout :(BOOL)isLogin;
//- (void)Publish;
- (void)initcontroller;
- (void)PublishImage:(UIImage*)image :(int)DBid :(int)index :(NSString*)note;
- (void)QueryImageLike:(NSString*)FBID :(int)DBid :(int)index;
- (void)QueryImageComment:(NSString*)FBID :(int)DBid :(int)index;
- (BOOL)handleOpenURL:(NSURL*)url;
- (void)handleDidBecomeActive;
- (BOOL)checkIsConnected;
- (NSDictionary*) GetUserInfo;

@end
