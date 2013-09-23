//
//  StyleAddDressViewController.h
//  Stylelist
//
//  Created by Splashtop on 13/7/4.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreData/CoreData.h>
#import "DBConnector.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLGeocoder.h>
#import <Foundation/NSURLRequest.h>
#import "StyleClosetViewController.h"
#import "StyleClosetTableViewController.h"

@protocol StyleAddDressDelegate <NSObject>
@optional
- (void)didCloseController:(NSDictionary*)result;
@end

@interface StyleAddDressViewController : UIViewController <UIImagePickerControllerDelegate, UIScrollViewAccessibilityDelegate, UITextFieldDelegate, UIAlertViewDelegate, UITextViewDelegate, UIScrollViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, StyleClosetTableViewDelegate>

// Delegate properties
//{
//    id<StyleAddDressDelegate> delegate;
//}
@property (weak, nonatomic) id<StyleAddDressDelegate> delegate;

// UI Properties
//iPhone
@property (weak, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UIImageView *dressImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *dressOverlayScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *dressTempletePageControl;
@property (weak, nonatomic) IBOutlet UIButton *camSrcButton;
@property (weak, nonatomic) IBOutlet UIButton *camSaveButton;
@property (weak, nonatomic) IBOutlet UIButton *camCaptureButton;
@property (weak, nonatomic) IBOutlet UIButton *camToggleButton;
@property (weak, nonatomic) IBOutlet UIButton *camFlashButton;

@property (weak, nonatomic) IBOutlet UIView *noteEditorView;
@property (weak, nonatomic) IBOutlet UITextView *noteTextEditor;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *weatherTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UIView *noteBackgroundView;

//iPad
@property (weak, nonatomic) IBOutlet UIView *iPadRootView;
@property (weak, nonatomic) IBOutlet UIImageView *iPadDressImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *iPadDressOverlayScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *iPadDressTempletePageControl;
@property (weak, nonatomic) IBOutlet UIButton *iPadCamSrcButton;
@property (weak, nonatomic) IBOutlet UIButton *iPadCamSaveButton;
@property (weak, nonatomic) IBOutlet UIButton *iPadCamCaptureButton;
@property (weak, nonatomic) IBOutlet UIButton *iPadCamToggleButton;
@property (weak, nonatomic) IBOutlet UIButton *iPadCamFlashButton;
@property (weak, nonatomic) IBOutlet UIView *iPadNoteEditorView;
@property (weak, nonatomic) IBOutlet UITextView *iPadNoteTextEditor;


// handlers
-(IBAction)dismissViewController;
-(IBAction)captureDressImage;
-(IBAction)launchCam:(id)sender;
-(IBAction)saveImage;
- (IBAction)toggleCamera;
- (IBAction)adjustFlash:(id)sender;
- (IBAction)finishNoteEditor:(id)sender;
- (IBAction)cancelNoteEditor:(id)sender;

// private functions
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
-(void)prepareTemplate;
-(void)cameraInitWithCamera: (NSInteger)Cameraposition;
-(void)cameraStartPreview;
-(void)cameraCapture;
-(void)cameraStop;
-(void)produceImage;
- (void)openColorPopupView;
-(NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count;
- (void)configureCameraFlash: (int)mode;
- (void)getWeatherInfoWithLatigude: (int)latitude andLongitude: (int)longitude;
- (void)singleTapGestureHandler:(UITapGestureRecognizer*)gesture;
- (void)configureCameraFocus: (CGPoint)focusPoint focusType: (int)focusType;

@end
