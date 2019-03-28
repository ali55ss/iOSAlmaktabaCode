//
//  VerifyEmailVC.m
//  ContactBackup
//
//  Created by TechnoMac-11 on 16/01/18.
//  Copyright © 2018 TechnoMac-5. All rights reserved.
//

#import "VerifyEmailVC.h"
#import "Users.h"
//#import "Devices.h"
#import "NewPasswordVC.h"
@interface VerifyEmailVC ()

@end

@implementation VerifyEmailVC
#pragma mark- Config
-(void)config{
    /**
     set Static String
     */
    
    
    lblInfo.text = _static_Registration_Successful_Info;
    lblEnterOTP.text = _static_Enter_OTP_Number;
    [btnNotReceiveOTP setTitle:_static_not_receive_varification_code forState:UIControlStateNormal];
    [btnBack setTitle:_static_Back_to_Login_page forState:UIControlStateNormal];
    
    /**
     setFont and Color
     */
    
    lblTitle.font = [Font setFont_Bold_Size:18];
    lblInfo.font = [Font setFont_Regular_Size:13];
    lblEnterOTP.font = [Font setFont_Medium_Size:16];
    btnSubmit.titleLabel.font = [Font setFont_Medium_Size:16];
    btnNotReceiveOTP.titleLabel.font = [Font setFont_Medium_Size:13];

    lblTitle.textColor = theme_Black_Color;
    lblInfo.textColor = theme_Gray_Color;
    [btnNotReceiveOTP setTitleColor:theme_Blue_Color forState:UIControlStateNormal];
    
    /**
     set corner radious
     */
    
    setCornerRadius(btnSubmit.layer, 3.0, 0, nil, NO);

     
    inputField.keyboardType = UIKeyboardTypeNumberPad;
    inputField.delegate = self;
    inputField.secureTextEntry = YES;
    inputField.autocorrectionType = UITextAutocorrectionTypeNo;
    inputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    
    labels = [NSArray arrayWithObjects:
              fieldOneLabel,
              fieldTwoLabel,
              fieldThreeLabel,
              fieldFourLabel,
              nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:inputField];
    // to identify textfield text change or not
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textFieldTextDidChangeOneCI:)
     name:UITextFieldTextDidChangeNotification
     object:inputField];
    
    
//    if (self.isForgotPassword) {
////        [btnBack setHidden:NO];
//        lblTitle.text = self.strForgotEmail;
//    }
    
     lblTitle.text = self.strForgotEmail;
}
#pragma mark- View life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self config];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction

- (IBAction)btnBackOtherPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSubmitPressed:(id)sender {
    if(inputField.text.length == 0){
        showAlertWithErrorMessage(_error_OTP);
    }else{
        if (self.isForgotPassword) {
            if ([inputField.text intValue] == [self.forgotPassword_verification_code intValue]) {
                NewPasswordVC *mainVC = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"NewPasswordVC"];
                mainVC.strUserID = self.strUserID;
                [self.navigationController pushViewController:mainVC animated:YES];
                [self wrong];
                
            }else{
                [self wrong];
                showAlertWithErrorMessage(_error_valid_OTP);
            }
        }else{
            
            if ([inputField.text intValue] == [self.verification_code intValue]) {
                NSMutableDictionary *dict  = [[NSMutableDictionary alloc] init];
                [dict setValue:inputField.text forKey:_param_ActivationCode];
                [dict setValue:self.strUserID  forKey:_param_id];
                [self callServicesForVerifyUser:dict];
                
            }else{
                [self wrong];
                showAlertWithErrorMessage(_error_valid_OTP);
            }
        }
    }
}

- (IBAction)btnReSendEmailPressed:(id)sender {
    if (self.isForgotPassword) {
        [self wrong];
        NSMutableDictionary *dict  = [[NSMutableDictionary alloc] init];
        [dict setValue:self.strForgotEmail forKey:_param_email];
        [dict setValue:_static_ROLL_ID forKey:_param_role_id];
        [self callWebserviceForResetPasswords:dict];
    }else{
        NSMutableDictionary *dict  = [[NSMutableDictionary alloc] init];
        [dict setValue:self.strUserID  forKey:_param_id];
        [self callServicesForResendCode:dict];
    }
}

- (IBAction)btnBackPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark- Textfield Delegate Methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == inputField) {
        if ([textField.text length] == 4 && [string length] > 0) {
            return NO;
        }
        else {
            return YES;
        }
    }
    
    return YES;
}
-(void)textFieldTextDidChangeOneCI:(NSNotification *)notification{
    UITextField *textfield=[notification object];
    if (textfield == inputField) {
        [self updatePasscodeDisplay];
    }
}

#pragma mark- Supporting OTP methods
- (void)updatePasscodeDisplay {
    NSUInteger length = [inputField.text length];
    for (NSUInteger i = 0; i < 4; i++) {
        UILabel *label = [labels objectAtIndex:i];
        label.text = (i < length) ? @"●" : @"-";
    }
    if (length == 4) {
        
    }
}
- (void)resetInput {
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        inputField.text = @"";
        [self updatePasscodeDisplay];
    });
}
- (void)wrong {
    [self resetInput];
}


#pragma mark- WEBSERVICE

-(void)callServicesForVerifyUser:(NSDictionary *)dict {
    QueryModel *model = [[QueryModel alloc] initWithClass:[Users class]];
    [model verifyUserWithVarificationCode:dict withLoading:YES showToastOnSuccess:YES withCompletion:^(NSDictionary *responsedic) {
        if (responsedic) {
//            [userDefaults setBool:YES forKey:ISLOGGED];
            [userDefaults setValue:self.strUserID forKey:_param_id];
//            [userDefaults setBool:NO forKey:ISREMIND];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responsedic];
            [dict setValue:@"" forKey:_param_date_of_birth];
            
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
            [userDefaults setBool:NO forKey:_static_IS_REMEMBER_AUTH];
            
            [userDefaults synchronize];
            [appDelegateObj addSlideMenuAfterLogin];

        }else{
            [self wrong];
        }
    }];
}

-(void)callServicesForResendCode:(NSDictionary *)dict{
    QueryModel *model = [[QueryModel alloc] initWithClass:[Users class]];
    [model resendVerificationCodeWithData:dict withCompletion:^(NSDictionary *resposeDic) {
        if (resposeDic) {
                self.verification_code = [resposeDic valueForKey:_param_verification_code];
           // showVerificationMessage([NSString stringWithFormat:@"verification_code : %@",[resposeDic valueForKey:_param_verification_code]]);
        }
    }];
}


#pragma mark- WEBSERVICE
-(void)callWebserviceForResetPasswords:(NSMutableDictionary*)dic{
    QueryModel *query = [[QueryModel alloc] initWithClass:[Users class]];
    [query forgotPasswordWithData:dic withCompletion:^(NSDictionary *resposeDic) {
        if (resposeDic) {
            self.forgotPassword_verification_code = [resposeDic valueForKey:_param_verification_code];
            //showVerificationMessage([NSString stringWithFormat:@"verification_code : %@",[resposeDic valueForKey:_param_verification_code]]);
        }
    }];
}
@end
