//
//  ChangePassVC.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 05/03/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "ChangePassVC.h"
#import "Users.h"
@interface ChangePassVC ()

@end

@implementation ChangePassVC

#pragma mark- comman Init
-(void)commanInit{
    /**
     Localise strings
     */
    lblTitle.text = _static_Change_Password;
    lblCurrentPass.text = _static_Current_Password;
    txtCurrentPass.placeholder = _static_Enter_your_current_password;
    
    lblNewPass.text = _static_New_Password;
    txtNewPass.placeholder = _static_Enter_your_new_password;
    
    lblConfirmPass.text = _static_Confirm_password;
    txtConfirmPass.placeholder = _static_Confirm_your_new_password;

    [btnSubmit setTitle:_static_Submit forState:UIControlStateNormal];

    /**
     Set Corner Radious
     */
    setCornerRadius(txtCurrentPass.layer, 3.0, 0, nil, NO);
    setCornerRadius(txtNewPass.layer, 3.0, 0, nil, NO);
    setCornerRadius(txtCurrentPass.layer, 3.0, 0, nil, NO);
    setCornerRadius(btnSubmit.layer, 3.0, 0, nil, NO);
    
    /**
     
     Set appearense
     */
    lblTitle.textColor = theme_Black_Color;
    lblCurrentPass.textColor = theme_Black_Color;
    txtCurrentPass.textColor = theme_Black_Color;
    lblNewPass.textColor = theme_Black_Color;
    txtNewPass.textColor = theme_Black_Color;
    lblConfirmPass.textColor = theme_Black_Color;
    txtConfirmPass.textColor = theme_Black_Color;
    lblTitle.font = [Font setFont_Medium_Size:18];

    lblCurrentPass.font = [Font setFont_Medium_Size:14];
    txtCurrentPass.font = [Font setFont_Regular_Size:16];
    lblNewPass.font = [Font setFont_Medium_Size:14];
    txtNewPass.font = [Font setFont_Regular_Size:16];
    lblConfirmPass.font = [Font setFont_Medium_Size:14];
    txtConfirmPass.font = [Font setFont_Regular_Size:16];

    btnSubmit.titleLabel.font = [Font setFont_Medium_Size:18];

    /**
     UITextField left Padding
     */
    leftPadding(txtCurrentPass);
    leftPadding(txtNewPass);
    leftPadding(txtConfirmPass);
    
    
    /**
     Add Show password btn
     */
    UIButton *showPassword = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 35)];
    [showPassword setTitle:_static_Show forState:UIControlStateNormal];
    [showPassword setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    showPassword.titleLabel.font = [Font setFont_Bold_Size:12];
    [showPassword addTarget:self action:@selector(btnShowPasswordPressed:) forControlEvents:UIControlEventTouchUpInside];
    [txtNewPass setRightViewMode:UITextFieldViewModeAlways];
    [txtNewPass setRightView:showPassword];
    
    UIButton *showConfirmPassword = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 35)];
    [showConfirmPassword setTitle:_static_Show forState:UIControlStateNormal];
    [showConfirmPassword setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    showConfirmPassword.titleLabel.font = [Font setFont_Bold_Size:12];
    [showConfirmPassword addTarget:self action:@selector(btnShowConfirmPasswordPressed:) forControlEvents:UIControlEventTouchUpInside];
    [txtConfirmPass setRightViewMode:UITextFieldViewModeAlways];
    [txtConfirmPass setRightView:showConfirmPassword];
}
#pragma mark- View Life  Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self commanInit];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Action Methods
- (IBAction)clk_btnSubmit:(id)sender {
    if ([self isValidForChangePassword]) {
        [self callWebserviceForChangePassword];
    }
}
-(void)btnShowPasswordPressed:(UIButton*)sender{
    if (isShowPassword) {
        isShowPassword = NO;
        [sender setTitle:_static_Show forState:UIControlStateNormal];
        txtNewPass.secureTextEntry = YES;
    }else{
        isShowPassword = YES;
        [sender setTitle:_static_Hide forState:UIControlStateNormal];
        txtNewPass.secureTextEntry = NO;
    }
}
-(void)btnShowConfirmPasswordPressed:(UIButton*)sender{
    if (isShowConfirmPassword) {
        isShowConfirmPassword = NO;
        [sender setTitle:_static_Show forState:UIControlStateNormal];
        txtConfirmPass.secureTextEntry = YES;
    }else{
        isShowConfirmPassword = YES;
        [sender setTitle:_static_Hide forState:UIControlStateNormal];
        txtConfirmPass.secureTextEntry = NO;
    }
}
#pragma mark- Validation
-(BOOL)isValidForChangePassword{
    
    if (trimmedString(txtCurrentPass.text).length == 0) {
        showAlertWithErrorMessage(_error_Please_enter_your_current_password);
        return NO;
    }else if (![trimmedString(txtCurrentPass.text) isEqualToString:[userDefaults valueForKey:_static_REMEMBER_PASSWORD]]) {
        showAlertWithErrorMessage(_error_Entered_correct_current_password);
        return NO;
    }else if (trimmedString(txtNewPass.text).length == 0) {
        showAlertWithErrorMessage(_error_Please_enter_your_new_password);
        return NO;
    }else if (trimmedString(txtNewPass.text).length < 6) {
        showAlertWithErrorMessage(_error_password_limit);
        return NO;
    }else if (![trimmedString(txtNewPass.text) isEqualToString:trimmedString(txtConfirmPass.text)]) {
        showAlertWithErrorMessage(_error_Please_check_new_password_confirm_password);
        return NO;
    }
    return YES;
}

#pragma mark- API Service
-(void)callWebserviceForChangePassword{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];

    [param setValue:trimmedString(txtNewPass.text) forKey:_param_password];
    [param setValue:[[Global objectFromDataWithKey:_static_USER_INFO] valueForKey:_param_id] forKey:_param_id];
        [Users updateUserDetailsWithData:param withCompletion:^(NSDictionary *responsedic) {
            if (responsedic) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responsedic];
                [dict setValue:@"" forKey:_param_date_of_birth];
                [userDefaults setValue:[NSKeyedArchiver archivedDataWithRootObject:dict] forKey:_static_USER_INFO];
                
                [userDefaults setValue:trimmedString(txtNewPass.text) forKey:_static_REMEMBER_PASSWORD];
                
                [userDefaults synchronize];
                dict = nil;
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
}
@end
