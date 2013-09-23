//
//  StyleSettingsTableViewController.h
//  Stylelist
//
//  Created by Splashtop on 13/8/27.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyleAppDelegate.h"
#import "StyleSettingsFacebokTableViewController.h"

@interface StyleSettingsTableViewController : UITableViewController <StyleSettingsFacebookDelegate>
@property (weak, nonatomic) IBOutlet UILabel *facebookConnectedStatusLabel;

@end
