//
//  StyleAddClothViewController.h
//  Stylelist
//
//  Created by Splashtop on 13/7/18.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreData/CoreData.h>
#import "DBConnector.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLGeocoder.h>

@protocol StyleAddClothDelegate <NSObject>
@optional
- (void)didCloseController:(NSDictionary*)result;
@end

@interface StyleAddClothViewController : UIViewController <UIImagePickerControllerDelegate, UIScrollViewAccessibilityDelegate, UITextFieldDelegate, UIAlertViewDelegate, UITextViewDelegate, UIScrollViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate>

// Delegate properties
//{
//    id<StyleAddDressDelegate> delegate;
//}
@property (weak, nonatomic) id<StyleAddClothDelegate> delegate;

// UI Properties
//iPhone
@property (weak, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UIImageView *clothImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *clothOverlayScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *clothTempletePageControl;
@property (weak, nonatomic) IBOutlet UIButton *camSrcButton;
@property (weak, nonatomic) IBOutlet UIButton *camSaveButton;
@property (weak, nonatomic) IBOutlet UIButton *camCaptureButton;
@property (weak, nonatomic) IBOutlet UIButton *camToggleButton;
@property (weak, nonatomic) IBOutlet UIButton *camFlashButton;

@property (weak, nonatomic) IBOutlet UIView *noteEditorView;
@property (weak, nonatomic) IBOutlet UIView *noteBackgroundView;
@property (weak, nonatomic) IBOutlet UITextView *noteTextEditor;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *brandTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
@property (weak, nonatomic) IBOutlet UIView *selectTypeView;


//iPad
@property (weak, nonatomic) IBOutlet UIView *iPadRootView;
@property (weak, nonatomic) IBOutlet UIImageView *iPadClothImageView;
@property (weak, nonatomic) IBOutlet UIButton *iPadCamCaptureButton;
@property (weak, nonatomic) IBOutlet UIPageControl *iPadClothTempletePageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *iPadClothOverlayScrollView;
@property (weak, nonatomic) IBOutlet UIButton *iPadCamSrcButton;
@property (weak, nonatomic) IBOutlet UIButton *iPadCamSaveButton;
@property (weak, nonatomic) IBOutlet UIButton *iPadCamFlashButton;
@property (weak, nonatomic) IBOutlet UIButton *iPadCamToggleButton;
@property (weak, nonatomic) IBOutlet UIView *iPadNoteEditorView;
@property (weak, nonatomic) IBOutlet UITextView *iPadNoteTextEditor;
@property (weak, nonatomic) IBOutlet UISegmentedControl *iPadClosetSelector;


// handlers
-(IBAction)dismissViewController;
-(IBAction)captureDressImage;
-(IBAction)launchCam:(id)sender;
-(IBAction)saveImage;
- (IBAction)toggleCamera;
- (IBAction)adjustFlash:(id)sender;
- (IBAction)finishNoteEditor:(id)sender;
- (IBAction)cancelNoteEditor:(id)sender;
- (IBAction)selectCloset:(id)sender;

- (IBAction)shortTopsButton:(id)sender;
- (IBAction)longTopsButton:(id)sender;
- (IBAction)jackietButton:(id)sender;
- (IBAction)pantsButton:(id)sender;
- (IBAction)skirtButton:(id)sender;
- (IBAction)dressButton:(id)sender;
- (IBAction)accessoryButton:(id)sender;


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
- (void)singleTapGestureHandler:(UITapGestureRecognizer*)gesture;
- (void)configureCameraFocus: (CGPoint)focusPoint focusType: (int)focusType;
- (void) dismissKeyboard:(UIButton*)sender;

@end

