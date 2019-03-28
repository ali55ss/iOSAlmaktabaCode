//
//  ForgotPasswordVC.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 12/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "Users.h"
#import "VerifyEmailVC.h"
@interface ForgotPasswordVC ()

@end

@implementation ForgotPasswordVC

#pragma mark- initial Config
-(void)config{
    
    /**
     Set Static Strings
     */
    lblResetPassword.text = _static_Reset_Password;
    lblResetPassDesc.text = _static_Reset_Password_Instructions;
    txtFieldEmail.placeholder = _static_Enter_your_email;
    lblEmail.text = _static_Email;
    [btnReset setTitle:_static_Reset forState:UIControlStateNormal];
    [btnBack setTitle:_static_Back_to_Login_page forState:UIControlStateNormal];
    
    /**
     Set custom Fonts
     */
    lblResetPassword.font = [Font setFont_Bold_Size:16];
    lblResetPassDesc.font = [Font setFont_Regular_Size:13];
    lblEmail.font = [Font setFont_Medium_Size:14];
    txtFieldEmail.font = [Font setFont_Regular_Size:16];
    btnReset.titleLabel.font = [Font setFont_Medium_Size:18];
    
    /**
     Set Padding and corner radious
     */
    leftPadding(txtFieldEmail);
    setCornerRadius(txtFieldEmail.layer, 3.0, 0, nil, NO);
    setCornerRadius(btnReset.layer, 3.0, 0, nil, NO);

    
    
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

#pragma mark- Action Methods

- (IBAction)clk_btnReset:(id)sender {
    if ([self isValidForForgot]) {
        [self callWebserviceForForgotPassword];
    }
}

- (IBAction)clk_btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark- Validation
-(BOOL)isValidForForgot
{
    if (trimmedString(txtFieldEmail.text).length == 0) {
        showAlertWithErrorMessage(_error_Please_enter_your_email);
        return NO;
    }else if(![Global IsValidEmail:trimmedString(txtFieldEmail.text)]){
        showAlertWithErrorMessage(_error_Please_enter_valid_email);
        return NO;
    }
    return YES;
}
#pragma mark- API Service
-(void)callWebserviceForForgotPassword{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:trimmedString(txtFieldEmail.text) forKey:_param_email];
    [Users forgotPasswordWithData:param withCompletion:^(NSDictionary *responsedic) {
        if (responsedic) {
//            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responsedic];
//            [dict setValue:@"" forKey:_param_date_of_birth];
//
//            [userDefaults setValue:dict forKey:_static_USER_INFO];
            [self.navigationController popViewControllerAnimated:YES];
            
            
//            showVerificationMessage([NSString stringWithFormat:@"verification_code : %@",[responsedic valueForKey:_param_verification_code]]);
//
//            VerifyEmailVC *mainVC = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"VerifyEmailVC"];
//            mainVC.isForgotPassword = YES;
//            mainVC.strForgotEmail = trimmedString(txtFieldEmail.text);
//            mainVC.forgotPassword_verification_code = [responsedic valueForKey:_param_verification_code];
//            mainVC.strUserID = [responsedic valueForKey:@"id"];
//            [self.navigationController pushViewController:mainVC animated:YES];
            
        }
    }];
}
@end
