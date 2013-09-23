//
//  StylePickViewController.h
//  Stylelist
//
//  Created by ling on 13/6/25.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StylePickViewControllerDelegate <NSObject>
- (void)drawSelected:(NSMutableArray*)selectedRecipes;
@end


@interface StylePickViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic , weak) id<StylePickViewControllerDelegate> delegate;
- (IBAction)done:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collection;

@end
