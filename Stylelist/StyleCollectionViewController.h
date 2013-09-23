//
//  StyleCollectionViewController.h
//  Stylelist
//
//  Created by ling on 13/6/24.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StyleCollectionViewController : UICollectionViewController
<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *carImages;

@end






