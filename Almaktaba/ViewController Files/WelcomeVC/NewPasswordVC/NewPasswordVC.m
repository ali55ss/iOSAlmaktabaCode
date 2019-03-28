//
//  NewPasswordVC.m
//  ContactBackup
//
//  Created by TechnoMac-11 on 31/01/18.
//  Copyright © 2018 TechnoMac-5. All rights reserved.
//

#import "NewPasswordVC.h"
#import "Users.h"
@interface NewPasswordVC ()

@end

@implementation NewPasswordVC

#pragma mark- commanInit
-(void)commanInit{
    
    lblTitle.text = _static_Create_New_Password;
    lblPasswordTitle.text = _static_Password;
    lblConfirmPasswordTitle.text = _static_Confirm_password;
    [btnResetPassword setTitle:_static_Reset forState:UIControlStateNormal];
    
    
    /**
     set apperarience
     */
    lblTitle.font = [Font setFont_Medium_Size:18];

    lblPasswordTitle.font = [Font setFont_Medium_Size:14];
    txtPassword.font = [Font setFont_Regular_Size:16];
    
    lblConfirmPasswordTitle.font = [Font setFont_Medium_Size:14];
    txtConfirmPassword.font = [Font setFont_Regular_Size:16];
    
    btnShowPassword.titleLabel.font = [Font setFont_Medium_Size:12];
    btnShowConfirmPassword.titleLabel.font = [Font setFont_Medium_Size:12];
    
    /**
     set Corner Radius
     */
    setCornerRadius(txtPassword.layer, 3.0, 0, nil, NO);
    setCornerRadius(txtConfirmPassword.layer, 3.0, 0, nil, NO);
    setCornerRadius(btnResetPassword.layer, 3.0, 0, nil, NO);
    
    /**
     UITextField left Padding
     */
    leftPadding(txtPassword);
    leftPadding(txtConfirmPassword);
}
#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commanInit];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark- Action Methods
- (IBAction)btnBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)btnResetPressed:(id)sender {
    if (trimmedString(txtPassword.text).length == 0) {
        showAlertWithErrorMessage(_error_Please_enter_your_password);
    } else if (trimmedString(txtConfirmPassword.text).length == 0) {
        showAlertWithErrorMessage(_error_Please_confirm_password);
    }else if (trimmedString(txtPassword.text).length < 6) {
        showAlertWithErrorMessage(_error_password_limit);
    } else if (![trimmedString(txtConfirmPassword.text) isEqualToString:trimmedString(txtPassword.text)]) {
        showAlertWithErrorMessage(_error_Please_confirm_password);
    }else{
        [self callWebserviceForUpdateUserDetails];
    }
}

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

#pragma mark- WEBSERVICE
-(void)callWebserviceForUpdateUserDetails{
    //    Users *user = [[Users alloc] init];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:trimmedString(txtPassword.text) forKey:_param_password];
    [param setValue:self.strUserID forKey:_param_id];
    [Users updateUserDetailsWithData:param withCompletion:^(NSDictionary *responsedic) {
        if (responsedic) {
            UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavControll"];
            appDelegateObj.window.rootViewController = nav;
        }
    }];
    
    //    [user uploadProfleImageWithData:param withImageData:nil withCompletion:^(NSDictionary *resDic) {
    //        if (resDic) {
    //            UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavControll"];
    //            appDelegateObj.window.rootViewController = nav;
    //        }
    //    }];
}
@end
