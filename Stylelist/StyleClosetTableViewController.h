//
//  StyleClosetTableViewController.h
//  Stylelist
//
//  Created by Splashtop on 13/8/21.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "closetTableViewCell.h"

@protocol StyleClosetTableViewDelegate <NSObject>
@optional
- (void)didCloseClosetViewController:(NSString*)photoPath andPhotoName:(NSString*) photoName;
@end

@interface StyleClosetTableViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<StyleClosetTableViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *closetCategoryScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *closetCategoryPageControl;
@property (strong, nonatomic) NSString *comingAction;

- (void)initClosetCategoryScrollView;
- (void)initClosetCategoryTableViews;


@end
