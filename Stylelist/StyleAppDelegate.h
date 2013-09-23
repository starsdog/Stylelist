//
//  StyleAppDelegate.h
//  Stylelist
//
//  Created by ling on 13/6/24.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyleFBWrapper.h"
#import "Reachability.h"

/*
@protocol StyleDelegate <NSObject>
@optional
- (void)updateNetworkStatus:(NetworkStatus)status;
@end
*/

@interface StyleAppDelegate : UIResponder <UIApplicationDelegate>
//@property (weak, nonatomic) id<StyleDelegate> delegate;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FacebookHelper* FBController;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) Reachability* internetReach;
@property (strong, nonatomic) Reachability* hostReach;
@property NetworkStatus netStatus;

- (void)changeTab:(int)Index;
- (NetworkStatus)isNetworkConnect;
@end
