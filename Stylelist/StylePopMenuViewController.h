//
//  StylePopMenuViewController.h
//  Stylelist
//
//  Created by ling on 13/7/2.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StylePopMenuDelegate <NSObject>
@required
-(void)selectedAction:(NSString *)actionName;
@end

@interface StylePopMenuViewController : UITableViewController<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *menuNames;
@property (nonatomic, weak) id<StylePopMenuDelegate> delegate;


@end
