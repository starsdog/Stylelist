	//
//  StylePopMenuViewController.m
//  Stylelist
//
//  Created by ling on 13/7/2.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import "StylePopMenuViewController.h"

@interface StylePopMenuViewController ()

@end

@implementation StylePopMenuViewController

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
    //self.MenuNames = [NSMutableArray array];
    self.clearsSelectionOnViewWillAppear = NO;


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)initWithStyle:(UITableViewStyle)style
{
    if ([super initWithStyle:style] != nil) {
        
        //Make row selections persist.
        NSInteger rowsCount = [self.menuNames count];
        
        NSInteger singleRowHeight = 60;
        NSInteger totalRowsHeight = rowsCount * singleRowHeight;
        NSLog(@"%d",totalRowsHeight);
        self.contentSizeForViewInPopover = CGSizeMake(200, totalRowsHeight);
        
        //UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, totalRowsHeight)];
        //self.view=myView;
    }
    
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger rowsCount = [self.menuNames count];
    NSLog(@"count %d",rowsCount);
    return rowsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [self.menuNames objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedActionName = [self.menuNames objectAtIndex:indexPath.row];

    //Notify the delegate if it exists.
    if (_delegate != nil) {
        [_delegate selectedAction:selectedActionName];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
