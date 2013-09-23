//
//  StyleTextViewController.h
//  Stylelist
//
//  Created by ling on 13/6/26.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StyleTextViewControllerDelegate <NSObject>
- (void)drawText:(UITextView*)ShopText;
@end

@interface StyleTextViewController : UIViewController <UITextViewDelegate>
@property (nonatomic , weak) id<StyleTextViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextView *ShopInfo;
- (IBAction)done:(id)sender;
@end
