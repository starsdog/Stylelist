//
//  StyleClosetDetailViewController.h
//  Stylelist
//
//  Created by KUEI YUAN CHENG on 13/8/21.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyleButton.h"

@protocol StyleClosetDetailDelegate <NSObject>
@optional
- (void)updateCell:(NSDictionary*)result;
@end

@interface StyleClosetDetailViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) id<StyleClosetDetailDelegate> delegate;

@property (strong, nonatomic) NSArray *DetailModel;
@property (weak, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UIScrollView *detailView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UITextField *dateField;
@property (strong, nonatomic) IBOutlet UITextField *locationField;
@property (strong, nonatomic) IBOutlet UITextField *brandField;
@property (strong, nonatomic) IBOutlet UITextField *priceField;
@property (strong, nonatomic) IBOutlet UIImageView *closetView;
@property (strong, nonatomic) IBOutlet UITextView *noteView;
@property (weak, nonatomic) IBOutlet StyleButton *deletebutton;
@property (weak, nonatomic) IBOutlet StyleButton *savebutton;

@end
