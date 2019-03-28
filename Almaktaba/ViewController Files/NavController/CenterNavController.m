//
//  CenterNavController.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 12/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "CenterNavController.h"
#import "PreviewForAllDocs.h"
@interface CenterNavController ()

@end

@implementation CenterNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: theme_Blue_Color,NSFontAttributeName:[Font setFont_Bold_Size:18]};
  
    self.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationBar setBottomBorderColor:[UIColor whiteColor] height:1];
    
    [self.navigationBar setTintColor:theme_Blue_Color];
    
    NSDictionary *barButtonAppearanceDict = @{NSFontAttributeName : [Font setFont_SemiBold_Size:18], NSForegroundColorAttributeName: theme_Blue_Color};
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];


//    [[UIBarButtonItem appearance] setTintColor:theme_Blue_Color];

//    CGRect frame = self.toolbar.frame;
//    frame.size.height = 50;
//    self.toolbar.frame = frame;
    
    [self setupBannerView];
}
-(CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, 85);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark- Banner view
-(void)setupBannerView{
    // In this case, we instantiate the banner with desired ad size.
    self.bannerView = [[GADBannerView alloc]
                       initWithAdSize:kGADAdSizeBanner];
    
    self.bannerView.delegate = self;
    self.bannerView.adUnitID = AdUnitID;
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
#if DEBUG
//    request.testDevices = @[ @"ed19f50d57e163afb03eae91f68718aa" ];
    request.testDevices = @[ @"a6bae79d0df8a78ab92a3af86b54e3dd" ];
#endif
    
    [self.bannerView loadRequest:request];
    
}
- (void)addBannerViewToView:(UIView *)bannerView {
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bannerView];
    
    if (@available(ios 11.0, *)) {
        // In iOS 11, we need to constrain the view to the safe area.
        [self positionBannerViewFullWidthAtBottomOfSafeArea:bannerView];
    } else {
        // In lower iOS versions, safe area is not available so we use
        // bottom layout guide and view edges.
        [self positionBannerViewFullWidthAtBottomOfView:bannerView];
    }
}
#pragma mark - view positioning

- (void)positionBannerViewFullWidthAtBottomOfSafeArea:(UIView *_Nonnull)bannerView NS_AVAILABLE_IOS(11.0) {
    // Position the banner. Stick it to the bottom of the Safe Area.
    // Make it constrained to the edges of the safe area.
    UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
    
    [NSLayoutConstraint activateConstraints:@[
                                              [guide.leftAnchor constraintEqualToAnchor:bannerView.leftAnchor],
                                              [guide.rightAnchor constraintEqualToAnchor:bannerView.rightAnchor],
                                              [guide.bottomAnchor constraintEqualToAnchor:bannerView.bottomAnchor]
                                              ]];
}

- (void)positionBannerViewFullWidthAtBottomOfView:(UIView *_Nonnull)bannerView {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.bottomLayoutGuide
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
}
#pragma mark - bannerview delegate
/// Tells the delegate an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"adViewDidReceiveAd");
    
    if(![self.presentedViewController isKindOfClass:[PreviewForAllDocs class]]){
        [self.bannerView removeFromSuperview];
        [self setToolbarHidden:NO];
        [self.toolbar addSubview:self.bannerView];
    }
    

    //[self addBannerViewToView:self.bannerView];
    adView.alpha = 0;
    [UIView animateWithDuration:1.0 animations:^{
        adView.alpha = 1;
    }];
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that a full-screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillPresentScreen");
}

/// Tells the delegate that the full-screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillDismissScreen");
}

/// Tells the delegate that the full-screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewDidDismissScreen");
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"adViewWillLeaveApplication");
}
@end

#pragma mark-
@implementation UINavigationBar (Helper)

- (void)setBottomBorderColor:(UIColor *)color height:(CGFloat)height {
    CGRect bottomBorderRect = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), height);
    UIView *bottomBorder = [[UIView alloc] initWithFrame:bottomBorderRect];
    [bottomBorder setBackgroundColor:color];
    [self addSubview:bottomBorder];
}

@end

