//
//  StyleTimelineTableViewController.h
//  Stylelist
//
//  Created by Splashtop on 13/9/3.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "timelineTableViewCell.h"
#import "StyleAddDressViewController.h"
#import "StyleAddClothViewController.h"
#import "DBConnector.h"
#import "StyleFBWrapper.h"
#import "StyleDetailViewController.h"

@interface StyleTimelineTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewAccessibilityDelegate, StyleAddDressDelegate, StyleAddClothDelegate, FacebookHelperDelegate,StyleTimelineDetailDelegate>
@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;
@property (strong, nonatomic) UIAlertView* waitingView;

-(void)updateFacebookID: (int)timelineID :(int)index :(NSString*)fbID;


@end
