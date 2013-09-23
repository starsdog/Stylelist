//
//  StyleSettingsFacebokTableViewController.h
//  Stylelist
//
//  Created by Splashtop on 13/8/28.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyleFBWrapper.h"
#import "StyleAppDelegate.h"

@protocol StyleSettingsFacebookDelegate <NSObject>

@optional
- (void)didCloseSettingsFacebookController:(BOOL)isConnected;
@end


@interface StyleSettingsFacebokTableViewController : UITableViewController <FacebookHelperDelegate>

@property (weak, nonatomic) id<StyleSettingsFacebookDelegate> delegate;
@property (strong, nonatomic) NSString *sourceController;

@property (weak, nonatomic) IBOutlet UILabel *fbLoggedInEmailInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *fbLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *fbLogoutButton;
@property (weak, nonatomic) IBOutlet UISwitch *AutoShareSwtich;
- (IBAction)AutoShareAction:(id)sender;

- (IBAction)backButton:(id)sender;
- (IBAction)fbLoginButtonTouchInside:(id)sender;
- (IBAction)fbLogoutButtonTouchInside:(id)sender;

@end
