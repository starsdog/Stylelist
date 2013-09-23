//
//  StyleAddDressViewController.m
//  Stylelist
//
//  Created by Splashtop on 13/7/4.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import "StyleAddDressViewController.h"

@interface StyleAddDressViewController ()

@end

@implementation StyleAddDressViewController
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
    NSString *photoWeather;
    NSMutableArray *photoWeatherArray;
    
    NSString *photoTime;
    NSMutableArray *photoTimeArray;
    
    NSString *photoLocation;
    NSMutableArray *photoLocationArray;
    
    NSString *photoTitle;
    NSMutableArray *photoTitleArray;
    
    NSString *photoNote;
    NSMutableArray *photoNoteArray;
    
    //photos
    NSString *photoName0;
    NSString *photoPath0;
    UIImage *photoCloth0;
    NSMutableArray *photoCloth0Array;
    
    NSString *photoName1;
    NSString *photoPath1;
    UIImage *photoCloth1;
    NSMutableArray *photoCloth1Array;
    
    NSString *photoName2;
    NSString *photoPath2;
    UIImage *photoCloth2;
    NSMutableArray *photoCloth2Array;
    
    NSString *photoName3;
    NSString *photoPath3;
    UIImage *photoCloth3;
    NSMutableArray *photoCloth3Array;
    
    NSString *photoName4;
    NSString *photoPath4;
    UIImage *photoCloth4;
    NSMutableArray *photoCloth4Array;
    
    NSString *photoName5;
    NSString *photoPath5;
    UIImage *photoCloth5;
    NSMutableArray *photoCloth5Array;
    
    //NSString *photoFont;
    UIColor *photoTextColor;
    
    int currentPhotoNumber;
    UIImage *currentPhotoCloth;
    NSMutableArray *currentPhotoClothArray;
    
    NSString *clothesPaths;
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
    
    //init location manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    currentLocation = @"";
    //[objMyLocationManager setDelegate:self];
    
    //1 km
    locationManager.distanceFilter = 1000;
    
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    [locationManager startUpdatingLocation];
    
    
    photoTextColor = [UIColor colorWithWhite:200 alpha:1];
    
    //prepare detail dialog
    // 1: weather 2: position 3: title 4:time
    [self.noteBackgroundView.layer setCornerRadius:5.0f];
    [self.noteTextEditor.layer setBorderWidth:1.0f];
    [self.noteTextEditor setDelegate:self];
    
    [self.weatherTextField setDelegate:self];
    self.weatherTextField.tag = 1;
    
    [self.locationTextField setDelegate:self];
    self.locationTextField.tag = 2;
    
    [self.titleTextField setDelegate:self];
    self.titleTextField.tag = 3;
    
    [self.dateTextField setDelegate:self];
    self.dateTextField.tag = 4;
    
    
    // Prepare overlay and page controller
    currentCamFlashMode = 0;
    loadImage = NO;
    isScreenRising = NO;
    isFromReturn = NO;
    
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
        [self.iPadDressOverlayScrollView addGestureRecognizer:singleTap];
    }
    else
    {
        [self.dressOverlayScrollView addGestureRecognizer:singleTap];
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
    self.weatherTextField.inputAccessoryView = kbTextFieldToolBar;
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
    //restart camera preview
    /*
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
        self.titleTextField.text = photoTitle;
        self.weatherTextField.text = photoWeather;
        self.locationTextField.text = photoLocation;
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
        [self.camFlashButton setImage:[UIImage imageNamed:@"Camera - flashOnButton.png"] forState:UIControlStateNormal];
    }
    else if(currentCamFlashMode == 2)
    {
        [self.camFlashButton setImage:[UIImage imageNamed:@"Camera - flashAutoButton.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.camFlashButton setImage:[UIImage imageNamed:@"Camera - flashOffButton.png"] forState:UIControlStateNormal];
    }
    
    [self configureCameraFlash:currentCamFlashMode];
}

- (IBAction)finishNoteEditor:(id)sender
{
    NSString *timelineImageName = [[NSString alloc]initWithFormat: @"timeline%f.jpg", [[NSDate date] timeIntervalSince1970]];
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *timelineDirectory = [documentPath stringByAppendingPathComponent:@"timeline"];
    NSString *timelinePath = [timelineDirectory stringByAppendingPathComponent:timelineImageName];
    
    // save OutputImageView.image to closet first;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // now resize the image to 600x800
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(300.0, 400.0), NO, 0.0);
    [OutputImageView.image drawInRect:CGRectMake(0, 0, 300, 400)];
    OutputImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSLog(@"Save dress image now! Image size: %f, %f", OutputImageView.image.size.width, OutputImageView.image.size.height);
    
    // Now deal with image effect merge
    [self produceImage];
    
    NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(OutputImageView.image, 1)];
    
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
    
    if(NO == [imageData writeToFile:timelinePath atomically:NO])
    {
        NSLog(@"save file fail");
    }
    else
    {
        NSLog(@"Update dress to timeline DB");
        
        //save to DB
        DBConnector *stairyDB = [DBConnector new];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            photoNote = self.iPadNoteTextEditor.text;
        }
        else
        {
             photoNote = self.noteTextEditor.text;
        }
        
        
        // prepare clothes path
        
        
        NSDictionary *dict=[stairyDB insertDressRecordofImagePath:timelineImageName Type:1 Note:photoNote Clothes:clothesPaths];
        NSNumber *timelineIDobj=[dict objectForKey:@"timelineID"];
        int timelineID=[timelineIDobj intValue];

        if (timelineID != -1)
        {
            NSLog(@"check delegate!");
            
            // notify delegate that image is saved!
            if([self.delegate respondsToSelector:@selector(didCloseController:)])
            {
                NSLog(@"Call delegate!");
                
                NSString *timelinePath = [timelineDirectory stringByAppendingPathComponent:timelineImageName];
                NSString *createtime=[dict objectForKey:@"date"];
                NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:timelinePath , @"imagepath", timelineIDobj, @"DBid", createtime, @"date", photoNote, @"note",nil];
                
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


- (void)singleTapGestureHandler:(UITapGestureRecognizer*)gesture
{
    // check whether camera is running
    if(isCameraInitialized == YES)
    {
        CGPoint touchPoint;
        float pageWidth, pageHeight;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            touchPoint = [gesture locationInView:self.iPadDressOverlayScrollView];
            pageWidth = 600.0f;
            pageHeight = 800.0f;
        }
        else
        {
            touchPoint = [gesture locationInView:self.dressOverlayScrollView];
            pageWidth = 300.0f;
            pageHeight = 400.0f;
        }
        
        NSLog(@"singe tap on x:%f, y:%f", touchPoint.x, touchPoint.y);
        
        float x = touchPoint.x - self.dressTempletePageControl.currentPage * pageWidth;
        float y = touchPoint.y;
        
        
        [self configureCameraFocus:CGPointMake((x / pageWidth), (y/pageHeight)) focusType:0];
        
        //draw focus animation now
        UIImageView *cameraFocusAnimation = [[UIImageView alloc]initWithFrame:CGRectMake(touchPoint.x - 50, touchPoint.y - 50, 100, 100)];
        [cameraFocusAnimation setImage:[UIImage imageNamed:@""]];
        cameraFocusAnimation.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"camera-focus-100.png"], [UIImage imageNamed:@"camera-focus-95.png"],[UIImage imageNamed:@"camera-focus-90.png"],[UIImage imageNamed:@"camera-focus-85.png"],[UIImage imageNamed:@"camera-focus-80.png"],[UIImage imageNamed:@"camera-focus-75.png"],[UIImage imageNamed:@"camera-focus-70.png"],[UIImage imageNamed:@"camera-focus-65.png"],[UIImage imageNamed:@"camera-focus-60.png"],[UIImage imageNamed:@"camera-focus-55.png"],[UIImage imageNamed:@"camera-focus-50.png"], nil];
        
        cameraFocusAnimation.animationDuration = 1.00;
        cameraFocusAnimation.animationRepeatCount = 2;

        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [self.iPadDressOverlayScrollView addSubview:cameraFocusAnimation];
        }
        else
        {
            [self.dressOverlayScrollView addSubview:cameraFocusAnimation];
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
            [self.iPadDressImageView setImage:myImage];
        }
        else
        {
            [self.dressImageView setImage:myImage];
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

//StyleAddDressDelegate and StyleAddClothDelegate, the same name for addDress and addCloth
- (void)didCloseClosetViewController:(NSString*)photoPath andPhotoName:(NSString *)photoName
{
    NSLog(@"update photo from path:%@",photoPath);
   
    if([[NSFileManager defaultManager] fileExistsAtPath:photoPath] == NO)
    {
        NSLog(@"images doesn't exist");
    }
    else
    {
        NSLog(@"show image");
    
        switch (currentPhotoNumber)
        {
            case 0:
                photoName0 = [[NSString alloc] initWithString:photoName];
                photoPath0 = [[NSString alloc] initWithString:photoPath];
                photoCloth0 = [UIImage imageWithContentsOfFile:photoPath];
                break;

            case 1:
                photoName1 = [[NSString alloc] initWithString:photoName];
                photoPath1 = [[NSString alloc] initWithString:photoPath];
                photoCloth1 = [UIImage imageWithContentsOfFile:photoPath];
                break;
                
            case 2:
                photoName2 = [[NSString alloc] initWithString:photoName];
                photoPath2 = [[NSString alloc] initWithString:photoPath];
                photoCloth2 = [UIImage imageWithContentsOfFile:photoPath];
                break;
                
            case 3:
                photoName3 = [[NSString alloc] initWithString:photoName];
                photoPath3 = [[NSString alloc] initWithString:photoPath];
                photoCloth3 = [UIImage imageWithContentsOfFile:photoPath];
                break;
                
            case 4:
                photoName4 = [[NSString alloc] initWithString:photoName];
                photoPath4 = [[NSString alloc] initWithString:photoPath];
                photoCloth4 = [UIImage imageWithContentsOfFile:photoPath];
                break;
                
            case 5:
                photoName5 = [[NSString alloc] initWithString:photoName];
                photoPath5 = [[NSString alloc] initWithString:photoPath];
                photoCloth5 = [UIImage imageWithContentsOfFile:photoPath];
                break;
                
            default:
                break;
        }
        
        currentPhotoCloth = [UIImage imageWithContentsOfFile:photoPath];
    
        for (UIButton *dressImage in currentPhotoClothArray)
        {
            [dressImage setImage:currentPhotoCloth forState:UIControlStateNormal];
        }
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
        self.iPadDressTempletePageControl.currentPage = page;
    }
    else
    {
        self.dressTempletePageControl.currentPage = page;
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
    NSLog(@"should dismiss!");
    
    isFromReturn = NO;
    isFromDismissButton = NO;
    
    return YES;
}

// UITextFieldDelefate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"dismiss keyboard!");
    isFromReturn = YES;
    
    if((self.view.frame.size.height - textField.frame.origin.y) < 280)
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.iPadRootView.frame = CGRectMake(self.iPadRootView.frame.origin.x, self.iPadRootView.frame.origin.y + (textField.frame.origin.y - 200 + textField.frame.size.height), self.iPadRootView.frame.size.width, self.iPadRootView.frame.size.height);
        }
        else
        {
            self.rootView.frame = CGRectMake(self.rootView.frame.origin.x, self.rootView.frame.origin.y + (textField.frame.origin.y - 200 + textField.frame.size.height), self.rootView.frame.size.width, self.rootView.frame.size.height);
            
        }
    }

    
    [textField resignFirstResponder];
    
    // 1: weather 2: position 3: title 4:time 5:note
    switch (textField.tag)
    {
        case 1:
        {
            photoWeather = textField.text;
            
            //update weather
            for (UITextField *weatherTextField in photoWeatherArray)
            {
                weatherTextField.text = photoWeather;
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
        default:
            break;
    }
    
    isScreenRising = NO;
    self.dressOverlayScrollView.userInteractionEnabled = YES;
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"raise root View if necessary");
    
    if(((self.view.frame.size.height - textField.frame.origin.y) < 280) && (isScreenRising == NO))
    {
        isScreenRising = YES;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.iPadRootView.frame = CGRectMake(self.iPadRootView.frame.origin.x, self.iPadRootView.frame.origin.y - (textField.frame.origin.y - 200+ textField.frame.size.height), self.iPadRootView.frame.size.width, self.iPadRootView.frame.size.height);
        }
        else
        {
            self.rootView.frame = CGRectMake(self.rootView.frame.origin.x, self.rootView.frame.origin.y - (textField.frame.origin.y - 200 + textField.frame.size.height), self.rootView.frame.size.width, self.rootView.frame.size.height);
        }
    }
    
    currentTextField = textField;
    self.dressOverlayScrollView.userInteractionEnabled = NO;
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
        self.iPadRootView.frame = CGRectMake(self.iPadRootView.frame.origin.x, self.iPadRootView.frame.origin.y + (textView.frame.origin.y - 200 + textView.frame.size.height), self.iPadRootView.frame.size.width, self.iPadRootView.frame.size.height);
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
        self.iPadRootView.frame = CGRectMake(self.iPadRootView.frame.origin.x, self.iPadRootView.frame.origin.y - (textView.frame.origin.y - 200 + textView.frame.size.height), self.iPadRootView.frame.size.width, self.iPadRootView.frame.size.height);
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
         self.dressOverlayScrollView.userInteractionEnabled = NO;
         
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
             
             // and try to get weather by information here
             CLLocation *objCurrentLocation = locations[0];

             [self getWeatherInfoWithLatigude: objCurrentLocation.coordinate.latitude andLongitude: objCurrentLocation.coordinate.longitude];
              
             [locationManager stopUpdatingLocation];
         }
         
         self.dressOverlayScrollView.userInteractionEnabled = YES;
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
    NSString *defaultPlistPath = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"StyleDressTemplate.plist"];
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
        [self.iPadDressTempletePageControl setNumberOfPages:templateNumber];
        [self.iPadDressTempletePageControl setCurrentPage:0];
        
        // prepare scroll view
        [self.iPadDressOverlayScrollView setPagingEnabled:YES];
        [self.iPadDressOverlayScrollView setShowsHorizontalScrollIndicator:NO];
        [self.iPadDressOverlayScrollView setShowsVerticalScrollIndicator:NO];
        [self.iPadDressOverlayScrollView setScrollsToTop:NO];
        [self.iPadDressOverlayScrollView setDelegate:self];
        
        [self.iPadDressOverlayScrollView setFrame:CGRectMake(84, 52, 600, 800)];
        [self.iPadDressOverlayScrollView setContentSize:CGSizeMake(templateFrameWidth * templateNumber, templateFrameHeight)];
    }
    else
    {
        [self.dressTempletePageControl setNumberOfPages:templateNumber];
        [self.dressTempletePageControl setCurrentPage:0];
        
        // prepare scroll view
        [self.dressOverlayScrollView setPagingEnabled:YES];
        [self.dressOverlayScrollView setShowsHorizontalScrollIndicator:NO];
        [self.dressOverlayScrollView setShowsVerticalScrollIndicator:NO];
        [self.dressOverlayScrollView setScrollsToTop:NO];
        [self.dressOverlayScrollView setDelegate:self];
        
        [self.dressOverlayScrollView setFrame:CGRectMake(10, 30, 300, 400)];
        [self.dressOverlayScrollView setContentSize:CGSizeMake(templateFrameWidth * templateNumber, templateFrameHeight)];
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
    photoWeatherArray = [[NSMutableArray alloc]init];
    photoNoteArray = [[NSMutableArray alloc]init];
    photoLocationArray = [[NSMutableArray alloc]init];
    photoTimeArray = [[NSMutableArray alloc]init];
    photoCloth0Array = [[NSMutableArray alloc]init];
    photoCloth1Array = [[NSMutableArray alloc]init];
    photoCloth2Array = [[NSMutableArray alloc]init];
    photoCloth3Array = [[NSMutableArray alloc]init];
    photoCloth4Array = [[NSMutableArray alloc]init];
    photoCloth5Array = [[NSMutableArray alloc]init];
    
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
        
        // get frame path
        objectkey = [[NSString alloc]initWithFormat: @"photoFramePath"];
        NSString *framePath = [plistTemplateDict objectForKey:objectkey];
        UIImageView *frameImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, templateFrameWidth, templateFrameHeight)];
        [frameImage setImage:[UIImage imageNamed:framePath]];
        [templateView addSubview:frameImage];
        
        // Get photo number from plist
        int photoClothNum = [[plistTemplateDict objectForKey:@"photoClothNumber"] integerValue];
        
        // Draw default photoImage to templateView
        for(int i = 0; i < photoClothNum; i++)
        {
            // get photo position from plist
            NSString *objectkey = [[NSString alloc]initWithFormat: @"photoCloth%i", i];
            NSMutableDictionary *plistphotoDict = [plistTemplateDict objectForKey:objectkey];
            int photoX = [[plistphotoDict objectForKey:@"x"]integerValue] * templateRate;
            int photoY = [[plistphotoDict objectForKey:@"y"]integerValue] * templateRate;
            int photoWidth = [[plistphotoDict objectForKey:@"width"]integerValue] * templateRate;
            int photoHeight = [[plistphotoDict objectForKey:@"height"]integerValue] * templateRate;
            
            NSLog(@"photo%i x:%i, y:%i width:%i height:%i", i, photoX, photoY, photoWidth, photoHeight);
            
            //now draw photo on view
            
            UIImage *defaultImage = [UIImage imageNamed:@"cloth-template.png"];
            /*
             UIImageView *clothPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(photoX, photoY, photoWidth, photoHeight)];
             [clothPhoto setImage:defaultImage];
             [templateView addSubview:clothPhoto];
             */
            UIButton *dressImage= [UIButton buttonWithType:UIButtonTypeCustom];
            [dressImage addTarget:self action:@selector(selectDressPhoto:) forControlEvents:UIControlEventTouchUpInside];
            dressImage.tag = i;
            [dressImage setImage:defaultImage forState:UIControlStateNormal];
            dressImage.frame = CGRectMake(photoX, photoY, photoWidth, photoHeight);
            //[dressImage setAlpha:0.6f];
            [templateView addSubview:dressImage];
            
            switch (i)
            {
                case 0:
                    [photoCloth0Array addObject:dressImage];
                    break;
                case 1:
                    [photoCloth1Array addObject:dressImage];
                    break;
                case 2:
                    [photoCloth2Array addObject:dressImage];
                    break;
                case 3:
                    [photoCloth3Array addObject:dressImage];
                    break;
                case 4:
                    [photoCloth4Array addObject:dressImage];
                    break;
                case 5:
                    [photoCloth5Array addObject:dressImage];
                    break;
                default:
                    break;
            }
            
            
            //now, add touch event for change picture
            //[clothPhoto addTarget:self action:@selector(selectFont:) forControlEvents:UIControlEventTouchUpInside];
            //clothPhoto.tag = i;
            
        }
        
        NSInteger stringX, stringY, stringWidth, stringHeight, stringSize, stringAlignment;
        NSMutableDictionary *plistphotoDict;
        
        // get weather info from plist
        objectkey = [[NSString alloc]initWithFormat: @"photoWeather"];
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
            UITextField *Weather = [[UITextField alloc] initWithFrame:CGRectMake(stringX, stringY, stringWidth, stringHeight)];
            Weather.text = @"";
            [Weather setDelegate:self];
            [templateView addSubview:Weather];
            Weather.inputAccessoryView = toolbar;
            [Weather setFont:[UIFont fontWithName:@"Times" size:stringSize]];
            [Weather setTextColor:[UIColor colorWithWhite:200 alpha:1]];
            Weather.hidden = YES;
            Weather.tag = 1; // 1: weather 2: position 3: title 4:time 5:note
            
            // disable this after we can get weather info
            [Weather setEnabled:NO];
            
            switch (stringAlignment)
            {
                case 0:
                    
                    [Weather setTextAlignment:NSTextAlignmentLeft];
                    break;
                    
                case 1:
                    
                    [Weather setTextAlignment:NSTextAlignmentCenter];
                    break;
                    
                case 2:
                    
                    [Weather setTextAlignment:NSTextAlignmentRight];
                    break;
                    
                default:
                    [Weather setTextAlignment:NSTextAlignmentLeft];
                    break;
            }
            
            [photoWeatherArray addObject:Weather];
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
        
        [templateView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [self.dressOverlayScrollView addSubview:templateView];
        }
        else
        {
            [self.iPadDressOverlayScrollView addSubview:templateView];
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
        [self.iPadDressImageView addSubview:myView];
    }
    else
    {
        
        CGRect rect = CGRectMake(150, 200, 300, 400);
        [previewLayer setBounds:rect];
        
        myView = [[UIView alloc]initWithFrame:rect];
        [myView.layer addSublayer:previewLayer];
        
        //[self.view addSubview:myView];
        [self.dressImageView addSubview:myView];
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
                 [self.iPadDressImageView setImage:myImage];
             }
             else
             {
                 [self.dressImageView setImage:myImage];
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
    //NSInteger fontSize = currentTextField.font.pointSize;
    float fontSize = 40;
    NSLog(@"font size %f", fontSize);
    if(sender.tag == 0)
    {
        [currentTextField setFont:[UIFont fontWithName:@"American Typewriter" size:fontSize]];
    }
    else if(sender.tag == 1)
    {
        [currentTextField setFont:[UIFont fontWithName:@"Arial" size:fontSize]];
    }
    else if(sender.tag == 2)
    {
        [currentTextField setFont:[UIFont fontWithName:@"Avenir Book" size:fontSize]];
    }
    else if(sender.tag == 3)
    {
        [currentTextField setFont:[UIFont fontWithName:@"Courier" size:fontSize]];
    }
    else if(sender.tag == 4)
    {
        [currentTextField setFont:[UIFont fontWithName:@"Didot Italic" size:fontSize]];
    }
    else if(sender.tag == 5)
    {
        [currentTextField setFont:[UIFont fontWithName:@"Hiragino Kaku Gothic ProN W3" size:fontSize]];
    }
    else if(sender.tag == 6)
    {
        [currentTextField setFont:[UIFont fontWithName:@"Marion Regular" size:fontSize]];
    }
    else if(sender.tag == 7)
    {
        [currentTextField setFont:[UIFont fontWithName:@"Palatino" size:fontSize]];
    }
    else if(sender.tag == 8)
    {
        [currentTextField setFont:[UIFont fontWithName:@"Verdana" size:fontSize]];
    }
}

- (void)selectDressPhoto:(UIButton*)sender
{
    NSLog(@"Photo Dress : %i", sender.tag);
    
    currentPhotoNumber = sender.tag;
    switch(sender.tag)
    {
        case 0:
        {
            currentPhotoCloth = photoCloth0;
            currentPhotoClothArray = photoCloth0Array;
            break;
        }
        case 1:
        {
            currentPhotoCloth = photoCloth1;
            currentPhotoClothArray = photoCloth1Array;
            break;
        }
        case 2:
        {
            currentPhotoCloth = photoCloth2;
            currentPhotoClothArray = photoCloth2Array;
            break;
        }
        case 3:
        {
            currentPhotoCloth = photoCloth3;
            currentPhotoClothArray = photoCloth3Array;
            break;
        }
        case 4:
        {
            currentPhotoCloth = photoCloth4;
            currentPhotoClothArray = photoCloth4Array;
            break;
        }
        case 5:
        {
            currentPhotoCloth = photoCloth5;
            currentPhotoClothArray = photoCloth5Array;
            break;
        }
        default:
        {
            currentPhotoCloth = photoCloth0;
            currentPhotoClothArray = photoCloth0Array;
            break;
        }
    }
    
    
    [self performSegueWithIdentifier:@"SegueLaunchClosetViewController" sender:self];
    
    //[self performSegueWithIdentifier:@"addDressViewController" sender:self];
    
}

// prepare for segue, this works for both add dress and add cloth
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id closetViewController = segue.destinationViewController;
    // transfer action and photo tag to closetViewController for cloth selection
    [closetViewController setValue:self forKey:@"delegate"];
    [closetViewController setValue:@"pickClothFromDressView" forKey:@"comingAction"];
    
}

- (void) dismissKeyboard:(UIButton*)sender
{
    photoNote = self.noteTextEditor.text;
    
    isFromDismissButton = YES;
    [self.noteTextEditor resignFirstResponder];
}

- (void) dismissTextFieldKeyboard:(UIButton*)sender
{
    NSLog(@"dismiss keyboard from textField!");
    isFromDismissButton = YES;
    if((self.view.frame.size.height - currentTextField.frame.origin.y) < 280)
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.iPadRootView.frame = CGRectMake(self.iPadRootView.frame.origin.x, self.iPadRootView.frame.origin.y + (currentTextField.frame.origin.y - 200 + currentTextField.frame.size.height), self.iPadRootView.frame.size.width, self.iPadRootView.frame.size.height);
        }
        else
        {
            self.rootView.frame = CGRectMake(self.rootView.frame.origin.x, self.rootView.frame.origin.y + (currentTextField.frame.origin.y - 200), self.rootView.frame.size.width, self.rootView.frame.size.height);
            
        }
    }
    
    [currentTextField resignFirstResponder];
    
    // 1: weather 2: position 3: title 4:time 5:note
    switch (currentTextField.tag)
    {
        case 1:
        {
            photoWeather = currentTextField.text;
            
            //update weather
            for (UITextField *weatherTextField in photoWeatherArray)
            {
                weatherTextField.text = photoWeather;
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
        default:
            break;
    }
    
    isScreenRising = NO;
    self.dressOverlayScrollView.userInteractionEnabled = YES;
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
    for (UITextField *weatherTextField in photoWeatherArray)
    {
        [weatherTextField setTextColor:textColor];
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
    DBConnector *stairyDB = [DBConnector new];
    
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
    UIGraphicsBeginImageContext(frame.size);
    [backgroundImage drawInRect:CGRectMake(0, 0,frame.size.width, frame.size.height)];
    
    int page=0;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        page=self.iPadDressTempletePageControl.currentPage;
    }
    else
    {
        page=self.dressTempletePageControl.currentPage;
    }
    
    // read plist
    NSString *defaultPlistPath = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"StyleDressTemplate.plist"];
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
    NSString *objectkey = [[NSString alloc]initWithFormat: @"template%i", page];
    NSLog(@"objectkey:%@", objectkey);
  
    // init template object array
    photoTitleArray = [[NSMutableArray alloc]init];
    photoWeatherArray = [[NSMutableArray alloc]init];
    photoNoteArray = [[NSMutableArray alloc]init];
    photoLocationArray = [[NSMutableArray alloc]init];
    photoTimeArray = [[NSMutableArray alloc]init];
    photoCloth0Array = [[NSMutableArray alloc]init];
    photoCloth1Array = [[NSMutableArray alloc]init];
    photoCloth2Array = [[NSMutableArray alloc]init];
    photoCloth3Array = [[NSMutableArray alloc]init];
    photoCloth4Array = [[NSMutableArray alloc]init];
    photoCloth5Array = [[NSMutableArray alloc]init];
    
    // Get template from plist
    NSMutableDictionary *plistTemplateDict = [plistDict objectForKey:objectkey];
        
    // now prepare view
    UIView *templateView = [[UIView alloc]initWithFrame:frame];
        
    // get frame path
    objectkey = [[NSString alloc]initWithFormat: @"photoFramePath"];
    NSString *framePath = [plistTemplateDict objectForKey:objectkey];
    UIImageView *frameImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, templateFrameWidth, templateFrameHeight)];
    [frameImage setImage:[UIImage imageNamed:framePath]];
    [templateView addSubview:frameImage];
        
    // Get photo number from plist
    int photoClothNum = [[plistTemplateDict objectForKey:@"photoClothNumber"] integerValue];
        
    // Draw default photoImage to templateView
    for(int i = 0; i < photoClothNum; i++)
    {
        // get photo position from plist
        NSString *objectkey = [[NSString alloc]initWithFormat: @"photoCloth%i", i];
        NSMutableDictionary *plistphotoDict = [plistTemplateDict objectForKey:objectkey];
        int photoX = [[plistphotoDict objectForKey:@"x"]integerValue] * templateRate;
        int photoY = [[plistphotoDict objectForKey:@"y"]integerValue] * templateRate;
        int photoWidth = [[plistphotoDict objectForKey:@"width"]integerValue] * templateRate;
        int photoHeight = [[plistphotoDict objectForKey:@"height"]integerValue] * templateRate;
            
        NSLog(@"photo%i x:%i, y:%i width:%i height:%i", i, photoX, photoY, photoWidth, photoHeight);
            
        //now draw photo on view
            
        UIImageView *photoImage =[[UIImageView alloc] initWithFrame:CGRectMake(photoX, photoY, photoWidth, photoHeight)];
        
        switch (i)
        {
            case 0:
                if(photoPath0 != nil)
                {
                    [photoImage setImage:photoCloth0];
                    clothesPaths = [[NSString alloc] initWithFormat:@"0:%@ ", photoPath0];
                    [stairyDB increaseClothCountofImageName: photoName0];
                }
                break;
            case 1:
                if(photoPath1 != nil)
                {
                    [photoImage setImage:photoCloth1];
                    clothesPaths = [[NSString alloc] initWithFormat:@"%@ 1:%@ ", clothesPaths, photoPath1];
                    [stairyDB increaseClothCountofImageName: photoName1];
                }
                break;
            case 2:
                if(photoPath2 != nil)
                {
                    [photoImage setImage:photoCloth2];
                    clothesPaths = [[NSString alloc] initWithFormat:@"%@ 2:%@ ", clothesPaths, photoPath2];
                    [stairyDB increaseClothCountofImageName: photoName2];
                }
                break;
            case 3:
                if(photoPath3 != nil)
                {
                    [photoImage setImage:photoCloth3];
                    clothesPaths = [[NSString alloc] initWithFormat:@"%@ 3:%@ ", clothesPaths, photoPath3];
                    [stairyDB increaseClothCountofImageName: photoName3];
                }
                break;
            case 4:
                if(photoPath4 != nil)
                {
                    [photoImage setImage:photoCloth4];
                    clothesPaths = [[NSString alloc] initWithFormat:@"%@ 4:%@ ", clothesPaths, photoPath4];
                    [stairyDB increaseClothCountofImageName: photoName4];
                }
                break;
            case 5:
                if(photoPath5 != nil)
                {
                    [photoImage setImage:photoCloth5];
                    clothesPaths = [[NSString alloc] initWithFormat:@"%@ 5:%@ ", clothesPaths, photoPath5];
                    [stairyDB increaseClothCountofImageName: photoName5];
                }
                break;
                
            default:
                break;
        }
        
        //[photoImage setImage:[UIImage imageNamed:@"300x400_default.jpg"]];
        [templateView addSubview:photoImage];
    }
    
    NSLog(@"clothesPaths path : %@", clothesPaths);
    
    NSInteger stringX, stringY, stringWidth, stringHeight, stringSize, stringAlignment;
    NSMutableDictionary *plistphotoDict;
        
    // get weather info from plist
    
    objectkey = [[NSString alloc]initWithFormat: @"photoWeather"];
    plistphotoDict = [plistTemplateDict objectForKey:objectkey];
    if (plistphotoDict != nil)
    {
        stringX = [[plistphotoDict objectForKey:@"x"]integerValue] * templateRate;
        stringY = [[plistphotoDict objectForKey:@"y"]integerValue] * templateRate;
        stringWidth = [[plistphotoDict objectForKey:@"width"]integerValue] * templateRate;
        stringHeight = [[plistphotoDict objectForKey:@"height"]integerValue] * templateRate;
        stringSize = [[plistphotoDict objectForKey:@"fontSize"]integerValue] * templateRate;
        stringAlignment = [[plistphotoDict objectForKey:@"alignment"]integerValue]; // 0: left, 1 center, 2 right
        
        UITextField *Weather = [[UITextField alloc] initWithFrame:CGRectMake(stringX, stringY, stringWidth, stringHeight)];
        Weather.text = photoWeather;
        [Weather setDelegate:self];
        [templateView addSubview:Weather];
        [Weather setFont:[UIFont fontWithName:@"Times" size:stringSize]];
        [Weather setTextColor:photoTextColor];
        Weather.hidden = NO;
        Weather.tag = 1; // 1: weather 2: position 3: title 4:time 5:note
        
        switch (stringAlignment)
        {
            case 0:
                
                [Weather setTextAlignment:NSTextAlignmentLeft];
                break;
                
            case 1:
                
                [Weather setTextAlignment:NSTextAlignmentCenter];
                break;
                
            case 2:
                
                [Weather setTextAlignment:NSTextAlignmentRight];
                break;
                
            default:
                [Weather setTextAlignment:NSTextAlignmentLeft];
                break;
        }
        
        [photoWeatherArray addObject:Weather];
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
        
        title.text = photoTitle;

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


    [[templateView layer] renderInContext:UIGraphicsGetCurrentContext()];
    OutputImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
 
    
}

- (void)getWeatherInfoWithLatigude: (int)latitude andLongitude: (int)longitude
{
    NSLog(@"%@", [[NSLocale currentLocale] localeIdentifier]);
    //NSLog(@"latitude:%i and longitude:%i", latitude, longitude);
    NSString *weatherString = [[NSString alloc]initWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%i&lon=%i&lang=%@", latitude, longitude, [[NSLocale currentLocale] localeIdentifier]];
    
    weatherString = [weatherString lowercaseString];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:weatherString]];
    [request setHTTPMethod:@"GET"];
    
    //send request & get response
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new]
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error)
     {
         
         if ([data length] >0 && error == nil)
         {
             NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             
             NSData *jsonData = [strData dataUsingEncoding:NSUTF8StringEncoding];
             
             NSError* error;
             NSDictionary* weatherInfo = [NSJSONSerialization
                                          JSONObjectWithData:jsonData
                                          options:kNilOptions
                                          error:&error];
             
             
             NSDictionary *weatherMain = [weatherInfo objectForKey:@"main"];
             int temperature = [[weatherMain objectForKey:@"temp"] intValue] - 273;
             NSArray *weatherWeather = [weatherInfo objectForKey:@"weather"];
             NSDictionary *weatherInfoDic = weatherWeather[0];
             NSString *strWeatherDescription = [weatherInfoDic objectForKey:@"description"];
             
             //NSLog(@"%@ %i°C", strWeatherDescription, temperature);
             
             if(strWeatherDescription != nil)
             {
                 photoWeather = [[NSString alloc] initWithFormat:@"%@ %i°C", strWeatherDescription, temperature];
                 
                 //update weather
                 for (UITextField *weatherTextField in photoWeatherArray)
                 {
                     NSLog(@"%@",photoWeather);
                     weatherTextField.text = photoWeather;
                     weatherTextField.hidden = NO;
                     
                     // now allow user to edit weather
                     [weatherTextField setEnabled:YES];
                 }
             }


         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Nothing was downloaded.");
         }
         else if (error != nil){
             NSLog(@"Error = %@", error);
         }
        
     }];
}
@end

