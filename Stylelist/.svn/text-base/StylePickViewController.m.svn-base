//
//  StylePickViewController.m
//  Stylelist
//
//  Created by ling on 13/6/25.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "StylePickViewController.h"
#import "StyleCell.h"
#import "StyleDetailViewController.h"

@interface StylePickViewController ()
{
    NSMutableArray *selectedRecipes;
}
@end

@implementation StylePickViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.collection.allowsMultipleSelection = YES;
    selectedRecipes=[NSMutableArray array ];
    //[self.collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MyPickCell"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 32;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Determine the selected items by using the indexPath
    NSString *selectedRecipe= [NSString stringWithFormat:@"%d_full.JPG", indexPath.row];
    // Add the selected item into the array
    [selectedRecipes addObject:selectedRecipe];
    NSLog(@"selected, %@, %d",selectedRecipe, selectedRecipes.count);
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deSelectedRecipe= [NSString stringWithFormat:@"%d_full.JPG", indexPath.row];
    NSLog(@"decelect, %@",deSelectedRecipe);
    [selectedRecipes removeObject:deSelectedRecipe];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    StyleCell *mycell=[collectionView dequeueReusableCellWithReuseIdentifier:@"MyPickCell" forIndexPath:indexPath];
    
    // load the image for this cell
    NSString *imageToLoad = [NSString stringWithFormat:@"%d.JPG", indexPath.row];
    NSLog(@"%@",imageToLoad);
    mycell.imageView.image=[UIImage imageNamed:imageToLoad];

    //mycell.label.text=imageToLoad;
    [mycell.imageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [mycell.imageView.layer setBorderWidth: 3.0];
    
    UIView *bgColorView                 = [[UIView alloc] init];
    bgColorView.backgroundColor         = [UIColor redColor];
    mycell.selectedBackgroundView = bgColorView;
    
    return mycell;
}

//UICollectionViewFlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
    sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        retval = CGSizeMake(100, 100);
        retval.height += 35; retval.width += 35;
    }
    else
    {
        retval = CGSizeMake(60, 60);
        retval.height += 10; retval.width += 10;
 
    }
    return retval;
}

// 3: returns the spacing between the cells, headers, and footers.
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIEdgeInsetsMake(50, 20, 50, 20);
    else
        return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (IBAction)done:(id)sender {
    [self.delegate drawSelected:selectedRecipes];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
