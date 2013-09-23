//
//  StyleClosetDetailViewController.m
//  Stylelist
//
//  Created by KUEI YUAN CHENG on 13/8/21.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import "StyleClosetDetailViewController.h"
#import "DBConnector.h"

#define iphoneIamgeWidth 320

@interface StyleClosetDetailViewController ()
{
    NSString* detailTitle;
    NSString* detailBrand;
    NSNumber* detailPrice;
    NSString* detailNote;
    BOOL isChanged;
}

@end

@implementation StyleClosetDetailViewController
@synthesize titleField;
@synthesize detailView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
   [self drawDetail];
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    detailTitle=self.DetailModel[0];
    detailBrand=self.DetailModel[1];
    detailPrice=self.DetailModel[3];
    detailNote=self.DetailModel[4];
    
    self.dateField=[[UITextField alloc]init];
    self.locationField=[[UITextField alloc]init];
    self.brandField=[[UITextField alloc]init];
    self.priceField=[[UITextField alloc]init];
    self.closetView=[[UIImageView alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) drawDetail
{
    self.titleField.text = detailTitle;
    [self.titleField setDelegate:self];
    self.titleField.tag=1;
    [self.detailView setDelegate:self];
    
    float X=5.0,Y=5.0;
    self.dateField.frame=CGRectMake(X, Y, self.titleField.frame.size.width/2, self.titleField.frame.size.height);
    [self.dateField setText:self.DetailModel[2]];
    [self.dateField setFont:[UIFont systemFontOfSize:14]];
    
    Y=6+self.titleField.frame.size.height;
    self.brandField.frame=CGRectMake(X, Y, self.titleField.frame.size.width/2, self.titleField.frame.size.height);
    self.brandField.text=detailBrand;
    [self.brandField setDelegate:self];
    self.brandField.tag=2;
    [self.brandField setFont:[UIFont systemFontOfSize:14]];


    X=5+self.titleField.frame.size.width/2;
    NSString* priceValue=[NSString stringWithFormat:@"%d",[detailPrice intValue]];
    self.priceField.frame=CGRectMake(X,Y,self.titleField.frame.size.width/2, self.titleField.frame.size.height);
    self.priceField.text = priceValue;
    [self.priceField setDelegate:self];
    self.priceField.tag=3;
    [self.priceField setFont:[UIFont systemFontOfSize:14]];
    
    Y=self.brandField.frame.origin.y+self.brandField.frame.size.height+1;
    float width, height;
    if([[UIScreen mainScreen] bounds].size.height == 568)
    {
        X=20;
        width=270;
        height=360;
    }
    else
    {
        X=40;
        width=210;
        height=280;
    }
    self.closetView.frame=CGRectMake(X,Y,width,height);
    self.closetView.image=[UIImage imageWithContentsOfFile:self.DetailModel[5]];
    
    self.noteView=[[UITextView alloc]init];
    float noteY=self.closetView.frame.origin.y+self.closetView.frame.size.height+1;
    //NSLog(@"titlefield height %f, origin.y=%f, noteY=%f",self.titleField.frame.size.height, self.detailView.frame.origin.y, noteY);
    self.noteView.frame=CGRectMake(5, noteY, self.detailView.frame.size.width, 5);
    [self.noteView setBackgroundColor:[UIColor clearColor]];
    self.noteView.text=@"take a note";
    if ([detailNote length]!=0)
    {
        NSLog(@"I set detailnote %@", detailNote);
        [self.noteView setText:detailNote];
    }
    [self.noteView setEditable:YES];
    [self.noteView sizeToFit];
    [self.noteView setFont:[UIFont systemFontOfSize:14]];
    [self.noteView setDelegate:self];
    
    UIView *kbToolBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [kbToolBar setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"keyboard accessaory view.png"]]];
    UIButton *dismissButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    dismissButton.frame = CGRectMake(280, 5, 40, 30);
    [dismissButton setTitle:@"" forState:UIControlStateNormal];
    [kbToolBar addSubview:dismissButton];
    
    self.noteView.inputAccessoryView = kbToolBar;
    [self.detailView addSubview:self.dateField];
    [self.detailView addSubview:self.brandField];
    [self.detailView addSubview:self.priceField];
    [self.detailView addSubview:self.closetView];
    [self.detailView addSubview:self.noteView];
    
    CGRect newframe =self.noteView.frame;
    newframe.size.height=self.noteView.contentSize.height;
    NSLog(@"note content size=%f",self.noteView.contentSize.height);
    [self.noteView setFrame:newframe];
    NSLog(@"note frame height=%f",self.noteView.frame.size.height);
    
    NSLog(@"detailview frame Y=%f, frame height=%f",self.deletebutton.frame.origin.y, self.deletebutton.frame.size.height);
    [self.deletebutton addTarget:self action:@selector(closeDetail) forControlEvents:UIControlEventTouchDown];
    
    NSArray *detailData=[[NSArray alloc]initWithObjects:detailTitle,detailBrand, self.DetailModel[2], priceValue, detailNote, nil];
    [self.savebutton setCloseDetail:[self.DetailModel[6] intValue]:self.DetailModel[5]:[self.DetailModel[7] intValue]:self.DetailModel[8]:detailData];
    [self.savebutton addTarget:self action:@selector(closeAndsaveDetail:) forControlEvents:UIControlEventTouchDown];
    
    float contentHeight=self.closetView.frame.origin.y+self.closetView.frame.size.height+self.noteView.contentSize.height+1;
    NSLog(@"detailview frame Y=%f, frame height=%f",self.detailView.frame.origin.y, self.detailView.frame.size.height);
    [self.detailView setContentSize:CGSizeMake(self.detailView.frame.size.width,contentHeight)];
  
    [self.detailView setUserInteractionEnabled:YES];
    
}

- (IBAction)closeDetail
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)closeAndsaveDetail :(id)sender
{
    //update edit part
    if(isChanged)
    {
        StyleButton *button = sender;
        NSLog(@"closeAndsaveDetail update edit part, ID=%d",button.DBid);
        
        DBConnector *stairyDB = [DBConnector new];
        
        BOOL bret=[stairyDB updateClosetInfo:button.DBid:detailTitle:detailBrand:detailPrice:detailNote];
        
        NSLog(@"update closet Info %d",bret);
        
        NSNumber *indexobj=[[NSNumber alloc]initWithInt:[self.DetailModel[7] intValue]];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:indexobj , @"index", detailTitle, @"title", detailBrand, @"brand", detailNote, @"note", detailPrice, @"price", nil];
        
        [self.delegate updateCell:dict];

        
    }
   
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// UITextFieldDelefate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSLog(@"Closet page: textFieldShouldReturn");
    
    // 1: title 2: brand 3: price
    switch (textField.tag)
    {
        case 1:
        {
            detailTitle = textField.text;
            NSLog(@"update new Title=%@",detailTitle);
            isChanged=TRUE;
            break;
        }
        case 2:
        {
            detailBrand = textField.text;
            NSLog(@"update new Brand=%@",detailBrand);
            isChanged=TRUE;
            break;
            
        }
        case 3:
        {
            NSNumber *priceValue=[[NSNumber alloc]initWithInt:[textField.text intValue]];
            detailPrice = priceValue;
            NSLog(@"update new Price=%@",detailPrice);
            isChanged=TRUE;
            break;
            
        }
            
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return YES;
    
}

//UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"textViewShouldBeginEditing");
    
    if(textView.frame.origin.y > 250)
    {
        NSLog(@"raise textView");
        self.rootView.frame = CGRectMake(self.rootView.frame.origin.x, self.rootView.frame.origin.y - (textView.frame.origin.y - 160), self.rootView.frame.size.width, self.rootView.frame.size.height);
        
    }
    
    return TRUE;
}

- (void) dismissKeyboard:(UIButton*)sender
{
    detailNote = self.noteView.text;
    NSLog(@"update new note=%@",detailNote);
    isChanged=TRUE;
    
    if(self.noteView.frame.origin.y > 250)
    {
        NSLog(@"put textView to original place");
        self.rootView.frame = CGRectMake(self.rootView.frame.origin.x, self.rootView.frame.origin.y + (self.noteView.frame.origin.y - 160), self.rootView.frame.size.width, self.rootView.frame.size.height);
        
    }
    
    [self.noteView resignFirstResponder];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
