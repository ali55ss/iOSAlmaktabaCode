//
//  IRLScannerViewController
//
//  Created by Denis Martin on 28/06/2015.
//  Copyright (c) 2015 Denis Martin. All rights reserved.
//

#import "IRLScannerViewController.h"
#import "IRLCameraView.h"
#import "ImageShowVC.h"
#import "SVProgressHUD.h"
#import "FilterVC.h"
#import "UIImage+FixOriantion.h"
#import <CoreMotion/CoreMotion.h>
#import "CircleDownCounter.h"
#import "GMImagePickerController.h"
#import "ViewController.h"

#define degreesToRadians(x) (M_PI * (x) / 180.0)

@interface IRLScannerViewController () <IRLCameraViewProtocol ,IRLScannerViewControllerDelegate ,GMImagePickerControllerDelegate >

@property (weak)                        id<IRLScannerViewControllerDelegate> camera_PrivateDelegate;

@property (weak, nonatomic, readwrite)  IBOutlet UIButton       *flash_toggle;
@property (weak, nonatomic, readwrite)  IBOutlet UIButton       *contrast_type;
@property (weak, nonatomic, readwrite)  IBOutlet UIButton       *detect_toggle;
@property (weak, nonatomic, readwrite)  IBOutlet UIButton       *cancel_button;
@property (readwrite)                   BOOL     cancelWasTrigger;

@property (weak, nonatomic)             IBOutlet UIView         *adjust_bar;
@property (weak, nonatomic)             IBOutlet UILabel        *titleLabel;

@property (weak, nonatomic)             IBOutlet UIImageView *focusIndicator;

@property (weak, nonatomic)             IBOutlet IRLCameraView  *cameraView;

- (IBAction)captureButton:(id)sender;

@property (readwrite, nonatomic)        IRLScannerViewType                   cameraViewType;

@property (readwrite, nonatomic)        IRLScannerDetectorType               detectorType;


@property (strong, nonatomic) IBOutlet UIImageView *imgvwCameraOuter;
@property (strong, nonatomic) IBOutlet UIImageView *imgvwCameraInner;

@property (strong, nonatomic) IBOutlet UIView *vwCountDown;

@property (strong, nonatomic) IBOutlet UILabel *lblPageCount;
@property (strong, nonatomic) IBOutlet UILabel *lblFitDocumnt;
@property (strong, nonatomic) IBOutlet UIButton *btnQues;
@property (strong, nonatomic) IBOutlet UIView *viewInfoBG;
@property (strong, nonatomic) IBOutlet UIImageView *imgvwHand;
@property (strong, nonatomic) IBOutlet UIView *viewInfo;
@property (strong, nonatomic) IBOutlet UIButton *btnOkViewInfo;

@end

@implementation IRLScannerViewController
{
    CABasicAnimation *  rotationAnimation;
    UITapGestureRecognizer * tapgesture;

}

#pragma mark - Initializer

+ (instancetype)standardCameraViewWithDelegate:(id<IRLScannerViewControllerDelegate>)delegate {
    return [self cameraViewWithDefaultType:IRLScannerViewTypeNormal defaultDetectorType:IRLScannerDetectorTypeAccuracy withDelegate:self];
}

+ (instancetype)cameraViewWithDefaultType:(IRLScannerViewType)type
                      defaultDetectorType:(IRLScannerDetectorType)detector
                             withDelegate:(id<IRLScannerViewControllerDelegate>)delegate {
    
    NSAssert(delegate != nil, @"You must provide a delegate");
    
    
    IRLScannerViewController*    cameraView = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:self]] instantiateViewControllerWithIdentifier:@"CameraVC"];
    cameraView.cameraViewType = type;
    cameraView.detectorType = detector;
    cameraView.camera_PrivateDelegate = cameraView;
    cameraView.showControls = YES;
    cameraView.detectionOverlayColor = [UIColor blueColor];
    
    return cameraView;
}

#pragma mark - Setters

- (void)setCameraViewType:(IRLScannerViewType)cameraViewType {
    _cameraViewType = cameraViewType;
    [self.cameraView setCameraViewType:cameraViewType];
}

- (void)setDetectorType:(IRLScannerDetectorType)detectorType {
    _detectorType = detectorType;
    [self.cameraView setDetectorType:detectorType];
}

- (void)setShowControls:(BOOL)showControls {
    _showControls = showControls;
    [self updateTitleLabel:nil];
}

- (void)setShowAutoFocusWhiteRectangle:(BOOL)showAutoFocusWhiteRectangle {
    _showAutoFocusWhiteRectangle = showAutoFocusWhiteRectangle;
    [self.cameraView setEnableShowAutoFocus:showAutoFocusWhiteRectangle];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(StartCameraButtonAnimation:)
                                                 name:@"StartCameraAnimation"
                                               object:nil];
    _lblPageCount.layer.cornerRadius = _lblPageCount.frame.size.width/2;
    _lblPageCount.layer.masksToBounds = YES;

    _btnOkViewInfo.layer.cornerRadius = 15.0;
    _btnOkViewInfo.layer.masksToBounds = YES;
    
    _viewInfo.layer.cornerRadius = 5.0;
    _viewInfo.layer.masksToBounds = YES;

    btnGallery1.layer.transform = CATransform3DMakeRotation(degreesToRadians(-10), 0, 0, 1.0);
    btngallery2.layer.transform = CATransform3DMakeRotation(degreesToRadians(-20), 0, 0, 1.0);

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[SharedClass sharedManager]isAutometicCapture]) {
        btnCamera.hidden = YES;
        _imgvwCameraInner.hidden = NO;
        _imgvwCameraOuter.hidden = NO;
        
    }
    else{
        btnCamera.hidden = NO;
        _imgvwCameraInner.hidden = YES;
        _imgvwCameraOuter.hidden = YES;
        
    }
    
    [CircleDownCounter removeCircleViewFromView:self.vwCountDown];
    
    self.vwCountDown.layer.cornerRadius = self.vwCountDown.frame.size.width/2;
    self.vwCountDown.layer.masksToBounds = YES;


    activityIn.hidden = YES;
    
    __weak  typeof(self) weakSelf = self;
    
    [weakSelf titleLabel].hidden = NO;
    [weakSelf updateTitleLabel:@"  Looking for document...  "];
    [weakSelf titleLabel].layer.cornerRadius = 15.0;
    [weakSelf titleLabel].layer.masksToBounds = YES;

    btnCamera.userInteractionEnabled = YES;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectOrientation) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
    [self detectOrientation];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [appDelegateObj setShouldRotate:YES];
    
    [self.cameraView setupCameraView];
    
    [self.cameraView setDelegate:self];
    [self.cameraView setOverlayColor:self.detectionOverlayColor];
    [self.cameraView setDetectorType:self.detectorType];
    [self.cameraView setCameraViewType:self.cameraViewType];
    [self.cameraView setEnableShowAutoFocus:self.showAutoFocusWhiteRectangle];
    
//    if (![self.cameraView hasFlash]){
//        self.flash_toggle.enabled = NO;
//        self.flash_toggle.hidden = YES;
//    }
    
    if (![self.cameraView hasFlash]){
        btnFlash.hidden = YES;
        self.flash_toggle.enabled = NO;
        self.flash_toggle.hidden = YES;
        self.cameraView.enableTorch = 1;
    }
    else{
        btnFlash.hidden = NO;
        self.flash_toggle.enabled = YES;
        self.flash_toggle.hidden = NO;
        [btnFlash setImage:[UIImage imageNamed:@"flash-on"] forState:UIControlStateNormal];
        //if ([[SharedClass sharedManager]isTorchON]) {
        self.cameraView.enableTorch = 0;
        //}
        
    }
    //self.cameraView.enableTorch = 0;
   // [self.cameraView];
    
   // [self.cameraView setBorderDetectionFrameStyle:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3]
                            //    border:[UIColor blueColor]
                          // borderWidth:3];
    [self.cameraView setEnableBorderDetection:YES];
    
    [self updateTitleLabel:nil];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if ([[[SharedClass sharedManager] arrMultiPages]count] > 0) {
        
        _lblFitDocumnt.hidden = YES;

        //btnGallery.backgroundColor = btnBGColor;
        _lblPageCount.backgroundColor = ImagevwBorder;

        //[btnGallery setImage:nil forState:UIControlStateNormal];
        //[btnGallery setImage:[[[SharedClass sharedManager]arrMultiPages]lastObject] forState:UIControlStateNormal];
        
        
        if ([[SharedClass sharedManager]arrMultiPages].count==1) {
            [btnGallery setImage:[[[SharedClass sharedManager]arrMultiPages]lastObject] forState:UIControlStateNormal];
        }
        else if ([[SharedClass sharedManager]arrMultiPages].count==2) {
            [btnGallery setImage:[[[SharedClass sharedManager]arrMultiPages]lastObject] forState:UIControlStateNormal];
            
            UIImage * img1 =[[[SharedClass sharedManager]arrMultiPages] objectAtIndex:[[SharedClass sharedManager]arrMultiPages].count-2];
            
            btnGallery1.hidden = NO;
            [btnGallery1 setImage:img1 forState:UIControlStateNormal];
        }
        else if ([[SharedClass sharedManager]arrMultiPages].count>=3) {
            [btnGallery setImage:[[[SharedClass sharedManager]arrMultiPages]lastObject] forState:UIControlStateNormal];
            
            UIImage * img1 =[[[SharedClass sharedManager]arrMultiPages] objectAtIndex:[[SharedClass sharedManager]arrMultiPages].count-2];
            UIImage * img2 =[[[SharedClass sharedManager]arrMultiPages] objectAtIndex:[[SharedClass sharedManager]arrMultiPages].count-3];
            
            btnGallery1.hidden = NO;
            [btnGallery1 setImage:img1 forState:UIControlStateNormal];
            btngallery2.hidden = NO;
            [btngallery2 setImage:img2 forState:UIControlStateNormal];
        }

        
        NSString *strCountImagges = [NSString stringWithFormat:@"%ld",(unsigned long)[[SharedClass sharedManager] arrMultiPages].count];
        
        [UIView transitionWithView:_lblPageCount duration:1 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            
            //[btnGallery setTitle:strCountImagges forState:UIControlStateNormal];
            _lblPageCount.hidden = NO;
            
            // [_btnLibrary setTitle:strCountImagges forState:UIControlStateNormal];
            
            _lblPageCount.text = strCountImagges;

        } completion:nil];
        btnGallery.hidden = _lblPageCount.hidden = imgArrow.hidden = NO;
        [_lblPageCount layoutIfNeeded];

        [btnGallery layoutIfNeeded];
        btnGallery.tag = 1;
    }
    else
    {
        btnGallery.hidden = YES;
       // [btnGallery setImage:[UIImage imageNamed:@"library"] forState:UIControlStateNormal];
        btnGallery.tag = 0;
        btnGallery.layer.cornerRadius = 0;
        [btnGallery setTitle:nil forState:UIControlStateNormal];
       // btnGallery.backgroundColor = [UIColor whiteColor];
        imgArrow.hidden = YES;
        btnGallery.hidden = _lblPageCount.hidden = imgArrow.hidden = YES;

    }
    
    //Always multiple click
    self.isMultiPages = YES;
   
    [btnAutometic setTitle:@"Manual" forState:UIControlStateNormal];
    [btnAutometic setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    btnCamera.hidden = NO;
    _imgvwCameraInner.hidden = YES;
    _imgvwCameraOuter.hidden = YES;
    
    btnAutometic.tag = 0;
    [self.cameraView setEnableBorderDetection:NO];
    [[SharedClass sharedManager]setIsAutometicCapture:NO];

}
- (void) hideViewBG: (UITapGestureRecognizer *)recognizer
{
    _viewInfoBG.hidden = YES;
    _imgvwHand.hidden = YES;
    [_viewInfoBG removeGestureRecognizer:tapgesture];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.cameraView start];
    _vwCountDown.layer.cornerRadius = _vwCountDown.frame.size.width/2;
    _vwCountDown.layer.masksToBounds = YES;
    [self setTutorial];


}
-(void)setTutorial{
    if ([[SharedClass sharedManager]isFirstTimeCameraOn]) {
        tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideViewBG:)];
        tapgesture.delegate = self;
        tapgesture.numberOfTapsRequired = 1;
        [_viewInfoBG addGestureRecognizer:tapgesture];
        _viewInfoBG.hidden = NO;
        _imgvwHand.hidden = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _viewInfoBG.hidden = YES;
            _imgvwHand.hidden = YES;
            [_viewInfoBG removeGestureRecognizer:tapgesture];
        });
        
        [[SharedClass sharedManager]setIsFirstTimeCameraOn:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    // [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [super viewWillDisappear:animated];
    
    [appDelegateObj setShouldRotate:NO];
    self.cameraView.enableTorch = 0;

    [self.cameraView stop];
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

-(void)StartCameraButtonAnimation:(NSNotification *)notification {
    [self runSpinAnimationOnView:_imgvwCameraOuter duration:0.5 rotations:0.5 repeat:1.0];
    [self runSpinAnimationOnView1:_imgvwCameraInner duration:0.5 rotations:0.5 repeat:1.0];
    
}
- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat {
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat ? HUGE_VALF : 0;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
- (void) runSpinAnimationOnView1:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat {
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: -M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat ? HUGE_VALF : 0;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}



-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.cameraView prepareForOrientationChange];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        // we just want the completion handler
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.cameraView finishedOrientationChange];
    }];
}

-(void)detectOrientation
{
    UIDeviceOrientation orientationDevice = [[UIDevice currentDevice]orientation];
    
    NSTimeInterval delay = 0.4;
    
    if (orientationDevice == UIDeviceOrientationLandscapeLeft)
    {
        [UIView animateWithDuration:delay animations:^{
            
            //btnGallery.transform = btnClose.transform = btnFlash.transform = btnMultiDoc.transform = btnAutometic.transform =
            self.titleLabel.transform =CGAffineTransformMakeRotation(degreesToRadians(90));
        }];
    }
    else if (orientationDevice == UIDeviceOrientationLandscapeRight)
    {
        [UIView animateWithDuration:delay animations:^{
            
            //btnGallery.transform = btnClose.transform = btnFlash.transform = btnMultiDoc.transform = btnAutometic.transform =
            self.titleLabel.transform =CGAffineTransformMakeRotation(degreesToRadians(-90));
        }];
        
    }
    else if (orientationDevice == UIDeviceOrientationPortrait)
    {
        [UIView animateWithDuration:delay animations:^{
            
            //btnGallery.transform = btnClose.transform = btnFlash.transform = btnMultiDoc.transform = btnAutometic.transform =
            self.titleLabel.transform =CGAffineTransformIdentity;
        }];
    }
    else if (orientationDevice == UIDeviceOrientationPortraitUpsideDown)
    {
        [UIView animateWithDuration:delay animations:^{
            
           // btnGallery.transform = btnClose.transform = btnFlash.transform = btnMultiDoc.transform = btnAutometic.transform =
            self.titleLabel.transform =CGAffineTransformMakeRotation(degreesToRadians(180));
        }];
    }
}

-(void)ButtonRotate:(UIButton *)button withRotateDegree:(NSInteger )degree
{
    [UIView animateWithDuration:3.0 animations:^{
        
        //btnGallery.transform = btnClose.transform = btnFlash.transform = btnMultiDoc.transform = btnAutometic.transform = CGAffineTransformMakeRotation(degreesToRadians(degree));
    }];
    
}

- (IBAction)clk_GallaeryAndImageShow:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        GMImagePickerController *picker = [[GMImagePickerController alloc] init];
        picker.delegate = self;
        picker.title = @"";
        
        picker.customDoneButtonTitle = @"Done";
        picker.customCancelButtonTitle = @"Close";
        
        picker.colsInPortrait = 3;
        picker.colsInLandscape = 5;
        picker.minimumInteritemSpacing = 2.0;
        
        picker.modalPresentationStyle = UIModalPresentationPopover;
        
        picker.mediaTypes = @[@(PHAssetMediaTypeImage)];
        [[SharedClass sharedManager] setCameraPageGTag:1];
        
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
    else
    {
        [[SharedClass sharedManager]setCameraPageGTag:2];
        [[SharedClass sharedManager]setPages:2];
        FilterVC *filterVC = (FilterVC *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"FilterVC"];
        [self.navigationController pushViewController:filterVC animated:YES];
        
//        ImageShowVC *imgShowView = (ImageShowVC *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ImageShowVC"];
//        [self.navigationController pushViewController:imgShowView animated:YES];
    }
}

#pragma mark - CameraVC Actions

- (IBAction)clk_autometicCapture:(UIButton *)sender
{
    /*if (sender.tag == 0) {
        
        sender.tag = 1;
        btnCamera.hidden = YES;
        _imgvwCameraInner.hidden = NO;
        _imgvwCameraOuter.hidden = NO;
        
        [self runSpinAnimationOnView:_imgvwCameraOuter duration:0.5 rotations:0.5 repeat:1.0];
        [self runSpinAnimationOnView1:_imgvwCameraInner duration:0.5 rotations:0.5 repeat:1.0];

        [self.cameraView setEnableBorderDetection:YES];

        [[SharedClass sharedManager]setIsAutometicCapture:YES];
        [sender setTitle:@"Automatic" forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"auto"] forState:UIControlStateNormal];
        if ([[SharedClass sharedManager]isFirstTimeCameraOnAuto]) { // For first time tutorial
            _viewInfoBG.hidden = NO;
            _imgvwHand.hidden = NO;
            [_imgvwHand setImage:[UIImage imageNamed:@"camerahandA"]];
            [[SharedClass sharedManager]setIsFirstTimeCameraOn:YES];
            [[SharedClass sharedManager]setIsFirstTimeCameraOnAuto:NO];
            [self setTutorial];
        }

    }
    else
    {
        sender.tag = 0;
        btnCamera.hidden = NO;
        _imgvwCameraInner.hidden = YES;
        _imgvwCameraOuter.hidden = YES;
        [_imgvwCameraInner.layer removeAllAnimations];
        [_imgvwCameraOuter.layer removeAllAnimations];
        [self.titleLabel.layer removeAllAnimations];

        [self.cameraView setEnableBorderDetection:NO];

        
        [[SharedClass sharedManager]setIsAutometicCapture:NO];
        [sender setTitle:@"Manual" forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        [btnFlash setImage:[UIImage imageNamed:@"flash-on"] forState:UIControlStateNormal];
        self.cameraView.enableTorch = 0;
        

    }*/
    
    
    
}

- (IBAction)clk_multiplePages:(UIButton *)sender
{
    if (sender.tag == 0) {
        
        sender.tag = 1;
        self.isMultiPages = YES;
        [sender setImage:[UIImage imageNamed:@"multiple-off"] forState:UIControlStateNormal];
        
    }
    else
    {
        sender.tag = 0;
        self.isMultiPages = YES;

        //self.isMultiPages = NO;
        [sender setImage:[UIImage imageNamed:@"multiple-on"] forState:UIControlStateNormal];
    }
}

- (IBAction)clk_flashOffOn:(UIButton *)sender
{
    NSInteger torch;
    if ([sender.currentImage isEqual:[UIImage imageNamed:@"flash-on"]]) {
        [sender setImage:[UIImage imageNamed:@"flash-auto"] forState:UIControlStateNormal];
        torch = 2;
    }
    else if ([sender.currentImage isEqual:[UIImage imageNamed:@"flash-auto"]]){
        [sender setImage:[UIImage imageNamed:@"flash-off"] forState:UIControlStateNormal];
        torch = 1;
        
    }
    else{
        [sender setImage:[UIImage imageNamed:@"flash-on"] forState:UIControlStateNormal];
        torch = 0;
        
    }

//    if (sender.tag == 0) {
//        
//        sender.tag = 1;
//        [sender setImage:[UIImage imageNamed:@"flash-off"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        sender.tag = 0;
//        [sender setImage:[UIImage imageNamed:@"flash-on"] forState:UIControlStateNormal];
//    }
    
    
    //BOOL enable = !self.cameraView.isTorchEnabled;
    self.cameraView.enableTorch = torch;
}

- (IBAction)detctingQualityToggle:(id)sender {
    
    [self setDetectorType:(self.detectorType == IRLScannerDetectorTypeAccuracy) ?
IRLScannerDetectorTypePerformance : IRLScannerDetectorTypeAccuracy];
    
    [self updateTitleLabel:nil];
}

- (IBAction)filterToggle:(id)sender {
    
    switch (self.cameraViewType) {
        case IRLScannerViewTypeBlackAndWhite:
            [self setCameraViewType:IRLScannerViewTypeNormal];
            break;
        case IRLScannerViewTypeNormal:
            [self setCameraViewType:IRLScannerViewTypeUltraContrast];
            break;
        case IRLScannerViewTypeUltraContrast:
            [self setCameraViewType:IRLScannerViewTypeBlackAndWhite];
            break;
        default:
            break;
    }
    
    [self updateTitleLabel:nil];
}

- (IBAction)torchToggle:(id)sender {
    
    
}

- (IBAction)cancelButtonPush:(id)sender {
    
    if ([[[SharedClass sharedManager] arrMultiPages] count] > 0)
    {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:appName message:@"Are you sure you want to delete all scanned pages?" preferredStyle:UIAlertControllerStyleAlert
                                     ];
        
        UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.cancelWasTrigger = YES;
            [self.cameraView stop];
            [self updateTitleLabel:@""];
            [[[SharedClass sharedManager] arrMultiPages] removeAllObjects];
            [[SharedClass sharedManager]setPages:1];
            
            
            for (UIViewController *viewC in self.navigationController.viewControllers) {
                
                if ([viewC isKindOfClass:[ViewController class]]) {
                    
                    [self.navigationController popToViewController:viewC animated:YES];
                }
            }
            
            
        }];
        
        [alertC addAction:actionNo];
        [alertC addAction:actionYES];
        
        [self presentViewController:alertC animated:YES completion:^{
            
        }];
        
    }
    else
    {
        self.cancelWasTrigger = YES;
        [self.cameraView stop];
        [self updateTitleLabel:@""];
        [[SharedClass sharedManager]setPages:1];
        BOOL isMatched = false;
        for (UIViewController *viewC in self.navigationController.viewControllers) {
            
            if ([viewC isKindOfClass:[ViewController class]]) {
                isMatched = true;
                [self.navigationController popToViewController:viewC animated:YES];
            }
        }
        if (!isMatched){
            [self.navigationController popViewControllerAnimated:true];
        }
    }
}
- (IBAction)clk_Ques:(id)sender {
    _viewInfoBG.hidden = NO;
    _viewInfo.hidden  = NO;
    [self.cameraView stop];
    [UIView transitionWithView:_viewInfo
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                    }
                    completion:nil];

}
- (IBAction)clk_OkViewInfo:(id)sender {
    
    
    [UIView transitionWithView:_viewInfo duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
    } completion:^(BOOL finished) {
        _viewInfo.hidden  = YES;
        _viewInfoBG.hidden = YES;
        _btnQues.hidden = YES;
        [self.cameraView start];
    }];
    
}

#pragma mark - UI animations

- (void)updateTitleLabel:(NSString*)text {
    
    // CShow or not Controlle
    [self.adjust_bar setHidden:!self.showControls];
    
    // Update Button first
    BOOL detectorType = self.detectorType == IRLScannerDetectorTypePerformance;
    [self.detect_toggle setSelected:detectorType];
    
    [self.contrast_type setSelected:NO];
    [self.contrast_type setHighlighted:NO];
    
    switch (self.cameraViewType) {
        case IRLScannerViewTypeBlackAndWhite:
            [self.contrast_type setSelected:YES];
            break;
        case IRLScannerViewTypeNormal:
            break;
        case IRLScannerViewTypeUltraContrast:
            [self.contrast_type setHighlighted:YES];
            break;
        default:
            break;
    }
    
    // Update Text
    if (!text && [self.camera_PrivateDelegate respondsToSelector:@selector(cameraViewWillUpdateTitleLabel:)]) {
        text = [self.camera_PrivateDelegate cameraViewWillUpdateTitleLabel:self];
    }
    
    if (text.length == 0 || !text) {
        self.titleLabel.hidden = YES;
        return;
    }
    
    self.titleLabel.hidden = NO;
    if ([text isEqualToString:self.titleLabel.text]) {
        return;
    }
    
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    animation.duration = 0.1;
    [self.titleLabel.layer addAnimation:animation forKey:@"kCATransitionFade"];
    self.titleLabel.text = text;
}

- (void)changeButton:(UIButton *)button targetTitle:(NSString *)title toStateEnabled:(BOOL)enabled {
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:(enabled) ? [UIColor colorWithRed:1 green:0.81 blue:0 alpha:1] : [UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma mark - CameraVC Capture Image

- (IBAction)captureButton:(UIButton *)sender {
    
    if (self.cancelWasTrigger == YES) return;
   
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if ([[SharedClass sharedManager]isAutometicCapture]) {
//            
//            activityIn.hidden = NO;
//            [activityIn startAnimating];
//            btnCamera.userInteractionEnabled = NO;
//        }
//        
//    });
    
    // the Actual Capture
    
    if ([sender isKindOfClass:[UIButton class]])
    {
//        if (![[SharedClass sharedManager]isAutometicCapture]) {
//            
//            activityIn.hidden = NO;
//            [activityIn startAnimating];
//            btnCamera.userInteractionEnabled = NO;
//        }
        
      /***********
       btnCamera.hidden = YES;
        _imgvwCameraOuter.hidden = YES;
        _imgvwCameraInner.hidden = YES;**********/
        
        /*Add New***/
        
        btnCamera.hidden = YES;
        _imgvwCameraInner.hidden = NO;
        _imgvwCameraOuter.hidden = NO;
        
        [self runSpinAnimationOnView:_imgvwCameraOuter duration:0.5 rotations:0.5 repeat:1.0];
        [self runSpinAnimationOnView1:_imgvwCameraInner duration:0.5 rotations:0.5 repeat:1.0];

        /* close add new*/
        
        
        __weak  typeof(self) weakSelf = self;
        
        [weakSelf titleLabel].hidden = YES;
        [self.cameraView captureImageWithCompletionHander:^(UIImage * _Nullable image) {
            NSData * data = UIImageJPEGRepresentation(image, 0);
            image = [UIImage imageWithData:data];
            
            //image = [UIImage fixrotation:image];
            
            if (self.camera_PrivateDelegate)
            {
                if (self.isMultiPages)
                {
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
                        
                        [[[SharedClass sharedManager]arrMultiPages]addObject:image];
                        
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            [self CaptureMultipleImage];
                        });
                    });
                    
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        btnGallery.backgroundColor = btnBGColor;
                        btnGallery.tag = 1;
                        [btnGallery.layer setCornerRadius:btnGallery.frame.size.width/2];
                        [btnGallery setImage:nil forState:UIControlStateNormal];
                        
                        NSString *strCountImagges = [NSString stringWithFormat:@"%ld",(unsigned long)[[SharedClass sharedManager] arrMultiPages].count];
                        [UIView transitionWithView:btnGallery duration:1 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
                            
                            [btnGallery setTitle:strCountImagges forState:UIControlStateNormal];
                            
                        } completion:nil];
                        
                        imgArrow.hidden = NO;
                        //[self.camera_PrivateDelegate pageSnapped:image from:self];
                        [[SharedClass sharedManager]setPages:2];
                        [[SharedClass sharedManager]setCameraPageGTag:2];
                        [activityIn stopAnimating];
                        btnCamera.userInteractionEnabled = YES;
                        activityIn.hidden = YES;
                        //                            FilterVC *filterVC = (FilterVC *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"filterVC"];
                        //                            [self.navigationController pushViewController:filterVC animated:YES];
                    });
                }
            }
        }];
        
    }
    else
    {
        
        if ([[SharedClass sharedManager]isAutometicCapture]) {
            
            //            [self.cameraView captureImageWithCompletionHander:^(id data)
            //             {
            // UIImage *image = ([data isKindOfClass:[NSData class]]) ? [UIImage imageWithData:data] : data;
            
            // UIImage *orignalImage = image;
            btnCamera.hidden = YES;
            _imgvwCameraInner.hidden = YES;
            _imgvwCameraOuter.hidden = YES;

            
            [CircleDownCounter showCircleDownWithSeconds:4.0f
                                                  onView:_vwCountDown
                                                withSize:kDefaultCounterSize
                                                 andType:CircleDownCounterTypeIntegerDecre];
            __weak  typeof(self) weakSelf = self;
            
            [weakSelf titleLabel].hidden = YES;

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                __weak  typeof(self) weakSelf = self;
                
                [weakSelf titleLabel].hidden = YES;

            UIImage *image = [self.cameraView latestCorrectedUIImage];
            
            if ([[NSUserDefaults standardUserDefaults]boolForKey:NSUDKeySwitchPhoto])
            {
                UIImageWriteToSavedPhotosAlbum(image,
                                               self,
                                               @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), NULL);
            }
            
                if (image == nil)
                {
                    image = [[UIImage alloc]init];
                }
            [[[SharedClass sharedManager]arrMultiPages]addObject:image];
            
            //image = [UIImage fixrotation:image];
            
            if (self.camera_PrivateDelegate)
            {
                if (self.isMultiPages)
                {
                    //[self performSelector:@selector(CaptureMultipleImage) withObject:self afterDelay:0.50];
                    [self CaptureMultipleImage];
                    [weakSelf titleLabel].hidden = NO;
                    [weakSelf updateTitleLabel:@"  Hold Still.  "];
                    [weakSelf titleLabel].layer.cornerRadius = 15.0;
                    [weakSelf titleLabel].layer.masksToBounds = YES;

                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        btnGallery.backgroundColor = btnBGColor;
                        btnGallery.tag = 1;
                        [btnGallery.layer setCornerRadius:btnGallery.frame.size.width/2];
                        [btnGallery setImage:nil forState:UIControlStateNormal];
                        [btnGallery setImage:nil forState:UIControlStateNormal];
                        
                        NSString *strCountImagges = [NSString stringWithFormat:@"%ld",(unsigned long)[[SharedClass sharedManager] arrMultiPages].count];
                        [UIView transitionWithView:btnGallery duration:1 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
                            
                            [btnGallery setTitle:strCountImagges forState:UIControlStateNormal];
                            
                        } completion:nil];
                        imgArrow.hidden = NO;
                        //[self.camera_PrivateDelegate pageSnapped:image from:self];
                        [[SharedClass sharedManager]setPages:2];
                        [[SharedClass sharedManager]setCameraPageGTag:2];
                        [activityIn stopAnimating];
                        btnCamera.userInteractionEnabled = YES;
                        activityIn.hidden = YES;
//                        FilterVC *filterVC = (FilterVC *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"filterVC"];
//                        [self.navigationController pushViewController:filterVC animated:YES];
                        
                    });
                    
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 *NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    
                });
            }
            });
        }
        else
        {
            [activityIn stopAnimating];
            btnCamera.userInteractionEnabled = YES;
            activityIn.hidden = YES;
        }
        
    }
}

-(void)CaptureMultipleImage
{
    dispatch_async(dispatch_get_main_queue(), ^{

        btngallery2.hidden = btnGallery1.hidden =  btnGallery.hidden = _lblPageCount.hidden = imgArrow.hidden = NO;
     
        _lblPageCount.backgroundColor = ImagevwBorder;
        _lblFitDocumnt.hidden = YES;

        //btnGallery.backgroundColor = btnBGColor;
       
        //[btnGallery.layer setCornerRadius:btnGallery.frame.size.width/2];
        //[btnGallery setImage:nil forState:UIControlStateNormal];
        //imgArrow.hidden = NO;
        
       // [btnGallery setImage:[[[SharedClass sharedManager]arrMultiPages]lastObject] forState:UIControlStateNormal];

        
        if ([[SharedClass sharedManager]arrMultiPages].count==1) {
            [btnGallery setImage:[[[SharedClass sharedManager]arrMultiPages]lastObject] forState:UIControlStateNormal];
        }
        else if ([[SharedClass sharedManager]arrMultiPages].count==2) {
            [btnGallery1 setImage:[btnGallery currentImage] forState:UIControlStateNormal];
            [btnGallery setImage:[[[SharedClass sharedManager]arrMultiPages]lastObject] forState:UIControlStateNormal];
            
        }
        else if ([[SharedClass sharedManager]arrMultiPages].count>=3) {
            @autoreleasepool {
                [btngallery2 setImage:[btnGallery1 currentImage] forState:UIControlStateNormal];
                [btnGallery1 setImage:[btnGallery currentImage] forState:UIControlStateNormal];
                [btnGallery setImage:[[[SharedClass sharedManager]arrMultiPages]lastObject] forState:UIControlStateNormal];
            }
        }
    
        NSString *strCountImagges = [NSString stringWithFormat:@"%ld",(unsigned long)[[SharedClass sharedManager] arrMultiPages].count];
        
        [UIView transitionWithView:_lblPageCount duration:1 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            
           // [btnGallery setTitle:strCountImagges forState:UIControlStateNormal];
            _lblPageCount.text = strCountImagges;

        } completion:nil];
        
//        [btnGallery layoutIfNeeded];
//        [UIView setAnimationsEnabled:YES];
        btnGallery.tag = 1;
//        [self.cameraView start];
        btnCamera.userInteractionEnabled = YES;
        
       /********* old code
        btnCamera.hidden = NO;
        _imgvwCameraOuter.hidden = YES;
        _imgvwCameraInner.hidden = YES;*********/
        
        /* Add new code*/
        btnCamera.hidden = NO;
        _imgvwCameraInner.hidden = YES;
        _imgvwCameraOuter.hidden = YES;
        [_imgvwCameraInner.layer removeAllAnimations];
        [_imgvwCameraOuter.layer removeAllAnimations];
        /* close add new */
        
    //        [activityIn stopAnimating];
    //        activityIn.hidden = YES;

//                                 ImageShowVC *imgShowView = (ImageShowVC *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ImageShowVC"];
//                                 [self.navigationController pushViewController:imgShowView animated:YES];

    });
   
}

-(void)CaptureMultipleClickButton
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        btnGallery.backgroundColor = btnBGColor;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        animation.timingFunction = [CAMediaTimingFunction     functionWithName:kCAMediaTimingFunctionLinear];
        animation.fromValue = [NSNumber numberWithFloat:10.0f];
        animation.toValue = [NSNumber numberWithFloat:140.0f];
        animation.duration = 1.0;
        [btnGallery.layer setCornerRadius:btnGallery.frame.size.width/2];
        [btnGallery.layer addAnimation:animation forKey:@"cornerRadius"];
        [btnGallery setImage:nil forState:UIControlStateNormal];
        imgArrow.hidden = NO;
        
        
        NSString *strCountImagges = [NSString stringWithFormat:@"%ld",(unsigned long)[[SharedClass sharedManager] arrMultiPages].count];
        [UIView setAnimationsEnabled:NO];
        [btnGallery setTitle:strCountImagges forState:UIControlStateNormal];
        [btnGallery layoutIfNeeded];
        [UIView setAnimationsEnabled:YES];
        btnGallery.tag = 1;
        [self.cameraView start];
        [activityIn stopAnimating];
        activityIn.hidden = YES;
        btnCamera.userInteractionEnabled = YES;
        
        
//        ImageShowVC *imgShowView = (ImageShowVC *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ImageShowVC"];
//        [self.navigationController pushViewController:imgShowView animated:YES];
        
        
    });

}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        // Do anything needed to handle the error or display it to the user
    } else {
        // .... do anything you want here to handle
        // .... when the image has been saved in the photo album
    }
}

#pragma mark - IRLCameraViewProtocol

-(void)didLostConfidence:(IRLCameraView*)view {
    
    __weak  typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[weakSelf adjust_bar] setHidden:NO];
            [weakSelf updateTitleLabel:nil];
            [[weakSelf titleLabel] setBackgroundColor:[UIColor blackColor]];
        });
    
}

-(void)updateLabel:(NSTimer *)timer
{
    __weak  typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [CircleDownCounter removeCircleViewFromView:self.vwCountDown];
        
        if ([[SharedClass sharedManager]isAutometicCapture]) {
            
            if ([[SharedClass sharedManager]isQuesMrkON]) {
                
                _btnQues.hidden = NO;
                
                [UIView animateWithDuration:0.5
                                      delay:0
                                    options:UIViewKeyframeAnimationOptionAutoreverse | UIViewKeyframeAnimationOptionRepeat |UIViewKeyframeAnimationOptionAllowUserInteraction
                                 animations:^{
                                     _btnQues.transform = CGAffineTransformMakeScale(1.5, 1.5);
                                 }
                                 completion:nil];
                
                
                [[SharedClass sharedManager]setIsQuesMrkON:NO];
            }
        }

        [weakSelf updateTitleLabel:@"  Nothing found. Snap manually.  "];
        [weakSelf titleLabel].layer.cornerRadius = 15.0;
        [weakSelf titleLabel].layer.masksToBounds = YES;
        
//        [btnAutometic setTitle:@"Manual" forState:UIControlStateNormal];
//        [btnAutometic setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _imgvwCameraOuter.hidden = YES;
        _imgvwCameraInner.hidden = YES;
        btnCamera.hidden = NO;
//        [btnFlash setImage:[UIImage imageNamed:@"flash-on"] forState:UIControlStateNormal];
//        self.cameraView.enableTorch = 0;

    });
    
    [self.timerLabel invalidate];
    //self.timerLabel = nil;
}

-(void)didDetectRectangle:(IRLCameraView*)view withConfidence:(NSUInteger)confidence {
    
    if ([[SharedClass sharedManager]isAutometicCapture])
    {
        self.titleLabel.hidden = NO;
        
        if (confidence == 0) {
            
            if (self.timerLabel != nil)
            {
                //            if ([self.timerLabel isValid]) {
                //
                //                [self.timerLabel invalidate];
                //                self.timerLabel = nil;
                //            }
                
                __weak  typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([[weakSelf titleLabel].text containsString:@"Move"]) {
                        
                        _imgvwCameraOuter.hidden = NO;
                        _imgvwCameraInner.hidden = NO;
                        btnCamera.hidden = YES;
                        
                        _imgvwCameraInner.layer.timeOffset = [_imgvwCameraInner.layer convertTime:CACurrentMediaTime() fromLayer:nil];
                        _imgvwCameraInner.layer.beginTime = CACurrentMediaTime();
                        _imgvwCameraInner.layer.speed=0.5;
                        
                        _imgvwCameraOuter.layer.timeOffset = [_imgvwCameraOuter.layer convertTime:CACurrentMediaTime() fromLayer:nil];
                        _imgvwCameraOuter.layer.beginTime = CACurrentMediaTime();
                        _imgvwCameraOuter.layer.speed=0.5;

                        [weakSelf titleLabel].hidden = NO;
//                        [weakSelf updateTitleLabel:@"Searching Document..."];
                        [weakSelf updateTitleLabel:@"  Looking for document...  "];
                        [weakSelf titleLabel].layer.cornerRadius = 15.0;
                        [weakSelf titleLabel].layer.masksToBounds = YES;
                    }
                    
                });
                
                if (![self.timerLabel isValid])
                {
                    
                    self.timerLabel = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateLabel:) userInfo:nil repeats:NO];
                }
                
                
            }
            else
            {
                __weak  typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [CircleDownCounter removeCircleViewFromView:self.vwCountDown];
                    
                    
                    _imgvwCameraInner.hidden = NO;
                    _imgvwCameraOuter.hidden = NO;
                    btnCamera.hidden = YES;
                    
                    _imgvwCameraInner.layer.timeOffset = [_imgvwCameraInner.layer convertTime:CACurrentMediaTime() fromLayer:nil];
                    _imgvwCameraInner.layer.beginTime = CACurrentMediaTime();
                    _imgvwCameraInner.layer.speed=0.5;
                    
                    _imgvwCameraOuter.layer.timeOffset = [_imgvwCameraOuter.layer convertTime:CACurrentMediaTime() fromLayer:nil];
                    _imgvwCameraOuter.layer.beginTime = CACurrentMediaTime();
                    _imgvwCameraOuter.layer.speed=0.5;

                    [weakSelf titleLabel].hidden = NO;
//                    [weakSelf updateTitleLabel:@"Searching Document..."];
                    [weakSelf updateTitleLabel:@"  Looking for document...  "];

                    [weakSelf titleLabel].layer.cornerRadius = 15.0;
                    [weakSelf titleLabel].layer.masksToBounds = YES;
                    
                });
                
                self.timerLabel = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateLabel:) userInfo:nil repeats:NO];
            }
            
            return;
        }
        else
        {
            if ([self.timerLabel isValid]) {
                
                [self.timerLabel invalidate];
                self.timerLabel = nil;
            }
            
            __weak  typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                if (confidence > view.minimumConfidenceForFullDetection) {
                    
                    NSInteger range     = view.maximumConfidenceForFullDetection - view.minimumConfidenceForFullDetection;
                    CGFloat   delta     = 4.0f / range;
                    NSInteger current   = view.maximumConfidenceForFullDetection - confidence;
                    NSInteger value     = (range - range / current) * delta;
                    
                    //            [[weakSelf adjust_bar] setHidden:YES];
                    if (value == 0) {
                        //                [weakSelf.titleLabel setHidden:YES];
                        [weakSelf updateTitleLabel:[NSString stringWithFormat:@"  Move closer...  "]];
                        [weakSelf titleLabel].layer.cornerRadius = 15.0;
                        [weakSelf titleLabel].layer.masksToBounds = YES;

                    }
                    else if(value == 2)
                    {
                        [weakSelf updateTitleLabel:[NSString stringWithFormat:@"  Move closer...  "]];
                        [weakSelf titleLabel].layer.cornerRadius = 15.0;
                        [weakSelf titleLabel].layer.masksToBounds = YES;
                        
                    }
                    else if(value == 1 || value == 3)
                    {
                        //                [weakSelf.titleLabel setHidden:NO];
                        //                [weakSelf updateTitleLabel:[NSString stringWithFormat: @"... %ld ...", (long)value ]];
                        
                        [CircleDownCounter removeCircleViewFromView:self.vwCountDown];
                        
                        _imgvwCameraInner.hidden = NO;
                        _imgvwCameraOuter.hidden = NO;
                        btnCamera.hidden = YES;
                        
                        _imgvwCameraInner.layer.timeOffset = [_imgvwCameraInner.layer convertTime:CACurrentMediaTime() fromLayer:nil];
                        _imgvwCameraInner.layer.beginTime = CACurrentMediaTime();
                        _imgvwCameraInner.layer.speed=0.5;
                        
                        _imgvwCameraOuter.layer.timeOffset = [_imgvwCameraOuter.layer convertTime:CACurrentMediaTime() fromLayer:nil];
                        _imgvwCameraOuter.layer.beginTime = CACurrentMediaTime();
                        _imgvwCameraOuter.layer.speed=0.5;
                        
                        [weakSelf updateTitleLabel:@"  Hold Still.  "];
                        [weakSelf titleLabel].layer.cornerRadius = 15.0;
                        [weakSelf titleLabel].layer.masksToBounds = YES;
                        
                        //                [[weakSelf titleLabel]sizeToFit];
                        //                [[weakSelf titleLabel]layoutIfNeeded];
                    }

                    else {
                        //                [weakSelf.titleLabel setHidden:NO];
                        //                [weakSelf updateTitleLabel:[NSString stringWithFormat: @"... %ld ...", (long)value ]];
                        [weakSelf updateTitleLabel:[NSString stringWithFormat:@"  Hold Still.  "]];
                      //  [weakSelf updateTitleLabel:[NSString stringWithFormat:@"Don't Move"]];
                        [weakSelf titleLabel].layer.cornerRadius = 15.0;
                        [weakSelf titleLabel].layer.masksToBounds = YES;
                        
                        //                [[weakSelf titleLabel]sizeToFit];
                        //                [[weakSelf titleLabel]layoutIfNeeded];
                    }
                    //            [[weakSelf titleLabel] setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
                    
                } else if (confidence == 0) {
                    [CircleDownCounter removeCircleViewFromView:self.vwCountDown];
                    
                    _imgvwCameraInner.hidden = NO;
                    _imgvwCameraOuter.hidden = NO;
                    btnCamera.hidden = YES;
                    
                    _imgvwCameraInner.layer.timeOffset = [_imgvwCameraInner.layer convertTime:CACurrentMediaTime() fromLayer:nil];
                    _imgvwCameraInner.layer.beginTime = CACurrentMediaTime();
                    _imgvwCameraInner.layer.speed=0.5;
                    
                    _imgvwCameraOuter.layer.timeOffset = [_imgvwCameraOuter.layer convertTime:CACurrentMediaTime() fromLayer:nil];
                    _imgvwCameraOuter.layer.beginTime = CACurrentMediaTime();
                    _imgvwCameraOuter.layer.speed=0.5;

                    //            [[weakSelf adjust_bar] setHidden:NO];
                    [weakSelf updateTitleLabel:@"  Looking for document...  "];

                    //[weakSelf updateTitleLabel:@"Searching Document..."];
                    [weakSelf titleLabel].layer.cornerRadius = 15.0;
                    [weakSelf titleLabel].layer.masksToBounds = YES;
                    //            [[weakSelf titleLabel]sizeToFit];
                    //            [[weakSelf titleLabel]layoutIfNeeded];
                    //            [[weakSelf titleLabel] setBackgroundColor:[UIColor blackColor]];
                }
                else
                {
                    _imgvwCameraInner.hidden = NO;
                    _imgvwCameraOuter.hidden = NO;
                    btnCamera.hidden = YES;
                    
                    _imgvwCameraInner.layer.timeOffset = [_imgvwCameraInner.layer convertTime:CACurrentMediaTime() fromLayer:nil];
                    _imgvwCameraInner.layer.beginTime = CACurrentMediaTime();
                    _imgvwCameraInner.layer.speed=0.5+1.0;
                    
                    _imgvwCameraOuter.layer.timeOffset = [_imgvwCameraOuter.layer convertTime:CACurrentMediaTime() fromLayer:nil];
                    _imgvwCameraOuter.layer.beginTime = CACurrentMediaTime();
                    _imgvwCameraOuter.layer.speed=0.5+1.0;

                    [weakSelf updateTitleLabel:[NSString stringWithFormat:@"  Hold Still.  "]];

                   // [weakSelf updateTitleLabel:@"Move closer"];
                    [weakSelf titleLabel].layer.cornerRadius = 15.0;
                    [weakSelf titleLabel].layer.masksToBounds = YES;
                    //            [[weakSelf titleLabel]sizeToFit];
                    //            [[weakSelf titleLabel]layoutIfNeeded];
                }
            });
            
        }

    }
    else
    {
        self.titleLabel.hidden = YES;
    }
}

-(void)didGainFullDetectionConfidence:(IRLCameraView*)view {
    
    __weak  typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[weakSelf adjust_bar] setHidden:YES];
        [weakSelf.titleLabel setHidden:YES];
        
        //        [[weakSelf titleLabel] setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
    });
    
    
    [self captureButton:view];
    
}

#pragma mark - GMImagePickerControllerDelegate

- (void)assetsPickerController:(GMImagePickerController *)picker didFinishPickingAssets:(NSArray *)assetArray
{
    @try {
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        __block NSString *strHUDMsg = [NSString stringWithFormat:@"Loading Images"];
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
            [SVProgressHUD setBackgroundColor:svProgreesHUDColor];
            [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
            [SVProgressHUD showWithStatus:strHUDMsg];
            
            self.requestOptions = [[PHImageRequestOptions alloc] init];
            self.requestOptions.resizeMode   = PHImageRequestOptionsResizeModeNone;
            self.requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            
            // this one is key
            self.requestOptions.synchronous = true;
            
            //            CGFloat height = 0,weidth = 0;
            //            if ([@"A4" isEqualToString:@"A4"])
            //            {
            //                height = 612;
            //                weidth = 792;
            //            }
            
            [[[SharedClass sharedManager] arrMultiPages]removeAllObjects];
            
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                
                // UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectMake(0, 0, weidth, height), nil);
                
                for(PHAsset *asset in assetArray) {
                    
                    
                    //                    @autoreleasepool {
                    //
                    //                        [asset requestContentEditingInputWithOptions:option
                    //                                                   completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
                    //                                                       NSURL *imageURL = contentEditingInput.fullSizeImageURL;
                    //                                                       [[[SharedClass sharedManager]arrImageFileURL]addObject:imageURL];
                    //                                                       NSLog(@"%@",imageURL);
                    //                                                   }];
                    //                    }
                    
                    
                    // This autorelease pool seems good (a1)
                    @autoreleasepool {
                        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:[self requestOptions] resultHandler:^(UIImage *image, NSDictionary *info) {
                            
                            
                            
                            //                    UIImage *img = image;
                            //                            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0.0, img.size.width, img.size.height), nil);
                            
                            // [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
                            
                            NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Temp"];
                            // New Folder is your folder name
                            
                            // __block NSData *data = nil;
                            
                            if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
                                [[NSFileManager defaultManager] createDirectoryAtPath:stringPath withIntermediateDirectories:NO attributes:nil error:nil];
                            
                            
                            NSData *imageData = UIImageJPEGRepresentation(image, compressQuality);
                            
                            [[[SharedClass sharedManager]arrMultiPages]addObject:[UIImage imageWithData:imageData]];
                            
                            // data = UIImagePNGRepresentation(image);
                            
                            // [data writeToFile:fileName atomically:YES];
                            //                                [[SDImageCache sharedImageCache]storeImage:image forKey:fileName toDisk:NO];
                            //                                [[[SharedClass sharedManager]arrImageFileURL]addObject:fileName];
                            //data = nil;
                        }];
                    }
                }
                
                
                //  UIGraphicsEndPDFContext();
                
                
                //            [[SharedClass sharedManager]setStrURL:pdfFileName];
                //            PSPDFDocument *doc = [PSPDFDocument documentWithURL:[NSURL fileURLWithPath:pdfFileName]];
                //            [doc saveWithCompletionHandler:^(NSError * _Nullable error, NSArray<__kindof PSPDFAnnotation *> * _Nullable savedAnnotations) {
                //
                //                [SVProgressHUD dismiss];
                //            }];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                    
//                    FilterVC *filterVC = (FilterVC *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"filterVC"];
//                    [self.navigationController pushViewController:filterVC animated:YES];
                    
                });
            }];
            
        }];
        
        
        //NSLog(@"GMImagePicker: User ended picking assets. Number of selected items is: %lu", (unsigned long)assetArray.count);
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}


@end
