//
//  StyleClosetViewController.h
//  Stylelist
//
//  Created by ling on 13/7/22.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBConnector.h"
#import "StyleButton.h"
#import "StyleClosetDetailViewController.h"

@protocol StyleClosetViewDelegate <NSObject>
@optional
- (void)didCloseClosetViewController:(NSString*)photoPath andPhotoName:(NSString*) photoName;
@end

@interface StyleClosetViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

//Allen+ for cloth selection, this parameter is set when sugue is from AddDressViewController
- (NSString*) comingAction;
//iPad
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIButton *iPadDismissViewButton;
//iPhone
@property (weak, nonatomic) IBOutlet UIButton *dismissViewButton;
//action
- (IBAction)dismissClosetView:(id)sender;
//Allen-

- (void)updateCell:(NSDictionary*)result;


@property (weak, nonatomic) id<StyleClosetViewDelegate> delegate;
@property (strong, nonatomic) NSString *comingAction;

@property (weak, nonatomic) IBOutlet UIScrollView *closetScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *closetPageControl;


@property (weak, nonatomic) IBOutlet UIScrollView *iPadclosetScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *iPadclosetPageControl;
@property (strong, nonatomic) NSMutableArray* categoryArray;
@property (strong, nonatomic) NSMutableArray* imagePositionX;
@property (strong, nonatomic) NSMutableArray* imagePositionY;
@property (strong, nonatomic) NSArray *categoryName;
@property (strong, nonatomic) NSMutableDictionary *pLayoutlist;
@property (strong, nonatomic) UIAlertView* waitingView;
@property (strong, nonatomic) IBOutlet UIView *pageView;

//detailview
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *detailbackgroundView;
@property (weak, nonatomic) IBOutlet UIScrollView *detailView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UITextField *brandField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UIImageView *closetView;
@property (strong, nonatomic) IBOutlet UITextView *noteView;
@property (weak, nonatomic) IBOutlet StyleButton *deletebutton;
@property (weak, nonatomic) IBOutlet StyleButton *savebutton;

@property int category;


@end
