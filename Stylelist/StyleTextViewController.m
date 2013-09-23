//
//  StyleTextViewController.m
//  Stylelist
//
//  Created by ling on 13/6/26.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import "StyleTextViewController.h"
#import "StyleDetailViewController.h"

@interface StyleTextViewController ()

@end

@implementation StyleTextViewController
@synthesize delegate = _delegate;

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
    
    self.ShopInfo.textColor = [UIColor blackColor];
    self.ShopInfo.font = [UIFont fontWithName:@"Arial" size:18.0];
    self.ShopInfo.backgroundColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"textViewShouldBeginEditing:");
    self.ShopInfo.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
   NSLog(@"textViewDidBeginEditing:");
   self.ShopInfo.backgroundColor = [UIColor greenColor];
}

- (IBAction)done:(id)sender {
    NSLog(@"description=%@",self.ShopInfo.text);
    [self.delegate drawText:self.ShopInfo];

    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
