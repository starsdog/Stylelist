//
//  StyleCollectionViewController.m
//  Stylelist
//
//  Created by ling on 13/6/24.
//  Copyright (c) 2013年 ling. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "StyleCollectionViewController.h"
#import "StyleCell.h"
#import "StyleDetailViewController.h"

@interface StyleCollectionViewController ()
{
   }
@end

@implementation StyleCollectionViewController

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
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    StyleCell *mycell=[collectionView dequeueReusableCellWithReuseIdentifier:@"MyCell" forIndexPath:indexPath];

    // load the image for this cell
    NSString *imageToLoad = [NSString stringWithFormat:@"%d.JPG", indexPath.row];
    mycell.imageView.image = [UIImage imageNamed:imageToLoad];
    mycell.label.text=imageToLoad;
    [mycell.imageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [mycell.imageView.layer setBorderWidth: 3.0];

    return mycell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowDetails"])
    {
        NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        
        // load the image, to prevent it from being cached we use 'initWithContentsOfFile'
        NSString *imageNameToLoad = [NSString stringWithFormat:@"%d_full", selectedIndexPath.row];
        NSString *pathToImage = [[NSBundle mainBundle] pathForResource:imageNameToLoad ofType:@"JPG"];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathToImage];
        
        StyleDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.DetailModel=@[image, imageNameToLoad];
    }
    else if ([[segue identifier] isEqualToString:@"DoneMultiSelect"])
    {
        NSLog(@"multi select");
    }
}


@end
