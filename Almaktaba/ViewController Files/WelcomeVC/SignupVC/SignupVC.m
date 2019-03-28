//
//  SignupVC.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 08/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "SignupVC.h"
#import "Users.h"

#import "VerifyEmailVC.h"

@interface SignupVC ()

@end

@implementation SignupVC

#pragma mark- config
-(void)config{
    /**
     Localise strings
     */
    lblSeeYouAgain.text = _static_Good_to_see_you_again;
    lblSignupNewUser.text = _static_Signup_for_new_user;
    lblTitleEmail.text = _static_Email;
    txtEmail.placeholder = _static_Enter_your_email;
    lblTitlePassword.text = _static_Password;
    txtPassword.placeholder = _static_Enter_your_password;
    lblTitleConfirmPassword.text = _static_Confirm_password;
    txtConfirmPassword.placeholder = _static_Confirm_your_password;
    [btnLogin setTitle:_static_LOGIN forState:UIControlStateNormal];
    lblAlreadyAccount.text = _static_Already_have_an_account;
    [btnSignup setTitle:_static_Signup forState:UIControlStateNormal];
    
    /**
     Set Fonts
     */
    lblSeeYouAgain.font = [Font setFont_Medium_Size:18];
    lblSignupNewUser.font = [Font setFont_Regular_Size:14];
    
    lblTitleEmail.font = [Font setFont_Medium_Size:14];
    txtEmail.font = [Font setFont_Regular_Size:16];
    
    lblTitlePassword.font = [Font setFont_Medium_Size:14];
    txtPassword.font = [Font setFont_Regular_Size:16];
    
    lblTitleConfirmPassword.font = [Font setFont_Medium_Size:14];
    txtConfirmPassword.font = [Font setFont_Regular_Size:16];

    
    btnShowPassword.titleLabel.font = [Font setFont_Medium_Size:12];
    btnShowConfirmPassword.titleLabel.font = [Font setFont_Medium_Size:12];

    btnLogin.titleLabel.font = [Font setFont_Bold_Size:12];
    btnSignup.titleLabel.font = [Font setFont_Medium_Size:18];

    lblAlreadyAccount.font = [Font setFont_Medium_Size:12];
    
    
    /**
     set Corner Radius
     */
    setCornerRadius(txtEmail.layer, 3.0, 0, nil, NO);
    setCornerRadius(txtPassword.layer, 3.0, 0, nil, NO);
    setCornerRadius(txtConfirmPassword.layer, 3.0, 0, nil, NO);
    setCornerRadius(btnSignup.layer, 3.0, 0, nil, NO);
    
    /**
     UITextField left Padding
     */
    leftPadding(txtEmail);
    leftPadding(txtPassword);
    leftPadding(txtConfirmPassword);
    
}

#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self config];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (IBAction)clk_btnShowPassword:(id)sender {
    if (txtPassword.secureTextEntry) {
        [sender setTitle:_static_Hide forState:UIControlStateNormal];
        txtPassword.secureTextEntry = NO;
    }else{
        [sender setTitle:_static_Show forState:UIControlStateNormal];
        txtPassword.secureTextEntry = YES;
    }
}

- (IBAction)clk_btnShowConfirmPassword:(id)sender {
    if (txtConfirmPassword.secureTextEntry) {
        [sender setTitle:_static_Hide forState:UIControlStateNormal];
        txtConfirmPassword.secureTextEntry = NO;
    }else{
        [sender setTitle:_static_Show forState:UIControlStateNormal];
        txtConfirmPassword.secureTextEntry = YES;
    }
}

- (IBAction)clk_btnSignup:(id)sender {
    if ([self isValidForSignup]) {
     
        [self callWebserviceForRegisterUser];
    }
}

- (IBAction)clk_btnLogin:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark- Validation
-(BOOL)isValidForSignup{
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
    }else if (trimmedString(txtConfirmPassword.text).length == 0) {
        showAlertWithErrorMessage(_error_Please_confirm_password);
        return NO;
    }else if (![trimmedString(txtPassword.text) isEqualToString:trimmedString(txtConfirmPassword.text)]) {
        showAlertWithErrorMessage(_error_Please_check_password_confirm_password);
        return NO;
    }
    return YES;
}

#pragma mark- Call WebService
-(void)callWebserviceForRegisterUser{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:trimmedString(txtEmail.text) forKey:_param_email];
    [param setValue:trimmedString(txtPassword.text) forKey:_param_password];
    [param setValue:_static_ROLL_ID forKey:_param_role_id];
    [param setValue:_static_REGISTER_TYPE  forKey:_param_register_type];
    
    [Users registerUserWithData:param withCompletion:^(NSDictionary *responsedic) {
        if (responsedic) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responsedic];
            [dict setValue:@"" forKey:_param_date_of_birth];
            
            [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:dict] forKey:_static_USER_INFO];
            [userDefaults setBool:NO forKey:_static_IS_ALLREADY_LOGEDIN];
            [userDefaults setBool:NO forKey:_static_IS_REMEMBER_AUTH];
            
            [userDefaults synchronize];
            
           // showVerificationMessage([NSString stringWithFormat:@"verification_code : %@",[responsedic valueForKey:_param_verification_code]]);

//            [self.navigationController popViewControllerAnimated:YES];
            
            VerifyEmailVC *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VerifyEmailVC"];
            mainVC.strUserID = [responsedic valueForKey:_param_id];
            mainVC.verification_code = [responsedic valueForKey:_param_verification_code];
            mainVC.strForgotEmail = trimmedString(txtEmail.text);
            [self.navigationController pushViewController:mainVC animated:YES];
        }
    }];

}

@end
