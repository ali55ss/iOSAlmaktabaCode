//
//  LoginVC.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 08/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "GoogleSignIn/GoogleSignIn.h"
@interface LoginVC : UIViewController <GIDSignInDelegate, GIDSignInUIDelegate>
{
    
    BOOL isRemember;
    BOOL isEmailField;
    __weak IBOutlet UILabel *lblWelcome;
    __weak IBOutlet UILabel *lblLoginYourAccount;
    
    __weak IBOutlet UILabel *lblTitleEmail;
    __weak IBOutlet UITextField *txtEmail;
    
    __weak IBOutlet UILabel *lblTitlePassword;
    __weak IBOutlet UITextField *txtPassword;
    __weak IBOutlet UILabel *lblRememberme;
    __weak IBOutlet UIButton *btnSwitch;
    __weak IBOutlet UIButton *btnLogin;
    __weak IBOutlet UILabel *lblDontHaveAccount;
    __weak IBOutlet UIButton *btnSignup;
    __weak IBOutlet UILabel *lblOr;
    
    __weak IBOutlet UILabel *lblCountinueAsaGuest;
    __weak IBOutlet UIButton *btnGuest;
    
}
- (IBAction)btnSwitchPressed:(id)sender;
- (IBAction)btnLoginPressed:(id)sender;
- (IBAction)btnSignupPressed:(id)sender;
- (IBAction)btnFacebookPressed:(id)sender;
- (IBAction)btnGooglePressed:(id)sender;
- (IBAction)btnGuestPressed:(id)sender;

@property(weak, nonatomic) GIDSignInButton *signInButton;

@property (nonatomic) BOOL bannerIsVisible;                 // shows if an ad is visible on this view or not
@property (nonatomic) float currentPushAmount;              // the amount that the test button (or anything else) is being pushed up at the moment
@property (nonatomic, retain) UILabel *adVisibleLabel;
@property (nonatomic, retain) UIButton *bottomTestButton;
@end
