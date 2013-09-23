//
//  StyleAddClothViewController.m
//  Stylelist
//
//  Created by Splashtop on 13/7/18.
//  Copyright (c) 2013年 ling. All rights reserved.
//


#import "StyleAddClothViewController.h"

@interface StyleAddClothViewController ()

@end

@implementation StyleAddClothViewController
{
    BOOL isCameraInitialized;
    AVCaptureSession *captureSession;
    AVCaptureVideoPreviewLayer *previewLayer;
    AVCaptureStillImageOutput *stillImageOutput;
    AVCaptureConnection *videoConnection;
    UIView *myView;
    UITextField *CurrentTextField;
    UIImageView *OutputImageView; // 600x800
    BOOL loadImage;
    UIPopoverController *photoPopup;
    NSInteger CurrentCamera;
    NSString *brandText;
    NSString *typeText;
    NSString *noteText;
    UITextField *currentTextField;
    AVCaptureDevice *currentCamDevice;
    int currentCamFlashMode;
    BOOL isScreenRising;
    CLLocationManager *locationManager;
    NSString *currentLocation;
    BOOL isFromReturn;
    BOOL isFromDismissButton;
    
    //text on the photo
    NSInteger photoType;
    NSMutableArray *photoTypeArray;
    
    NSString *photoBrand;
    NSMutableArray *photoBrandArray;
    
    NSString *photoTime;
    NSMutableArray *photoTimeArray;
    
    NSString *photoLocation;
    NSMutableArray *photoLocationArray;
    
    NSString *photoTitle;
    NSMutableArray *photoTitleArray;
    
    NSString *photoPrice;
    NSMutableArray *photoPriceArray;
    
    NSString *photoNote;
    NSMutableArray *photoNoteArray;
    
    UIColor *photoTextColor;
    NSInteger selectedCloset;
    //NSInteger templateNumber;
    //NSMutableDictionary *plistDict;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    // Init output frame with fix size, for both iPad and iPhone
    OutputImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 600, 800)];
    
    photoTextColor = [UIColor colorWithWhite:200 alpha:1];
    
    //init location manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    currentLocation = @"";
    //[objMyLocationManager setDelegate:self];
    
    //1 km
    locationManager.distanceFilter = 1000;
    
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    [locationManager startUpdatingLocation];
    
    //prepare detail dialog
    [self.noteBackgroundView.layer setCornerRadius:5.0f];
    [self.noteTextEditor.layer setBorderWidth:1.0f];
    [self.noteTextEditor setDelegate:self];
    
    [self.typeTextField setDelegate:self];
    
    [self.titleTextField setDelegate:self];
    self.titleTextField.tag = 3;
    
    [self.priceTextField setDelegate:self];
    self.priceTextField.tag = 6;
    self.priceTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.locationTextField setDelegate:self];
    self.locationTextField.tag = 2;
    
    [self.brandTextField setDelegate:self];
    self.brandTextField.tag = 1;
    [self.dateTextField setDelegate:self];
    self.dateTextField.tag = 4;

    
    
    // Prepare overlay and page controller
    currentCamFlashMode = 0;
    loadImage = NO;
    isScreenRising = NO;
    isFromReturn = NO;
    selectedCloset = 1;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.iPadCamSrcButton.hidden = YES;
        self.iPadCamSaveButton.hidden = YES;
        self.iPadCamCaptureButton.hidden = YES;
        self.iPadCamToggleButton.hidden = YES;
        self.iPadCamFlashButton.hidden = YES;
    }
    else
    {
        self.camSrcButton.hidden = YES;
        self.camSaveButton.hidden = YES;
        self.camCaptureButton.hidden = YES;
        self.camToggleButton.hidden = YES;
        self.camFlashButton.hidden = YES;
    }
    // Why the frame size returns 0,0？
    /*
     CGFloat width, height;
     width = self.DressOverlayScrollView.frame.size.width;
     height = self.DressOverlayScrollView.frame.size.height;
     NSLog(@"width: %f, height: %f", self.DressOverlayScrollView.frame.size.width, self.DressOverlayScrollView.frame.size.height);
     */
    // use dedicate size first to ignore 0,0 issue
    
    // use camera as image source
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.iPadCamSrcButton.hidden = YES;
        self.iPadCamSaveButton.hidden = YES;
        self.iPadCamCaptureButton.hidden = NO;
        self.iPadCamToggleButton.hidden = NO;
        self.iPadCamFlashButton.hidden = NO;
    }
    else
    {
        self.camSrcButton.hidden = YES;
        self.camSaveButton.hidden = YES;
        self.camCaptureButton.hidden = NO;
        self.camToggleButton.hidden = NO;
        self.camFlashButton.hidden = NO;
    }
    
    CurrentCamera = AVCaptureDevicePositionBack;
    [self cameraInitWithCamera:CurrentCamera];
    [self cameraStartPreview];
    
    loadImage = YES;
    
    // prepare photoTime
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    photoTime = [dateFormatter stringFromDate:[NSDate date]];
    
    // prepare template content
    [self prepareTemplate];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureHandler:)];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self.iPadClothOverlayScrollView addGestureRecognizer:singleTap];
    }
    else
    {
         [self.clothOverlayScrollView addGestureRecognizer:singleTap];
    }
    
    // prepare keyboard toolbar for save image
    UIView *kbToolBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    //[kbToolBar setBackgroundColor:[UIColor colorWithRed:0 green:100 blue:100 alpha:1]];
    [kbToolBar setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"keyboard accessaory view with color.png"]]];
    UIButton *dismissButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    //[colorButton setTitle:@"Font" forState:UIControlStateNormal];
    //colorButton.titleLabel.text = @"Font";
    dismissButton.frame = CGRectMake(280, 5, 40, 30);
    [dismissButton setTitle:@"" forState:UIControlStateNormal];
    
    [kbToolBar addSubview:dismissButton];

    self.noteTextEditor.inputAccessoryView = kbToolBar;

    
    UIView *kbTextFieldToolBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    //[kbToolBar setBackgroundColor:[UIColor colorWithRed:0 green:100 blue:100 alpha:1]];
    [kbTextFieldToolBar setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"keyboard accessaory view with color.png"]]];
    UIButton *dismisstextFieldButton= [UIButton buttonWithType:UIButtonTypeCustom];
    
    [dismisstextFieldButton addTarget:self action:@selector(dismissTextFieldKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [dismisstextFieldButton setTitle:@"" forState:UIControlStateNormal];
    //dismissButton.titleLabel.text = @"Dismiss";
    dismisstextFieldButton.frame = CGRectMake(280, 5, 40, 30);
    dismisstextFieldButton.backgroundColor = [UIColor colorWithRed:200 green:200 blue:200 alpha:0];
    [kbTextFieldToolBar addSubview:dismisstextFieldButton];
    
    self.titleTextField.inputAccessoryView = kbTextFieldToolBar;
    self.dateTextField.inputAccessoryView = kbTextFieldToolBar;
    self.brandTextField.inputAccessoryView = kbTextFieldToolBar;
    self.priceTextField.inputAccessoryView = kbTextFieldToolBar;
    self.locationTextField.inputAccessoryView = kbTextFieldToolBar;

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%id", buttonIndex);
    
    if(buttonIndex == 0)
    {
        if(loadImage == NO)
        {
            [self dismissViewControllerAnimated:YES completion:^{}];
        }
    }
    else if(buttonIndex == 1)
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.iPadCamSrcButton.hidden = YES;
            self.iPadCamSaveButton.hidden = YES;
            self.iPadCamCaptureButton.hidden = NO;
            self.iPadCamToggleButton.hidden = NO;
            self.iPadCamFlashButton.hidden = NO;
        }
        else
        {
            self.camSrcButton.hidden = YES;
            self.camSaveButton.hidden = YES;
            self.camCaptureButton.hidden = NO;
            self.camToggleButton.hidden = NO;
            self.camFlashButton.hidden = NO;
        }
        
        CurrentCamera = AVCaptureDevicePositionBack;
        [self cameraInitWithCamera:CurrentCamera];
        [self cameraStartPreview];
        
        loadImage = YES;
    }
    else if(buttonIndex == 2)
        
    {
        // open camera roll for image selection
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            UIImagePickerController *imagePicker = [UIImagePickerController new];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSArray *mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeImage, nil];
            imagePicker.mediaTypes = mediaTypes;
            imagePicker.allowsEditing = NO;
            
            //UIPopoverController
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                
                photoPopup = [[UIPopoverController alloc]initWithContentViewController: imagePicker];
                
                CGRect tempRec;
                CGPoint myPoint;
                myPoint.x = 0;
                myPoint.y = 0;
                CGSize mySize;
                mySize.height = 0;
                mySize.width = 0;
                tempRec.origin = myPoint;
                tempRec.size = mySize;
                
                [photoPopup presentPopoverFromRect:tempRec inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                [self presentViewController:imagePicker animated:YES completion:NULL];
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)captureDressImage
{
    [self cameraCapture];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.iPadCamSrcButton.hidden = NO;
        self.iPadCamSaveButton.hidden = NO;
        self.iPadCamCaptureButton.hidden = YES;
        self.iPadCamToggleButton.hidden = YES;
        self.iPadCamFlashButton.hidden = YES;
    }
    else
    {
        self.camSrcButton.hidden = NO;
        self.camSaveButton.hidden = NO;
        self.camCaptureButton.hidden = YES;
        self.camToggleButton.hidden = YES;
        self.camFlashButton.hidden = YES;
    }
}

- (IBAction)launchCam:(id)sender
{
    /*
    //restart camera preview
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image Source" message:@"Choose Your Image Source" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Camera", @"Camera Roll", nil];
    
    [alert show];
     */
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.iPadCamSrcButton.hidden = YES;
        self.iPadCamSaveButton.hidden = YES;
        self.iPadCamCaptureButton.hidden = NO;
        self.iPadCamToggleButton.hidden = NO;
        self.iPadCamFlashButton.hidden = NO;
    }
    else
    {
        self.camSrcButton.hidden = YES;
        self.camSaveButton.hidden = YES;
        self.camCaptureButton.hidden = NO;
        self.camToggleButton.hidden = NO;
        self.camFlashButton.hidden = NO;
    }
    
    CurrentCamera = AVCaptureDevicePositionBack;
    [self cameraInitWithCamera:CurrentCamera];
    [self cameraStartPreview];
    
    loadImage = YES;
}

- (IBAction)saveImage
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.iPadCamSrcButton.hidden = YES;
        self.iPadCamSaveButton.hidden = YES;
        self.iPadCamCaptureButton.hidden = YES;
        self.iPadCamToggleButton.hidden = YES;
        self.iPadCamFlashButton.hidden = YES;
        
        self.iPadNoteEditorView.hidden = NO;
    }
    else
    {
        if(self.typeTextField.text == nil)
        {
            self.typeTextField.text = @"Short Tops";
            photoType = 0;
        }
        self.titleTextField.text = photoTitle;
        self.priceTextField.text = photoPrice;
        self.locationTextField.text = photoLocation;
        self.brandTextField.text = photoBrand;
        self.dateTextField.text = photoTime;
        
        self.camSrcButton.hidden = YES;
        self.camSaveButton.hidden = YES;
        self.camCaptureButton.hidden = YES;
        self.camToggleButton.hidden = YES;
        self.camFlashButton.hidden = YES;
        
        self.noteEditorView.hidden = NO;
    }
}

- (IBAction)toggleCamera
{
    [previewLayer removeFromSuperlayer];
    [myView removeFromSuperview];
    
    [captureSession stopRunning];
    [self cameraStop];
    
    if(CurrentCamera == AVCaptureDevicePositionBack)
    {
        CurrentCamera = AVCaptureDevicePositionFront;
    }
    else
    {
        CurrentCamera = AVCaptureDevicePositionBack;
    }
    
    [self cameraInitWithCamera:CurrentCamera];
    [self cameraStartPreview];
}

- (IBAction)adjustFlash:(id)sender
{
    currentCamFlashMode = (currentCamFlashMode + 1) % 3;
    NSLog(@"flash:%i", currentCamFlashMode);
    
    if(currentCamFlashMode == 1)
    {
        [self.camFlashButton setImage:[UIImage imageNamed:@"flash button on.png"] forState:UIControlStateNormal];
    }
    else if(currentCamFlashMode == 2)
    {
        [self.camFlashButton setImage:[UIImage imageNamed:@"flash button auto.png"] forState:UIControlStateNormal];        
    }
    else
    {
        [self.camFlashButton setImage:[UIImage imageNamed:@"flash button off.png"] forState:UIControlStateNormal];
    }
    
    [self configureCameraFlash:currentCamFlashMode];
}

- (IBAction)finishNoteEditor:(id)sender
{
    NSString *ClosetImageName = [[NSString alloc]initWithFormat: @"closet%f.jpg", [[NSDate date] timeIntervalSince1970]];
    NSString *timelineImageName = [[NSString alloc]initWithFormat: @"timeline%f.jpg", [[NSDate date] timeIntervalSince1970]];
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *closetPreviewDirectory = [documentPath stringByAppendingPathComponent:@"closetPreview"];
    NSString *closetPreviewPath = [closetPreviewDirectory stringByAppendingPathComponent:ClosetImageName];
    NSString *closetDirectory = [documentPath stringByAppendingPathComponent:@"closet"];
    NSString *closetPath = [closetDirectory stringByAppendingPathComponent:ClosetImageName];
    NSString *timelineDirectory = [documentPath stringByAppendingPathComponent:@"timeline"];
    NSString *timelinePath = [timelineDirectory stringByAppendingPathComponent:timelineImageName];
    
    // save OutputImageView.image to closet first;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:closetDirectory] == NO)
    {
        NSLog(@"create closet directory!");
        if (![fileManager createDirectoryAtPath:closetDirectory withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"Create directory error: %@", error);
            
            return;
        }
    }
    
    if([fileManager fileExistsAtPath:closetPreviewDirectory] == NO)
    {
        NSLog(@"create closet directory!");
        if (![fileManager createDirectoryAtPath:closetPreviewDirectory withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"Create directory error: %@", error);
            
            return;
        }
    }
    
    // now resize the image to 300x400 points
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(300.0, 400.0), NO, 0.0);
    [OutputImageView.image drawInRect:CGRectMake(0, 0, 300, 400)];
    OutputImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSLog(@"Save closet image now! Image size: %f, %f", OutputImageView.image.size.width, OutputImageView.image.size.height);
    
    NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(OutputImageView.image, 1)];
    if(NO == [imageData writeToFile:closetPath atomically:NO])
    {
        NSLog(@"save file fail");
        return;
    }

    // now resize the image to 300x400 points
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(90.0, 120.0), NO, 0.0);
    [OutputImageView.image drawInRect:CGRectMake(0, 0, 90, 120)];
    UIImage *previewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSLog(@"Save closet preview image now! Image size: %f, %f", previewImage.size.width, OutputImageView.image.size.height);
    
    imageData = [NSData dataWithData:UIImageJPEGRepresentation(previewImage, 1)];
    if(NO == [imageData writeToFile:closetPreviewPath atomically:NO])
    {
        NSLog(@"save file fail");
        return;
    }
    
    // Now deal with image effect merge
    [self produceImage];
    
    // now, save new image to timeline folder
    // check if the directory exists? if no, create!
    if([fileManager fileExistsAtPath:timelineDirectory] == NO)
    {
        NSLog(@"create timeline directory!");
        if (![fileManager createDirectoryAtPath:timelineDirectory withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"Create directory error: %@", error);
            
            return;
        }
    }
    
    
    NSLog(@"Save image to timeline now!");
    
    imageData = [NSData dataWithData:UIImageJPEGRepresentation(OutputImageView.image, 1)];
    
    if(NO == [imageData writeToFile:timelinePath atomically:NO])
    {
        NSLog(@"save file fail");
    }
    else
    {
        NSLog(@"Update closet and timeline DB");
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            photoNote = self.iPadNoteTextEditor.text;
        }
        else
        {
            photoNote = self.noteTextEditor.text;
        }
        
        //save to DB
        DBConnector *stairyDB = [DBConnector new];
        NSDictionary *dict=[stairyDB insertClosetRecordofImagePath:ClosetImageName Price:[photoPrice intValue] Type:selectedCloset Title:photoTitle Note:photoNote Brand:photoBrand Size:@"testSize" Closet:photoType timelineImagePath: timelineImageName];
        NSNumber *timelineIDobj=[dict objectForKey:@"timelineID"];
        int timelineID=[timelineIDobj intValue];
        if (timelineID!=-1)
        {
            NSLog(@"check delegate! %d",timelineID);
            
            // notify delegate that image is saved!
            if([self.delegate respondsToSelector:@selector(didCloseController:)])
            {
                NSLog(@"Call delegate!");
                
                NSString *timelinePath = [timelineDirectory stringByAppendingPathComponent:timelineImageName];
                //NSNumber *timelineIDobj=[[NSNumber alloc]initWithInt:timelineID];
                NSString *createtime=[dict objectForKey:@"date"];
                NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:timelinePath , @"imagepath", timelineIDobj, @"DBid", createtime, @"date", photoNote, @"note", nil];
                
                [self.delegate didCloseController:dict];
            }
            else
            {
                NSLog(@"delegate is not implemented");
            }
            //dismiss this view.
            [self dismissViewControllerAnimated:YES completion:^{}];
            
        }
        else
        {
            NSLog(@"Saving image fails, time to debug");
        }
    }
}

- (IBAction)cancelNoteEditor:(id)sender
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.iPadCamSrcButton.hidden = NO;
        self.iPadCamSaveButton.hidden = NO;
        self.iPadCamCaptureButton.hidden = YES;
        self.iPadCamToggleButton.hidden = YES;
        self.iPadCamFlashButton.hidden = YES;
        self.iPadNoteEditorView.hidden = YES;
    }
    else
    {
        self.camSrcButton.hidden = NO;
        self.camSaveButton.hidden = NO;
        self.camCaptureButton.hidden = YES;
        self.camToggleButton.hidden = YES;
        self.camFlashButton.hidden = YES;
        self.noteEditorView.hidden = YES;
    }
}

- (IBAction)selectCloset:(id)sender
{
    UISegmentedControl *segnentedCloset = (UISegmentedControl*) sender;
    
    selectedCloset = segnentedCloset.selectedSegmentIndex;
}

- (IBAction)shortTopsButton:(id)sender
{
    self.typeTextField.text = @"Short Tops";
    self.selectTypeView.hidden = YES;
    photoType = 0;
}

- (IBAction)longTopsButton:(id)sender
{
    self.typeTextField.text = @"Long Tops";
    self.selectTypeView.hidden = YES;
    photoType = 1;
}

- (IBAction)jackietButton:(id)sender
{
    self.typeTextField.text = @"Jacket";
    self.selectTypeView.hidden = YES;
    photoType = 2;
}

- (IBAction)pantsButton:(id)sender
{
    self.typeTextField.text = @"Pants";
    self.selectTypeView.hidden = YES;
    photoType = 3;
}

- (IBAction)skirtButton:(id)sender
{
    self.typeTextField.text = @"Skirt";
    self.selectTypeView.hidden = YES;
    photoType = 4;
}

- (IBAction)dressButton:(id)sender
{
    self.typeTextField.text = @"Dress";
    self.selectTypeView.hidden = YES;
    photoType = 5;
}

- (IBAction)accessoryButton:(id)sender
{
    self.typeTextField.text = @"Accessory";
    self.selectTypeView.hidden = YES;
    photoType = 6;
}

- (void)singleTapGestureHandler:(UITapGestureRecognizer*)gesture
{
    // check whether camera is running
    if(isCameraInitialized == YES)
    {
        CGPoint touchPoint;
        float pageWidth, pageHeight;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            touchPoint = [gesture locationInView:self.iPadClothOverlayScrollView];
            pageWidth = 600.0f;
            pageHeight = 800.0f;
        }
        else
        {
            touchPoint = [gesture locationInView:self.clothOverlayScrollView];
            pageWidth = 300.0f;
            pageHeight = 400.0f;
        }
    
        NSLog(@"singe tap on x:%f, y:%f", touchPoint.x, touchPoint.y);
    
        float x = touchPoint.x - self.clothTempletePageControl.currentPage * pageWidth;
        float y = touchPoint.y;

        
        [self configureCameraFocus:CGPointMake((x / pageWidth), (y/pageHeight)) focusType:0];
        
        //draw focus animation now
        UIImageView *cameraFocusAnimation = [[UIImageView alloc]initWithFrame:CGRectMake(touchPoint.x - 50, touchPoint.y - 50, 100, 100)];
        [cameraFocusAnimation setImage:[UIImage imageNamed:@""]];
        cameraFocusAnimation.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"camera focus 100.png"], [UIImage imageNamed:@"camera focus 80.png"],[UIImage imageNamed:@"camer focus 60.png"],[UIImage imageNamed:@"camera focus 40.png"], nil];
        
        cameraFocusAnimation.animationDuration = 0.50;
        cameraFocusAnimation.animationRepeatCount = 2;

        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [self.iPadClothOverlayScrollView addSubview:cameraFocusAnimation];
        }
        else
        {
            [self.clothOverlayScrollView addSubview:cameraFocusAnimation];
        }
        
        [cameraFocusAnimation startAnimating];
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated: YES completion:NULL];
    
    if([mediaType isEqualToString : (NSString*)kUTTypeImage])
    {
        UIImage *myImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [self.iPadClothImageView setImage:myImage];
        }
        else
        {
            [self.clothImageView setImage:myImage];
        }
        [OutputImageView setImage:myImage];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.iPadCamSrcButton.hidden = NO;
            self.iPadCamSaveButton.hidden = NO;
            self.iPadCamCaptureButton.hidden = YES;
            self.iPadCamToggleButton.hidden = YES;
            self.iPadCamFlashButton.hidden = YES;
        }
        else
        {
            self.camSrcButton.hidden = NO;
            self.camSaveButton.hidden = NO;
            self.camCaptureButton.hidden = YES;
            self.camToggleButton.hidden = YES;
            self.camFlashButton.hidden = YES;
        }
        
        loadImage = YES;
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if(loadImage == NO)
    {
        [self dismissViewControllerAnimated:NO completion:
         ^{
             [self dismissViewControllerAnimated:YES completion:^{}];
             
         }];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}


// UIScrollViewAccessibilityDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"change page control");
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.iPadClothTempletePageControl.currentPage = page;
    }
    else
    {
        self.clothTempletePageControl.currentPage = page;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(isFromReturn == NO && isFromDismissButton == NO)
    {
        NSLog(@"keep focus here!");
        [textField becomeFirstResponder];
        
        return NO;
    }
    
    isFromReturn = NO;
    isFromDismissButton = NO;
    
    return YES;
}

// UITextFieldDelefate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"dismiss keyboard!");
    isFromReturn = YES;
    
    if(textField.frame.origin.y > 250)
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.iPadRootView.frame = CGRectMake(self.iPadRootView.frame.origin.x, self.iPadRootView.frame.origin.y + (textField.frame.origin.y - 200), self.iPadRootView.frame.size.width, self.iPadRootView.frame.size.height);
        }
        else
        {
            self.rootView.frame = CGRectMake(self.rootView.frame.origin.x, self.rootView.frame.origin.y + (textField.frame.origin.y - 200), self.rootView.frame.size.width, self.rootView.frame.size.height);
            
        }
    }

    
    [textField resignFirstResponder];
    
    // 1: Brand 2: position 3: title 4:time 5:note 6: price
    switch (textField.tag)
    {
        case 1:
        {
            photoBrand = textField.text;
            
            //update Brand
            for (UITextField *brandTextField in photoBrandArray)
            {
                brandTextField.text = photoBrand;
            }
            
            break;
        }
        case 2:
        {
            photoLocation = textField.text;
            
            //update location
            for (UITextField *locationTextField in photoLocationArray)
            {
                locationTextField.text = photoLocation;
            }
            
            break;
        }
        case 3:
        {
            photoTitle = textField.text;
            
            //update title
            for (UITextField *titleTextField in photoTitleArray)
            {
                titleTextField.text = photoTitle;
            }
            
            break;
        }
        case 4:
        {
            photoTime = textField.text;
            
            //update time
            for (UITextField *timeTextField in photoTimeArray)
            {
                timeTextField.text = photoTime;
            }
            
            break;
        }
        case 5:
        {
            photoNote = textField.text;
            
            //update location
            for (UITextField *noteTextField in photoNoteArray)
            {
                noteTextField.text = photoNote;
            }
            
            break;
        }
        case 6:
        {
            photoPrice = textField.text;
            
            //update price
            for (UITextField *priceTextField in photoPriceArray)
            {
                priceTextField.text = photoPrice;
            }
            
            break;
        }
        default:
            break;
    }
    
    isScreenRising = NO;
    self.clothOverlayScrollView.userInteractionEnabled = YES;
    return YES;
}



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"raise root View if necessary");
    
    if(textField == self.typeTextField)
    {
        self.selectTypeView.hidden = NO;
        return NO;
    }
    
    if((textField.frame.origin.y > 250) && (isScreenRising == NO))
    {
        isScreenRising = YES;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.iPadRootView.frame = CGRectMake(self.iPadRootView.frame.origin.x, self.iPadRootView.frame.origin.y - (textField.frame.origin.y - 200), self.iPadRootView.frame.size.width, self.iPadRootView.frame.size.height);
        }
        else
        {
            self.rootView.frame = CGRectMake(self.rootView.frame.origin.x, self.rootView.frame.origin.y - (textField.frame.origin.y - 200), self.rootView.frame.size.width, self.rootView.frame.size.height);
        }
    }
    
    currentTextField = textField;
    self.clothOverlayScrollView.userInteractionEnabled = NO;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(isFromDismissButton == NO)
    {
        NSLog(@"keep focus here!");
        [textView becomeFirstResponder];

        return NO;
    }
    isFromDismissButton = NO;
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"just put down root View");
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.iPadRootView.frame = CGRectMake(self.iPadRootView.frame.origin.x, self.iPadRootView.frame.origin.y + (textView.frame.origin.y - 200), self.iPadRootView.frame.size.width, self.iPadRootView.frame.size.height);
    }
    else
    {
        self.rootView.frame = CGRectMake(self.rootView.frame.origin.x, self.rootView.frame.origin.y + 85, self.rootView.frame.size.width, self.rootView.frame.size.height);
            
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"just raise root View");
        
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.iPadRootView.frame = CGRectMake(self.iPadRootView.frame.origin.x, self.iPadRootView.frame.origin.y - (textView.frame.origin.y - 200), self.iPadRootView.frame.size.width, self.iPadRootView.frame.size.height);
    }
    else
    {
        self.rootView.frame = CGRectMake(self.rootView.frame.origin.x, self.rootView.frame.origin.y - 85, self.rootView.frame.size.width, self.rootView.frame.size.height);
    }
    
    return YES;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:locations[0] completionHandler:^(NSArray *placemarks, NSError *error)
     {
         self.clothOverlayScrollView.userInteractionEnabled = NO;
         
         for (CLPlacemark * placemark in placemarks)
         {
             //currentLocation = [placemark locality];
             NSLog(@"%@", [placemark locality]);
             photoLocation = [[NSString alloc]initWithFormat: @"%@, %@", [placemark locality], [placemark country]];
             
             //update location
             for (UITextField *locationTextField in photoLocationArray)
             {
                 locationTextField.text = photoLocation;
             }
             
             [locationManager stopUpdatingLocation];
         }
         
         self.clothOverlayScrollView.userInteractionEnabled = YES;
     }];
    
}

// private functions
- (void)prepareTemplate
{
    CGFloat templateFrameWidth, templateFrameHeight, templateRate;
    //width = self.DressOverlayScrollView.frame.size.width;
    //height = self.DressOverlayScrollView.frame.size.height;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        templateFrameWidth = 600.0f;
        templateFrameHeight = 800.0f;
        templateRate = 2;
    }
    else
    {
        templateFrameWidth = 300.0f;
        templateFrameHeight = 400.0f;
        templateRate = 1;
    }
    
    // read plist
    NSString *defaultPlistPath = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"StyleClothTemplate.plist"];
    NSLog(@"%@", defaultPlistPath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *plistDict;
    if ([fileManager fileExistsAtPath: defaultPlistPath]) //檢查檔案是否存在
    {
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:defaultPlistPath];
    }
    else
    {
        NSLog(@"No Plist, time to debug");
    }
    
    NSInteger templateNumber = [[plistDict objectForKey:@"templateNumber"] integerValue];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self.iPadClothTempletePageControl setNumberOfPages:templateNumber];
        [self.iPadClothTempletePageControl setCurrentPage:0];
        
        // prepare scroll view
        [self.iPadClothOverlayScrollView setPagingEnabled:YES];
        [self.iPadClothOverlayScrollView setShowsHorizontalScrollIndicator:NO];
        [self.iPadClothOverlayScrollView setShowsVerticalScrollIndicator:NO];
        [self.iPadClothOverlayScrollView setScrollsToTop:NO];
        [self.iPadClothOverlayScrollView setDelegate:self];
        
        //[self.iPadClothOverlayScrollView setFrame:CGRectMake(84, 52, 600, 800)];
        [self.iPadClothOverlayScrollView setContentSize:CGSizeMake(templateFrameWidth * templateNumber, templateFrameHeight)];
    }
    else
    {
        [self.clothTempletePageControl setNumberOfPages:templateNumber];
        [self.clothTempletePageControl setCurrentPage:0];
        
        // prepare scroll view
        [self.clothOverlayScrollView setPagingEnabled:YES];
        [self.clothOverlayScrollView setShowsHorizontalScrollIndicator:NO];
        [self.clothOverlayScrollView setShowsVerticalScrollIndicator:NO];
        [self.clothOverlayScrollView setScrollsToTop:NO];
        [self.clothOverlayScrollView setDelegate:self];
        
        //[self.clothOverlayScrollView setFrame:CGRectMake(10, 10, 300, 400)];
        [self.clothOverlayScrollView setContentSize:CGSizeMake(templateFrameWidth * templateNumber, templateFrameHeight)];
    }
    
    NSLog(@"prepare template");
    //now prepare views for template
    //CGRect frame = CGRectMake(width * TemplateNumber, 0, width, height);
    
    
    // prepare Toolbar on keyboard
    UIView *toolbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    //[toolbar setBackgroundColor:[UIColor colorWithRed:0 green:100 blue:100 alpha:1]];
    [toolbar setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"keyboard accessaory view with color.png"]]];

    int intColorsAmount = 5;
    
    UIScrollView *colorScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 5, (self.view.frame.size.width - 50), 30)];
    
    // prepare color
    for (int i = 0; i<intColorsAmount; i++)
    {
        UIButton *colorButton= [UIButton buttonWithType:UIButtonTypeCustom];
        [colorButton addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
        colorButton.tag = i;
        //[colorButton setTitle:@"Font" forState:UIControlStateNormal];
        //colorButton.titleLabel.text = @"Font";
        colorButton.frame = CGRectMake((50 * i), 5, 40, 30);
        switch (i)
        {
            case 0:
            {
                [colorButton setTitle:@"font" forState:UIControlStateNormal];
                [colorButton setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
                [colorButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
                break;
            }
            case 1:
            {
                [colorButton setTitle:@"font" forState:UIControlStateNormal];
                [colorButton setTitleColor:[UIColor colorWithRed:255 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
                [colorButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];

                break;
            }
            case 2:
            {
                [colorButton setTitle:@"font" forState:UIControlStateNormal];
                [colorButton setTitleColor:[UIColor colorWithRed:0 green:255 blue:0 alpha:1] forState:UIControlStateNormal];
                [colorButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];

                break;
            }
            case 3:
            {
                [colorButton setTitle:@"font" forState:UIControlStateNormal];
                [colorButton setTitleColor:[UIColor colorWithRed:0 green:0 blue:255 alpha:1] forState:UIControlStateNormal];
                [colorButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];

                break;
            }
            case 4:
            {
                [colorButton setTitle:@"font" forState:UIControlStateNormal];
                [colorButton setTitleColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:1] forState:UIControlStateNormal];
                [colorButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];

                break;
            }
            default:
                break;
        }

        [colorScrollView addSubview:colorButton];
    }
    [colorScrollView setContentSize:CGSizeMake((50 * intColorsAmount), 30)];

    /*
    int intFontsAmount = 10;
    
    UIScrollView *fontScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(50, 5, (self.view.frame.size.width - 50), 30)];
    
    // prepare font
    for (int i=0; i<intFontsAmount; i++)
    {
        UIButton *fontButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [fontButton addTarget:self action:@selector(selectFont:) forControlEvents:UIControlEventTouchUpInside];
        fontButton.tag = i;
        [fontButton setTitle:@"Font" forState:UIControlStateNormal];
        fontButton.titleLabel.text = @"Font";
        fontButton.frame = CGRectMake((50 * i), 0, 45, 30);
        fontButton.backgroundColor = [UIColor colorWithRed:(10 * i) green:(10 * i) blue:(10 * i) alpha:1];
        [fontScrollView addSubview:fontButton];
    }
    [fontScrollView setContentSize:CGSizeMake((50 * intFontsAmount), 30)];
    */
    //[fontScrollView setContentSize:CGSizeMake(intFontsAmount * intFontButtonLength, 40)];
    
    UIButton *dismissButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton addTarget:self action:@selector(dismissTextFieldKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [dismissButton setTitle:@"" forState:UIControlStateNormal];
    //dismissButton.titleLabel.text = @"Dismiss";
    dismissButton.frame = CGRectMake(280, 5, 40, 30);
    dismissButton.backgroundColor = [UIColor colorWithRed:200 green:200 blue:200 alpha:0];
    
    
    [toolbar addSubview:dismissButton];
    //[toolbar addSubview:fontScrollView];
    [toolbar addSubview:colorScrollView];
    // init template object array
    photoTitleArray = [[NSMutableArray alloc]init];
    photoBrandArray = [[NSMutableArray alloc]init];
    photoNoteArray = [[NSMutableArray alloc]init];
    photoLocationArray = [[NSMutableArray alloc]init];
    photoTimeArray = [[NSMutableArray alloc]init];
    photoPriceArray = [[NSMutableArray alloc]init];
    photoTypeArray = [[NSMutableArray alloc]init];
    
    // prepare to draw template from plist
    for(NSInteger i = 0; i < templateNumber; i++)
    {
        NSString *objectkey = [[NSString alloc]initWithFormat: @"template%i", i];
        
        NSLog(@"objectkey:%@", objectkey);
        
        
        // Get template from plist
        NSMutableDictionary *plistTemplateDict = [plistDict objectForKey:objectkey];
        
        // now prepare view
        CGRect frame = CGRectMake(templateFrameWidth * i, 0, templateFrameWidth, templateFrameHeight);
        UIView *templateView = [[UIView alloc]initWithFrame:frame];
        
        
        NSInteger stringX, stringY, stringWidth, stringHeight, stringSize, stringAlignment;
        NSMutableDictionary *plistphotoDict;
        
        
        // get frame path
        objectkey = [[NSString alloc]initWithFormat: @"photoFramePath"];
        NSString *framePath = [plistTemplateDict objectForKey:objectkey];
        UIImageView *frameImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, templateFrameWidth, templateFrameHeight)];
        [frameImage setImage:[UIImage imageNamed:framePath]];
        [templateView addSubview:frameImage];
        
        // get Brand info from plist
        objectkey = [[NSString alloc]initWithFormat: @"photoBrand"];
        plistphotoDict = [plistTemplateDict objectForKey:objectkey];
        if (plistphotoDict != nil)
        {
            stringX = [[plistphotoDict objectForKey:@"x"]integerValue] * templateRate;
            stringY = [[plistphotoDict objectForKey:@"y"]integerValue] * templateRate;
            stringWidth = [[plistphotoDict objectForKey:@"width"]integerValue] * templateRate;
            stringHeight = [[plistphotoDict objectForKey:@"height"]integerValue] * templateRate;
            stringSize = [[plistphotoDict objectForKey:@"fontSize"]integerValue] * templateRate;
            stringAlignment = [[plistphotoDict objectForKey:@"alignment"]integerValue]; // 0: left, 1 center, 2 right
            
            // draw Brand textfield
            UITextField *brand = [[UITextField alloc] initWithFrame:CGRectMake(stringX, stringY, stringWidth, stringHeight)];
            brand.text = @"No Brand";
            photoBrand = @"No Brand";
            [brand setDelegate:self];
            [templateView addSubview:brand];
            brand.inputAccessoryView = toolbar;
            [brand setFont:[UIFont fontWithName:@"Times" size:stringSize]];
            [brand setTextColor:[UIColor colorWithWhite:200 alpha:1]];
            brand.tag = 1; // 1: weather 2: position 3: title 4:time 5:note
            
            switch (stringAlignment)
            {
                case 0:
                    
                    [brand setTextAlignment:NSTextAlignmentLeft];
                    break;
                    
                case 1:
                    
                    [brand setTextAlignment:NSTextAlignmentCenter];
                    break;
                    
                case 2:
                    
                    [brand setTextAlignment:NSTextAlignmentRight];
                    break;
                    
                default:
                    [brand setTextAlignment:NSTextAlignmentLeft];
                    break;
            }
            
            [photoBrandArray addObject:brand];
        }
        
        // get title info from plist
        objectkey = [[NSString alloc]initWithFormat: @"photoTitle"];
        plistphotoDict = [plistTemplateDict objectForKey:objectkey];
        if (plistphotoDict != nil)
        {
            stringX = [[plistphotoDict objectForKey:@"x"]integerValue] * templateRate;
            stringY = [[plistphotoDict objectForKey:@"y"]integerValue] * templateRate;
            stringWidth = [[plistphotoDict objectForKey:@"width"]integerValue] * templateRate;
            stringHeight = [[plistphotoDict objectForKey:@"height"]integerValue] * templateRate;
            stringSize = [[plistphotoDict objectForKey:@"fontSize"]integerValue] * templateRate;
            stringAlignment = [[plistphotoDict objectForKey:@"alignment"]integerValue]; // 0: left, 1 center, 2 right
            
            // draw weather textfield
            UITextField *title = [[UITextField alloc] initWithFrame:CGRectMake(stringX, stringY, stringWidth, stringHeight)];
            title.text = @"My Style!";
            photoTitle = @"My Style!";
            [title setDelegate:self];
            [templateView addSubview:title];
            title.inputAccessoryView = toolbar;
            [title setFont:[UIFont fontWithName:@"Times" size:stringSize]];
            [title setTextColor:[UIColor colorWithWhite:200 alpha:1]];
            title.tag = 3; // 1: weather 2: position 3: title 4:time 5:note
            
            switch (stringAlignment)
            {
                case 0:
                    
                    [title setTextAlignment:NSTextAlignmentLeft];
                    break;
                    
                case 1:
                    
                    [title setTextAlignment:NSTextAlignmentCenter];
                    break;
                    
                case 2:
                    
                    [title setTextAlignment:NSTextAlignmentRight];
                    break;
                    
                default:
                    [title setTextAlignment:NSTextAlignmentLeft];
                    break;
            }
            
            [photoTitleArray addObject:title];
        }
        
        // get time info from plist
        objectkey = [[NSString alloc]initWithFormat: @"photoTime"];
        plistphotoDict = [plistTemplateDict objectForKey:objectkey];
        if (plistphotoDict != nil)
        {
            stringX = [[plistphotoDict objectForKey:@"x"]integerValue] * templateRate;
            stringY = [[plistphotoDict objectForKey:@"y"]integerValue] * templateRate;
            stringWidth = [[plistphotoDict objectForKey:@"width"]integerValue] * templateRate;
            stringHeight = [[plistphotoDict objectForKey:@"height"]integerValue] * templateRate;
            stringSize = [[plistphotoDict objectForKey:@"fontSize"]integerValue] * templateRate;
            stringAlignment = [[plistphotoDict objectForKey:@"alignment"]integerValue]; // 0: left, 1 center, 2 right
            
            // draw time textfield
            UITextField *time = [[UITextField alloc] initWithFrame:CGRectMake(stringX, stringY, stringWidth, stringHeight)];
            time.text = photoTime;
            [time setDelegate:self];
            [templateView addSubview:time];
            time.inputAccessoryView = toolbar;
            [time setFont:[UIFont fontWithName:@"Times" size:stringSize]];
            [time setTextColor:[UIColor colorWithWhite:200 alpha:1]];
            time.tag = 4; // 1: weather 2: position 3: title 4:time 5:note
            
            switch (stringAlignment)
            {
                case 0:
                    
                    [time setTextAlignment:NSTextAlignmentLeft];
                    break;
                    
                case 1:
                    
                    [time setTextAlignment:NSTextAlignmentCenter];
                    break;
                    
                case 2:
                    
                    [time setTextAlignment:NSTextAlignmentRight];
                    break;
                    
                default:
                    [time setTextAlignment:NSTextAlignmentLeft];
                    break;
            }
            
            [photoTimeArray addObject:time];
        }
        
        // get location info from plist
        objectkey = [[NSString alloc]initWithFormat: @"photoLocation"];
        plistphotoDict = [plistTemplateDict objectForKey:objectkey];
        
        if (plistphotoDict != nil)
        {
            stringX = [[plistphotoDict objectForKey:@"x"]integerValue] * templateRate;
            stringY = [[plistphotoDict objectForKey:@"y"]integerValue] * templateRate;
            stringWidth = [[plistphotoDict objectForKey:@"width"]integerValue] * templateRate;
            stringHeight = [[plistphotoDict objectForKey:@"height"]integerValue] * templateRate;
            stringSize = [[plistphotoDict objectForKey:@"fontSize"]integerValue] * templateRate;
            stringAlignment = [[plistphotoDict objectForKey:@"alignment"]integerValue]; // 0: left, 1 center, 2 right
            
            // draw location textfield
            UITextField *location = [[UITextField alloc] initWithFrame:CGRectMake(stringX, stringY, stringWidth, stringHeight)];
            
            location.text = photoLocation;
            
            [location setDelegate:self];
            [templateView addSubview:location];
            location.inputAccessoryView = toolbar;
            [location setFont:[UIFont fontWithName:@"Times" size:stringSize]];
            [location setTextColor:[UIColor colorWithWhite:200 alpha:1]];
            location.tag = 2; // 1: weather 2: position 3: title 4:time 5:note
            
            switch (stringAlignment)
            {
                case 0:
                    
                    [location setTextAlignment:NSTextAlignmentLeft];
                    break;
                    
                case 1:
                    
                    [location setTextAlignment:NSTextAlignmentCenter];
                    break;
                    
                case 2:
                    
                    [location setTextAlignment:NSTextAlignmentRight];
                    break;
                    
                default:
                    [location setTextAlignment:NSTextAlignmentLeft];
                    break;
            }
            
            [photoLocationArray addObject:location];
        }
        
        // get price info from plist
        objectkey = [[NSString alloc]initWithFormat: @"photoPrice"];
        plistphotoDict = [plistTemplateDict objectForKey:objectkey];
        
        if (plistphotoDict != nil)
        {
            stringX = [[plistphotoDict objectForKey:@"x"]integerValue] * templateRate;
            stringY = [[plistphotoDict objectForKey:@"y"]integerValue] * templateRate;
            stringWidth = [[plistphotoDict objectForKey:@"width"]integerValue] * templateRate;
            stringHeight = [[plistphotoDict objectForKey:@"height"]integerValue] * templateRate;
            stringSize = [[plistphotoDict objectForKey:@"fontSize"]integerValue] * templateRate;
            stringAlignment = [[plistphotoDict objectForKey:@"alignment"]integerValue]; // 0: left, 1 center, 2 right
            
            // draw price textfield
            UITextField *price = [[UITextField alloc] initWithFrame:CGRectMake(stringX, stringY, stringWidth, stringHeight)];
            
            price.keyboardType = UIKeyboardTypeNumberPad;
            price.text = @"5000";
            photoPrice = @"5000";
            
            [price setDelegate:self];
            [templateView addSubview:price];
            price.inputAccessoryView = toolbar;
            [price setFont:[UIFont fontWithName:@"Times" size:stringSize]];
            [price setTextColor:[UIColor colorWithWhite:200 alpha:1]];
            price.tag = 6; // 1: weather 2: position 3: title 4:time 5:note 6:price
            
            switch (stringAlignment)
            {
                case 0:
                    
                    [price setTextAlignment:NSTextAlignmentLeft];
                    break;
                    
                case 1:
                    
                    [price setTextAlignment:NSTextAlignmentCenter];
                    break;
                    
                case 2:
                    
                    [price setTextAlignment:NSTextAlignmentRight];
                    break;
                    
                default:
                    [price setTextAlignment:NSTextAlignmentLeft];
                    break;
            }
            
            [photoPriceArray addObject:price];
        }
        
        
        [templateView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [self.clothOverlayScrollView addSubview:templateView];
        }
        else
        {
            [self.iPadClothOverlayScrollView addSubview:templateView];
        }
    }
}


- (void)cameraInitWithCamera: (NSInteger)Cameraposition
{
    NSArray *myDevices = [AVCaptureDevice devices];
    NSError *error = nil;
    
    if(isCameraInitialized == NO)
    {
        captureSession = [[AVCaptureSession alloc] init];
        [captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
        
        for (AVCaptureDevice *device in myDevices)
        {
            if ([device position] == Cameraposition)
            {
                
                AVCaptureDeviceInput *myDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
                
                if (error)
                {
                    //裝置取得失敗時的處理常式
                }
                else
                {
                    [captureSession addInput:myDeviceInput];
                    currentCamDevice = device;
                }
            }
        }
        
        stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        
        NSDictionary *myOutputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
        
        [stillImageOutput setOutputSettings:myOutputSettings];
        
        [captureSession addOutput:stillImageOutput];
        
        
        
        //從 AVCaptureStillImageOutput 中取得正確類型的 AVCaptureConnection
        for (AVCaptureConnection *connection in stillImageOutput.connections)
        {
            for (AVCaptureInputPort *port in [connection inputPorts])
            {
                if ([[port mediaType] isEqual:AVMediaTypeVideo])
                {
                    
                    videoConnection = connection;
                    break;
                }
            }
        }
        
        isCameraInitialized = YES;
    }
}
- (void)configureCameraFocus: (CGPoint)focusPoint focusType: (int)focusType
{
    //AF at point and lock
    if(focusType == 0)
    {
        if ([currentCamDevice isFocusPointOfInterestSupported] && [currentCamDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus])
        {
            NSError *error;
            if ([currentCamDevice lockForConfiguration:&error])
            {
                [currentCamDevice setFocusPointOfInterest:focusPoint];
                [currentCamDevice setFocusMode:AVCaptureFocusModeAutoFocus];
                [currentCamDevice unlockForConfiguration];
            }
        }
    }
    else // continuous AF at point
    {
        
        if ([currentCamDevice isFocusPointOfInterestSupported] && [currentCamDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
        {
            NSError *error;
            if ([currentCamDevice lockForConfiguration:&error])
            {
                [currentCamDevice setFocusPointOfInterest:focusPoint];
                [currentCamDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
                [currentCamDevice unlockForConfiguration];
            }
        }
    }
}

- (void)configureCameraFlash: (int)mode
{
    if([currentCamDevice hasFlash] && [currentCamDevice hasTorch])
    {
        NSLog(@"flash:%i", mode);
        [currentCamDevice lockForConfiguration:nil];
        if(mode == 0)
        {
            [currentCamDevice setTorchMode:AVCaptureTorchModeOff];
            [currentCamDevice setFlashMode:AVCaptureFlashModeOff];
        }
        else if(mode == 1)
        {
            [currentCamDevice setTorchMode:AVCaptureTorchModeOn];
            [currentCamDevice setFlashMode:AVCaptureFlashModeOn];
        }
        else
        {
            [currentCamDevice setTorchMode:AVCaptureTorchModeAuto];
            [currentCamDevice setFlashMode:AVCaptureFlashModeAuto];
        }
        [currentCamDevice unlockForConfiguration];
    }
}

- (void)cameraStartPreview
{
    //建立 AVCaptureVideoPreviewLayer
    previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    [previewLayer setVideoGravity:AVLayerVideoGravityResize];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CGRect rect = CGRectMake(300, 400, 600, 800);
        [previewLayer setBounds:rect];
        
        myView = [[UIView alloc]initWithFrame:rect];
        [myView.layer addSublayer:previewLayer];
        
        //[self.view addSubview:myView];
        [self.iPadClothImageView addSubview:myView];
    }
    else
    {
        CGRect rect = CGRectMake(150, 200, 300, 400);
        [previewLayer setBounds:rect];
        
        myView = [[UIView alloc]initWithFrame:rect];
        [myView.layer addSublayer:previewLayer];
        
        //[self.view addSubview:myView];
        [self.clothImageView addSubview:myView];
    }
    //啟用攝影機
    [captureSession startRunning];
}

- (void)cameraCapture
{
    //stop cameraPreview
    //[myCaptureSession stopRunning];
    [previewLayer removeFromSuperlayer];
    [myView removeFromSuperview];
    
    //擷取影像（包含拍照音效）
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
     {
         
         //完成擷取時的處理常式(Block)
         if (imageDataSampleBuffer)
         {
             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
             
             
             //取得的靜態影像
             UIImage *myImage = [[UIImage alloc] initWithData:imageData];
             
             // flip image if from front camera
             if(CurrentCamera == AVCaptureDevicePositionFront)
             {
                 // flip the image
                 UIImage *flippedImage = [UIImage imageWithCGImage:myImage.CGImage scale:myImage.scale orientation:UIImageOrientationLeftMirrored];
                 myImage = flippedImage;
             }
             
             if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
             {
                 [self.iPadClothImageView setImage:myImage];
             }
             else
             {
                 [self.clothImageView setImage:myImage];
             }
             
             [OutputImageView setImage:myImage];
             
             
             //取得影像資料（需要ImageIO.framework 與 CoreMedia.framework）
             //CFDictionaryRef myAttachments = CMGetAttachment(imageDataSampleBuffer, kCGImagePropertyExifDictionary, NULL);
             //NSLog(@"影像屬性: %@", myAttachments);
             
             [captureSession stopRunning];
             
             [self cameraStop];
         }
     }
     ];
    
}

- (void)cameraStop
{
    isCameraInitialized = NO;
}

- (void)openColorPopupView
{
    NSLog(@"launch popup view");
    
    
}

- (void)selectFont:(UIButton*)sender
{
    NSLog(@"Button : %i", sender.tag);
    if(sender.tag == 0)
    {
        [currentTextField setFont:[UIFont fontWithName:@"Skia" size:80]];
    }
    else if(sender.tag == 1)
    {
        [currentTextField setFont:[UIFont fontWithName:@"Times" size:90]];
    }
    else
    {
        [currentTextField setFont:[UIFont fontWithName:@"Monaco" size:30]];
    }
}

- (void) dismissKeyboard:(UIButton*)sender
{
    isFromDismissButton = YES;
    photoNote = self.noteTextEditor.text;
    [self.noteTextEditor resignFirstResponder];
}

- (void) dismissTextFieldKeyboard:(UIButton*)sender
{
    NSLog(@"dismiss keyboard!");
    isFromDismissButton = YES;
    
    if(currentTextField.frame.origin.y > 250)
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.iPadRootView.frame = CGRectMake(self.iPadRootView.frame.origin.x, self.iPadRootView.frame.origin.y + (currentTextField.frame.origin.y - 200), self.iPadRootView.frame.size.width, self.iPadRootView.frame.size.height);
        }
        else
        {
            self.rootView.frame = CGRectMake(self.rootView.frame.origin.x, self.rootView.frame.origin.y + (currentTextField.frame.origin.y - 200), self.rootView.frame.size.width, self.rootView.frame.size.height);
            
        }
    }
    
    
    [currentTextField resignFirstResponder];
    
    // 1: Brand 2: position 3: title 4:time 5:note 6: price
    switch (currentTextField.tag)
    {
        case 1:
        {
            photoBrand = currentTextField.text;
            
            //update Brand
            for (UITextField *brandTextField in photoBrandArray)
            {
                brandTextField.text = photoBrand;
            }
            
            break;
        }
        case 2:
        {
            photoLocation = currentTextField.text;
            
            //update location
            for (UITextField *locationTextField in photoLocationArray)
            {
                locationTextField.text = photoLocation;
            }
            
            break;
        }
        case 3:
        {
            photoTitle = currentTextField.text;
            
            //update title
            for (UITextField *titleTextField in photoTitleArray)
            {
                titleTextField.text = photoTitle;
            }
            
            break;
        }
        case 4:
        {
            photoTime = currentTextField.text;
            
            //update time
            for (UITextField *timeTextField in photoTimeArray)
            {
                timeTextField.text = photoTime;
            }
            
            break;
        }
        case 5:
        {
            photoNote = currentTextField.text;
            
            //update location
            for (UITextField *noteTextField in photoNoteArray)
            {
                noteTextField.text = photoNote;
            }
            
            break;
        }
        case 6:
        {
            photoPrice = currentTextField.text;
            
            //update price
            for (UITextField *priceTextField in photoPriceArray)
            {
                priceTextField.text = photoPrice;
            }
            
            break;
        }
        default:
            break;
    }
    
    isScreenRising = NO;
    self.clothOverlayScrollView.userInteractionEnabled = YES;
}

- (void)selectColor:(UIButton*)sender
{
    NSLog(@"Button : %i", sender.tag);
    UIColor *textColor;
    if(sender.tag == 0)
    {
        textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    }
    else if(sender.tag == 1)
    {
        textColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:1];
    }
    else if(sender.tag == 2)
    {
        textColor = [UIColor colorWithRed:0 green:255 blue:0 alpha:1];
    }
    else if(sender.tag == 3)
    {
        textColor = [UIColor colorWithRed:0 green:0 blue:255 alpha:1];
    }
    else if(sender.tag == 4)
    {
        textColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1];
    }
    
    //update Brand
    for (UITextField *brandTextField in photoBrandArray)
    {
        [brandTextField setTextColor:textColor];
    }    

    for (UITextField *locationTextField in photoLocationArray)
    {
        [locationTextField setTextColor:textColor];
    }

    for (UITextField *titleTextField in photoTitleArray)
    {
        [titleTextField setTextColor:textColor];
    }
    
    //update time
    for (UITextField *timeTextField in photoTimeArray)
    {
       [timeTextField setTextColor:textColor];
    }
    
    //update location
    for (UITextField *noteTextField in photoNoteArray)
    {
        [noteTextField setTextColor:textColor];
    }
    
    //update price
    for (UITextField *priceTextField in photoPriceArray)
    {
        [priceTextField setTextColor:textColor];
    }
    
    photoTextColor = textColor;
}

- (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    for (int ii = 0 ; ii < count ; ++ii)
    {
        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += 4;
        
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        [result addObject:acolor];
    }
    
    free(rawData);
    
    return result;
}

-(void)produceImage
{
    // Now, produce Image to save here.
    // The image source is from OutputImageView.image
    // The template is self.DressTempletePageControl.currentPage
    // Brand_X.text, Type_X.text, Note_X.text (X can be 0 - 5 so far)
    //produce image
    // now prepare view
    NSLog(@"produceImage");
    CGFloat templateFrameWidth, templateFrameHeight, templateRate;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        templateFrameWidth = 600.0f;
        templateFrameHeight = 800.0f;
        templateRate = 2;
    }
    else
    {
        templateFrameWidth = 600.0f;
        templateFrameHeight = 800.0f;
        templateRate = 2;
    }
    CGRect frame = CGRectMake(templateFrameWidth, 0, templateFrameWidth, templateFrameHeight);
    
    
    UIImage *backgroundImage = OutputImageView.image;
    NSLog(@"background size=%f,%f",OutputImageView.image.size.width, OutputImageView.image.size.height );
    NSLog(@"template size=%f,%f",templateFrameWidth, templateFrameHeight );
    //UIGraphicsBeginImageContext(backgroundImage.size);
    
    //UIGraphicsBeginImageContext(backgroundImage.size);
    UIGraphicsBeginImageContext(frame.size);
    [backgroundImage drawInRect:CGRectMake(0, 0,frame.size.width, frame.size.height)];
    
    int page=0;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        page=self.iPadClothTempletePageControl.currentPage;
    }
    else
    {
        page=self.clothTempletePageControl.currentPage;
    }
    
    
    UIView *templateView = [[UIView alloc]initWithFrame:frame];
    
    NSInteger stringX, stringY, stringWidth, stringHeight, stringSize, stringAlignment;
    NSMutableDictionary *plistphotoDict;
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *defaultPlistPath = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"StyleClothTemplate.plist"];
    
    NSMutableDictionary *plistDict;
    if ([fileManager fileExistsAtPath: defaultPlistPath]) //檢查檔案是否存在
    {
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:defaultPlistPath];
    }
    else
    {
        NSLog(@"No Plist, time to debug");
    }
    
    
    NSString *objectkey = [[NSString alloc]initWithFormat: @"template%i", page];
    // Get template from plist
    NSMutableDictionary *plistTemplateDict = [plistDict objectForKey:objectkey];
    
    // get frame path
    objectkey=[[NSString alloc]init];
    objectkey = [[NSString alloc]initWithFormat: @"photoFramePath"];
    NSString *framePath = [plistTemplateDict objectForKey:objectkey];
    UIImageView *frameImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, templateFrameWidth, templateFrameHeight)];
    [frameImage setImage:[UIImage imageNamed:framePath]];
    [templateView addSubview:frameImage];
    
    // get Brand info from plist
    objectkey = [[NSString alloc]initWithFormat: @"photoBrand"];
    plistphotoDict = [plistTemplateDict objectForKey:objectkey];
    if (plistphotoDict != nil)
    {
        stringX = [[plistphotoDict objectForKey:@"x"]integerValue]*templateRate;
        stringY = [[plistphotoDict objectForKey:@"y"]integerValue]*templateRate;
        stringWidth = [[plistphotoDict objectForKey:@"width"]integerValue]*templateRate;
        stringHeight = [[plistphotoDict objectForKey:@"height"]integerValue]*templateRate;
        stringSize = [[plistphotoDict objectForKey:@"fontSize"]integerValue]*templateRate;
        stringAlignment = [[plistphotoDict objectForKey:@"alignment"]integerValue]; // 0: left, 1 center, 2 right
        
        // draw Brand textfield
        UITextField *brand = [[UITextField alloc] initWithFrame:CGRectMake(stringX, stringY, stringWidth, stringHeight)];
        if([photoBrand length]!=0)
            brand.text = photoBrand;
        else
        {
            brand.text = @"Uniqlo";
            photoBrand= @"Uniqlo"; //default value
        }
        NSLog(@"brand=%@",photoBrand);
        [brand setDelegate:self];
        [templateView addSubview:brand];
        [brand setFont:[UIFont fontWithName:@"Times" size:stringSize]];
        [brand setTextColor:photoTextColor];
        brand.tag = 1; // 1: weather 2: position 3: title 4:time 5:note
        
        switch (stringAlignment)
        {
            case 0:
                
                [brand setTextAlignment:NSTextAlignmentLeft];
                break;
                
            case 1:
                
                [brand setTextAlignment:NSTextAlignmentCenter];
                break;
                
            case 2:
                
                [brand setTextAlignment:NSTextAlignmentRight];
                break;
                
            default:
                [brand setTextAlignment:NSTextAlignmentLeft];
                break;
        }
        
        [photoBrandArray addObject:brand];
    }
    
    
    // get title info from plist
    objectkey = [[NSString alloc]initWithFormat: @"photoTitle"];
    plistphotoDict = [plistTemplateDict objectForKey:objectkey];
    if (plistphotoDict != nil)
    {
        stringX = [[plistphotoDict objectForKey:@"x"]integerValue]*templateRate;
        stringY = [[plistphotoDict objectForKey:@"y"]integerValue]*templateRate;
        stringWidth = [[plistphotoDict objectForKey:@"width"]integerValue]*templateRate;
        stringHeight = [[plistphotoDict objectForKey:@"height"]integerValue]*templateRate;
        stringSize = [[plistphotoDict objectForKey:@"fontSize"]integerValue]*templateRate;
        stringAlignment = [[plistphotoDict objectForKey:@"alignment"]integerValue]; // 0: left, 1 center, 2 right
        
        // draw weather textfield
        UITextField *title = [[UITextField alloc] initWithFrame:CGRectMake(stringX, stringY, stringWidth, stringHeight)];
        if([photoTitle length]!=0)
            title.text = photoTitle;
        else
        {
            title.text = @"失心瘋了嗎?";
            photoTitle = @"失心瘋了嗎?"; //default value
        }
        [title setDelegate:self];
        [templateView addSubview:title];
        [title setFont:[UIFont fontWithName:@"Times" size:stringSize]];
        [title setTextColor:photoTextColor];
        title.tag = 3; // 1: weather 2: position 3: title 4:time 5:note
        
        switch (stringAlignment)
        {
            case 0:
                
                [title setTextAlignment:NSTextAlignmentLeft];
                break;
                
            case 1:
                
                [title setTextAlignment:NSTextAlignmentCenter];
                break;
                
            case 2:
                
                [title setTextAlignment:NSTextAlignmentRight];
                break;
                
            default:
                [title setTextAlignment:NSTextAlignmentLeft];
                break;
        }
        
        [photoTitleArray addObject:title];
    }
    
    
    // get time info from plist
    objectkey = [[NSString alloc]initWithFormat: @"photoTime"];
    plistphotoDict = [plistTemplateDict objectForKey:objectkey];
    if (plistphotoDict != nil)
    {
        stringX = [[plistphotoDict objectForKey:@"x"]integerValue]*templateRate;
        stringY = [[plistphotoDict objectForKey:@"y"]integerValue]*templateRate;
        stringWidth = [[plistphotoDict objectForKey:@"width"]integerValue]*templateRate;
        stringHeight = [[plistphotoDict objectForKey:@"height"]integerValue]*templateRate;
        stringSize = [[plistphotoDict objectForKey:@"fontSize"]integerValue]*templateRate;
        stringAlignment = [[plistphotoDict objectForKey:@"alignment"]integerValue]; // 0: left, 1 center, 2 right
        
        // draw time textfield
        UITextField *time = [[UITextField alloc] initWithFrame:CGRectMake(stringX, stringY, stringWidth, stringHeight)];
        time.text = photoTime;
        [time setDelegate:self];
        [templateView addSubview:time];
        [time setFont:[UIFont fontWithName:@"Times" size:stringSize]];
        [time setTextColor:photoTextColor];
        time.tag = 4; // 1: weather 2: position 3: title 4:time 5:note
        
        switch (stringAlignment)
        {
            case 0:
                
                [time setTextAlignment:NSTextAlignmentLeft];
                break;
                
            case 1:
                
                [time setTextAlignment:NSTextAlignmentCenter];
                break;
                
            case 2:
                
                [time setTextAlignment:NSTextAlignmentRight];
                break;
                
            default:
                [time setTextAlignment:NSTextAlignmentLeft];
                break;
        }
        
        [photoTimeArray addObject:time];
    }
    
    // get location info from plist
    objectkey = [[NSString alloc]initWithFormat: @"photoLocation"];
    plistphotoDict = [plistTemplateDict objectForKey:objectkey];
    
    if (plistphotoDict != nil)
    {
        stringX = [[plistphotoDict objectForKey:@"x"]integerValue]*templateRate;
        stringY = [[plistphotoDict objectForKey:@"y"]integerValue]*templateRate;
        stringWidth = [[plistphotoDict objectForKey:@"width"]integerValue]*templateRate;
        stringHeight = [[plistphotoDict objectForKey:@"height"]integerValue]*templateRate;
        stringSize = [[plistphotoDict objectForKey:@"fontSize"]integerValue]*templateRate;
        stringAlignment = [[plistphotoDict objectForKey:@"alignment"]integerValue]; // 0: left, 1 center, 2 right
        
        // draw location textfield
        UITextField *location = [[UITextField alloc] initWithFrame:CGRectMake(stringX, stringY, stringWidth, stringHeight)];
        
        location.text = photoLocation;
        
        [location setDelegate:self];
        [templateView addSubview:location];
        [location setFont:[UIFont fontWithName:@"Times" size:stringSize]];
        [location setTextColor:photoTextColor];
        location.tag = 2; // 1: weather 2: position 3: title 4:time 5:note
        
        switch (stringAlignment)
        {
            case 0:
                
                [location setTextAlignment:NSTextAlignmentLeft];
                break;
                
            case 1:
                
                [location setTextAlignment:NSTextAlignmentCenter];
                break;
                
            case 2:
                
                [location setTextAlignment:NSTextAlignmentRight];
                break;
                
            default:
                [location setTextAlignment:NSTextAlignmentLeft];
                break;
        }
        
        [photoLocationArray addObject:location];
    }
    
    // get price info from plist
    objectkey = [[NSString alloc]initWithFormat: @"photoPrice"];
    plistphotoDict = [plistTemplateDict objectForKey:objectkey];
    
    if (plistphotoDict != nil)
    {
        stringX = [[plistphotoDict objectForKey:@"x"]integerValue]*templateRate;
        stringY = [[plistphotoDict objectForKey:@"y"]integerValue]*templateRate;
        stringWidth = [[plistphotoDict objectForKey:@"width"]integerValue]*templateRate;
        stringHeight = [[plistphotoDict objectForKey:@"height"]integerValue]*templateRate;
        stringSize = [[plistphotoDict objectForKey:@"fontSize"]integerValue]*templateRate;
        stringAlignment = [[plistphotoDict objectForKey:@"alignment"]integerValue]; // 0: left, 1 center, 2 right
        
        // draw price textfield
        UITextField *price = [[UITextField alloc] initWithFrame:CGRectMake(stringX, stringY, stringWidth, stringHeight)];
        if([photoPrice length]!=0)
            price.text = photoPrice;
        else
            price.text = @"5000 USD!!!";
        [price setDelegate:self];
        [templateView addSubview:price];
        [price setFont:[UIFont fontWithName:@"Times" size:stringSize]];
        [price setTextColor:photoTextColor];
        price.tag = 6; // 1: weather 2: position 3: title 4:time 5:note 6:price
        
        switch (stringAlignment)
        {
            case 0:
                
                [price setTextAlignment:NSTextAlignmentLeft];
                break;
                
            case 1:
                
                [price setTextAlignment:NSTextAlignmentCenter];
                break;
                
            case 2:
                
                [price setTextAlignment:NSTextAlignmentRight];
                break;
                
            default:
                [price setTextAlignment:NSTextAlignmentLeft];
                break;
        }
        
        [photoPriceArray addObject:price];
    }
    
    
    [[templateView layer] renderInContext:UIGraphicsGetCurrentContext()];
    OutputImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

}

@end


