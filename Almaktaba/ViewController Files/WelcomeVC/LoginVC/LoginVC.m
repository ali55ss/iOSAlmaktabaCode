//
//  LoginVC.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 08/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "LoginVC.h"
#import "SignupVC.h"
#import "ForgotPasswordVC.h"

#import "Users.h"
#import "UploadDocsVC.h"

#import "VerifyEmailVC.h"
#import "UITextField+textfield.h"
#import "LARSAdController.h"
#import "TOLAdAdapter.h"
@interface LoginVC ()

@end

@implementation LoginVC

#pragma mark- config
-(void)config{
    
    
    /**
     Localise strings
     */
    lblWelcome.text = _static_Welcome_to_Al_Maktaba;
    lblLoginYourAccount.text = _static_Login_into_your_account;
    lblTitleEmail.text = _static_Email;
    txtEmail.placeholder = _static_Enter_your_email;
    lblTitlePassword.text = _static_Password;
    txtPassword.placeholder = _static_Enter_your_password;
    lblRememberme.text = _static_Remember_me;
    [btnLogin setTitle:_static_Login forState:UIControlStateNormal];
    lblDontHaveAccount.text = _static_Dont_have_an_account;
    [btnSignup setTitle:_static_SIGNUP forState:UIControlStateNormal];
    lblOr.text = _static_OR;
    lblCountinueAsaGuest.text = _static_Countinue_As;
    [btnGuest setTitle:_static_GUEST forState:UIControlStateNormal];
    
    /**
     Set Fonts
     */
    lblWelcome.font = [Font setFont_Medium_Size:18];
    lblLoginYourAccount.font = [Font setFont_Regular_Size:14];
    
    lblTitleEmail.font = [Font setFont_Medium_Size:14];
    txtEmail.font = [Font setFont_Regular_Size:16];
    
    lblTitlePassword.font = [Font setFont_Medium_Size:14];
    txtPassword.font = [Font setFont_Regular_Size:16];
    
    lblRememberme.font = [Font setFont_Medium_Size:12];
    btnLogin.titleLabel.font = [Font setFont_Medium_Size:18];
    
    lblOr.font = [Font setFont_Regular_Size:14];
    
    /**
     set Corner Radius
     */
    setCornerRadius(txtEmail.layer, 3.0, 0, nil, NO);
    setCornerRadius(txtPassword.layer, 3.0, 0, nil, NO);
    setCornerRadius(btnLogin.layer, 3.0, 0, nil, NO);
    
    /**
     UITextField left Padding
     */
    leftPadding(txtEmail);
    leftPadding(txtPassword);
    
    /**
     Add Forgot password btn
     */
    UIButton *forgot = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 35)];
    [forgot setTitle:_static_forgot forState:UIControlStateNormal];
    [forgot setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    forgot.titleLabel.font = [Font setFont_Bold_Size:12];
    [forgot addTarget:self action:@selector(btnForgotPasswordPressed) forControlEvents:UIControlEventTouchUpInside];
    [txtPassword setRightViewMode:UITextFieldViewModeAlways];
    [txtPassword setRightView:forgot];
    
    
    /**
     Check Remember Auth
     */
    
    isRemember = [userDefaults boolForKey:_static_IS_REMEMBER_AUTH];
    if (isRemember) {
        txtEmail.text = [userDefaults valueForKey:_static_REMEMBER_EMAIL];
        txtPassword.text = [userDefaults valueForKey:_static_REMEMBER_PASSWORD];
        [btnSwitch setImage:[UIImage imageNamed:@"ic_toggle_on"] forState:UIControlStateNormal];
    }
    
    
    //    NSURL *videoURL = [NSURL URLWithString:@"http://192.168.0.160/api_almaktaba/geturl/documents/1519820207_457676.m4v"];
    //
    //    //filePath may be from the Bundle or from the Saved file Directory, it is just the path for the video
    //    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    //    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    //    playerViewController.player = player;
    //    [playerViewController.player play];//Used to Play On start
    //    [self presentViewController:playerViewController animated:YES completion:nil];
    
}

#pragma mark- View Life Cycle
-(void)loadViewOkay{
    
    self.adVisibleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 200.f, 50.f)];
    self.adVisibleLabel.text = @"Ad not visible";
    
   // [self.view addSubview:self.adVisibleLabel];
    
    float buttonHeight = 50.0f;
    float buttonWidth = self.view.frame.size.width - 20.0f;
    // create and configure the test button at the bottom of the screen
    self.bottomTestButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.bottomTestButton.center = CGPointMake(0.0, 0.0);
    self.bottomTestButton.frame = CGRectMake(10.0f, self.view.frame.size.height - (buttonHeight + 30.0f), buttonWidth, buttonHeight);
    [self.bottomTestButton setTitle:@"this button should move up and down when an ad is shown or hidden" forState:UIControlStateNormal];
    self.bottomTestButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.bottomTestButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
   // [self.view addSubview:self.bottomTestButton];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
    
    //    UploadDocsVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"UploadDocsVC"];
    //    [self.navigationController pushViewController:mainvc animated:YES];
    [self loadViewOkay];
    
    self.adVisibleLabel.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2);
    self.adVisibleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    
   /* [[LARSAdController sharedManager] addObserver:self
                                       forKeyPath:kLARSAdObserverKeyPathIsAdVisible
                                          options:NSKeyValueObservingOptionNew
                                          context:nil];*/
    self.bannerIsVisible = NO;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[LARSAdController sharedManager] addAdContainerToViewInViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:kLARSAdObserverKeyPathIsAdVisible]) {
        NSLog(@"Observing keypath \"%@\"", keyPath);
        
        
        BOOL anyAdsVisible = [change[NSKeyValueChangeNewKey] boolValue];
        
        // get a reference to the banner that is currently visible
        UIView *bannerView;
        
        NSArray *instances = [[[LARSAdController sharedManager] adapterInstances] allValues];
        for (id <TOLAdAdapter> adapterInstance in instances) {
            if (adapterInstance.adVisible) {
                bannerView = adapterInstance.bannerView;
            }
        }
        
        if (anyAdsVisible) {
//            self.adVisibleLabel.text = @"Ad is visible";
            
            // an add either appeared for the first time or replaced an existing one.
            // either way, figure out how high to move the button, and move it
            float height = bannerView.frame.size.height;
            float padding = 0.0f;
            self.currentPushAmount = height + padding;
            
            self.bannerIsVisible = YES;
            [UIView animateWithDuration:0.25f animations:^(void) {
                CGRect screenRect = [[UIScreen mainScreen] bounds];
                
                [self.bottomTestButton setFrame:CGRectMake(self.bottomTestButton.frame.origin.x,
                                                           screenRect.size.height - (self.currentPushAmount + self.bottomTestButton.frame.size.height + 30.0f),
                                                           self.bottomTestButton.frame.size.width,
                                                           self.bottomTestButton.frame.size.height)];
            }];
            
        } else {
           // self.adVisibleLabel.text = @"Ad not visible";
            
            // no ads are visible, but if the banner is still showing, so move it back down
            if (self.bannerIsVisible) {
                self.bannerIsVisible = NO;
                [UIView animateWithDuration:0.25f animations:^(void) {
                   [self.bottomTestButton setFrame:CGRectMake(self.bottomTestButton.frame.origin.x,
                                                               self.bottomTestButton.frame.origin.y + self.currentPushAmount,
                                                               self.bottomTestButton.frame.size.width,
                                                               self.bottomTestButton.frame.size.height)];
                }];
            }
        }
    }
}

- (void)dealloc{
   // [[LARSAdController sharedManager] removeObserver:self forKeyPath:kLARSAdObserverKeyPathIsAdVisible];
}
#pragma mark- Action Methods

- (IBAction)btnSwitchPressed:(id)sender {
    if (isRemember) {
        isRemember = NO;
        [btnSwitch setImage:[UIImage imageNamed:@"ic_toggle_off"] forState:UIControlStateNormal];
    }else{
        isRemember = YES;
        [btnSwitch setImage:[UIImage imageNamed:@"ic_toggle_on"] forState:UIControlStateNormal];
    }
}

- (IBAction)btnLoginPressed:(id)sender {
    if ([self isValidForLogin]) {
        [self callWebserviceForLoginUser];
    }
}
-(void)btnForgotPasswordPressed{
    ForgotPasswordVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordVC"];
    [self.navigationController pushViewController:mainvc animated:YES];
    
}
- (IBAction)btnSignupPressed:(id)sender {
    SignupVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"SignupVC"];
    [self.navigationController pushViewController:mainvc animated:YES];
}

- (IBAction)btnFacebookPressed:(id)sender {
    [self loginwithFacebook];
}


- (IBAction)btnGooglePressed:(id)sender {
    //    [self.signInButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    [[GIDSignIn sharedInstance] signOut];
    
    [Global ShowHUDwithAnimation:YES];
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate   = self;
    
    NSArray *additionalScopes = @[@"https://www.googleapis.com/auth/contacts.readonly",
                                  @"https://www.googleapis.com/auth/plus.login",
                                  @"https://www.googleapis.com/auth/plus.me"];
    [GIDSignIn sharedInstance].scopes = [[GIDSignIn sharedInstance].scopes arrayByAddingObjectsFromArray:additionalScopes];
    
    [[GIDSignIn sharedInstance] signIn];
    
}

- (IBAction)btnGuestPressed:(id)sender {
    
    if([userDefaults boolForKey:_static_IS_LOGEDIN_AS_GUEST]){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self callWebsreviceForLoginAsaGuest];
    }
    
}

#pragma mark- Validation
-(BOOL)isValidForLogin
{
    if (trimmedString(txtEmail.text).length == 0) {
        showAlertWithErrorMessage(_error_Please_enter_your_email);
        return NO;
    }else if(![Global IsValidEmail:trimmedString(txtEmail.text)]){
        showAlertWithErrorMessage(_error_Please_enter_valid_email);
        return NO;
    }else if (trimmedString(txtPassword.text).length == 0) {
        showAlertWithErrorMessage(_error_Please_enter_your_password);
        return NO;
    }else if (trimmedString(txtPassword.text).length < 6) {
        showAlertWithErrorMessage(_error_password_limit);
        return NO;
    }
    return YES;
}
- (IBAction)emailTextFieldBeginEdit:(id)sender {
    
    isEmailField = YES;
}

- (IBAction)emailTextFieldEndEdit:(id)sender {
    isEmailField = NO;
}
- (UITextInputMode *) textInputMode {
    
    if(isEmailField) {
        for (UITextInputMode *inputMode in [UITextInputMode activeInputModes]) {
            
            if([inputMode.primaryLanguage isEqualToString:@"en-US"]) {
                return inputMode;
            }
        }
    }
    return [super textInputMode];
}
#pragma mark- Login with facebook
-(void)loginwithFacebook{
    
    FBSDKLoginManager *manager = [[FBSDKLoginManager alloc] init];
    manager.loginBehavior = FBSDKLoginBehaviorWeb;
    [manager logInWithReadPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
            [Global HideHUDwithAnimation:YES];
            showAlertWithErrorMessage(error.localizedDescription);
            
        } else if (result.isCancelled) {
            // Handle cancellations
            
            [Global HideHUDwithAnimation:YES];
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            [Global ShowHUDwithAnimation:YES];
            
            if ([result.grantedPermissions containsObject:@"email"]) {
                if ([FBSDKAccessToken currentAccessToken]) {
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, first_name, last_name, email, birthday, gender, picture.type(large)"}]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         if (!error) {
                             NSLog(@"fetched user:%@", result);
                             [Global HideHUDwithAnimation:YES];
                             //
                             [self callWebserviceForLoginUserWithFacebook:result];
                             
                         }
                         else{
                             NSLog(@"error%@",error.localizedDescription);
                             showAlertWithErrorMessage(error.localizedDescription);
                             [Global HideHUDwithAnimation:YES];
                         }
                     }];
                }else{
                    [Global HideHUDwithAnimation:YES];
                }
            }
        }
    }];
}

#pragma mark- Login with google
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    [Global HideHUDwithAnimation:YES];
}
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (!error) {
        [Global HideHUDwithAnimation:YES];
        
        // Perform any operations on signed in user here.
        //        NSString *userId = user.userID;                  // For client-side use only!
        //        NSString *idToken = user.authentication.idToken; // Safe to send to the server
        //        NSString *fullName = user.profile.name;
        NSString *givenName = user.profile.givenName;
        NSString *familyName = user.profile.familyName;
        NSString *email = user.profile.email;
        //        NSString *profileImage = [[user.profile imageURLWithDimension:150] absoluteString];
        
        NSMutableDictionary  *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:email forKey:_param_email];
        [dict setValue:givenName forKey:_param_firstname];
        [dict setValue:familyName forKey:_param_lastname];
        [dict setValue:_static_REGISTER_TYPE_GOOGLE forKey:_param_register_type];
        [dict setValue:_static_ROLL_ID forKey:_param_role_id];
        [dict setValue:[Global generateRandomPassword] forKey:_param_password];
        
        [self loginUserWithSocialAccount:dict];
        
    }else{
        [Global HideHUDwithAnimation:YES];
        
        //showAlertWithErrorMessage(LocalizedString(error.localizedDescription));
    }
    
    // ...
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark- API
-(void)callWebserviceForLoginUser{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:trimmedString(txtEmail.text) forKey:_param_email];
    [param setValue:trimmedString(txtPassword.text) forKey:_param_password];
    [param setValue:_static_ROLL_ID forKey:_param_role_id];
    [param setValue:_static_REGISTER_TYPE  forKey:_param_register_type];
    
    [Users loginUserWithData:param withCompletion:^(NSDictionary *responsedic) {
        if (responsedic) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responsedic];
            [dict setValue:@"" forKey:_param_date_of_birth];
            
            if ([[dict valueForKey:_param_status] intValue]) {
                if ([[dict valueForKey:_static_userdepartments] count]) {
                    [userDefaults setValue:[[dict valueForKey:_static_userdepartments] firstObject] forKey:_static_userdepartments];
                    [userDefaults setBool:YES forKey:_static_USER_ENROLLED_DEPT];
                }else{
                    [userDefaults removeObjectForKey:_static_userdepartments];
                    [userDefaults setBool:NO forKey:_static_USER_ENROLLED_DEPT];
                }
                
                [dict removeObjectForKey:_static_userdepartments];
                [userDefaults setValue:[NSKeyedArchiver archivedDataWithRootObject:dict] forKey:_static_USER_INFO];
                
                [userDefaults setBool:YES forKey:_static_IS_ALLREADY_LOGEDIN];
                [userDefaults setBool:isRemember forKey:_static_IS_REMEMBER_AUTH];
                
                [userDefaults setValue:trimmedString(txtEmail.text) forKey:_static_REMEMBER_EMAIL];
                [userDefaults setValue:trimmedString(txtPassword.text) forKey:_static_REMEMBER_PASSWORD];
                [userDefaults setBool:NO forKey:_static_IS_LOGEDIN_AS_GUEST];
                
                [userDefaults synchronize];
                
                [appDelegateObj addSlideMenuAfterLogin];
                
            }else{
                
                [dict removeObjectForKey:_static_userdepartments];
                [userDefaults setValue:[NSKeyedArchiver archivedDataWithRootObject:dict] forKey:_static_USER_INFO];
                [userDefaults setBool:NO forKey:_static_IS_LOGEDIN_AS_GUEST];
                
                [userDefaults synchronize];
                
                VerifyEmailVC *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VerifyEmailVC"];
                mainVC.strUserID = [responsedic valueForKey:_param_id];
                mainVC.verification_code = [responsedic valueForKey:_param_verification_code];
                mainVC.strForgotEmail = trimmedString(txtEmail.text);
                [self.navigationController pushViewController:mainVC animated:YES];
            }
        }
    }];
}

-(void)callWebserviceForLoginUserWithFacebook:(id )result{
    NSMutableDictionary  *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[result valueForKey:@"email"] forKey:_param_email];
    [dict setValue:[result valueForKey:@"first_name"] forKey:_param_firstname];
    [dict setValue:[result valueForKey:@"last_name"] forKey:_param_lastname];
    [dict setValue:_static_REGISTER_TYPE_FACEBOOK forKey:_param_register_type];
    [dict setValue:_static_ROLL_ID forKey:_param_role_id];
    [dict setValue:[Global generateRandomPassword] forKey:_param_password];
    [dict setValue:[result valueForKeyPath:@"picture.data.url"] forKey:_param_profile_image];

        [self loginUserWithSocialAccount:dict];
    
//    UIImageView *imgView = [[UIImageView alloc] init];
//    [self.view addSubview:imgView];
//    [imgView sd_setImageWithURL:[NSURL URLWithString:[result valueForKeyPath:@"picture.data.url"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        [imgView removeFromSuperview];
//        if (!error) {
//            [Users uploadImageWithData:UIImageJPEGRepresentation(image, 1) withCompletion:^(NSString *_fileName) {
//                [dict setValue:_fileName forKey:_param_profile_image];
//                [self loginUserWithSocialAccount:dict];
//            }];
//        }else{
//            [self loginUserWithSocialAccount:dict];
//        }
//    }];
}

-(void)loginUserWithSocialAccount:(NSMutableDictionary*)param{
    [Users loginUserWithData:param
              withCompletion:^(NSDictionary *responsedic) {
                  if (responsedic) {
                      NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responsedic];
                      [dict setValue:@"" forKey:_param_date_of_birth];
                      
                      if ([[dict valueForKey:_static_userdepartments] count]) {
                          [userDefaults setValue:[[dict valueForKey:_static_userdepartments] firstObject] forKey:_static_userdepartments];
                          [userDefaults setBool:YES forKey:_static_USER_ENROLLED_DEPT];
                      }else{
                          [userDefaults removeObjectForKey:_static_userdepartments];
                          [userDefaults setBool:NO forKey:_static_USER_ENROLLED_DEPT];
                      }
                      
                      [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:dict] forKey:_static_USER_INFO];
                      [userDefaults setBool:YES forKey:_static_IS_ALLREADY_LOGEDIN];
                      [userDefaults setBool:NO forKey:_static_IS_REMEMBER_AUTH];
                      [userDefaults setBool:NO forKey:_static_IS_LOGEDIN_AS_GUEST];
                      
                      [userDefaults synchronize];
                      
                      [appDelegateObj addSlideMenuAfterLogin];
                  }
              }];
}


#pragma mark- Loagin as a Guest
-(void)callWebsreviceForLoginAsaGuest{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:@"guestuser@gmail.com" forKey:_param_email];
    [param setValue:@"guest" forKey:_param_password];
    [param setValue:@"3" forKey:_param_role_id];
    [param setValue:_static_REGISTER_TYPE  forKey:_param_register_type];
    [Users loginUserWithData:param withCompletion:^(NSDictionary *responsedic) {
        if(responsedic){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responsedic];
            [dict setValue:@"" forKey:_param_date_of_birth];
            
            [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:dict] forKey:_static_USER_INFO];
            [userDefaults setBool:YES forKey:_static_IS_ALLREADY_LOGEDIN];
            //            [userDefaults setBool:NO forKey:_static_IS_REMEMBER_AUTH];
            [userDefaults setBool:YES forKey:_static_IS_LOGEDIN_AS_GUEST];
            [userDefaults synchronize];
            
            [appDelegateObj addSlideMenuAfterLogin];
        }
    }];
}

@end
