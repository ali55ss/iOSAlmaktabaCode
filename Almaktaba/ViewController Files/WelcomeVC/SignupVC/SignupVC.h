//
//  SignupVC.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 08/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupVC : UIViewController
{
    __weak IBOutlet UILabel *lblSeeYouAgain;
    __weak IBOutlet UILabel *lblSignupNewUser;
    
    __weak IBOutlet UILabel *lblTitleEmail;
    __weak IBOutlet UITextField *txtEmail;
    __weak IBOutlet UILabel *lblTitlePassword;
    __weak IBOutlet UITextField *txtPassword;
    __weak IBOutlet UIButton *btnShowPassword;
    __weak IBOutlet UILabel *lblTitleConfirmPassword;
    __weak IBOutlet UITextField *txtConfirmPassword;
    __weak IBOutlet UIButton *btnShowConfirmPassword;
    __weak IBOutlet UIButton *btnSignup;
    __weak IBOutlet UILabel *lblAlreadyAccount;
    __weak IBOutlet UIButton *btnLogin;
    
}
- (IBAction)clk_btnShowPassword:(id)sender;
- (IBAction)clk_btnShowConfirmPassword:(id)sender;
- (IBAction)clk_btnSignup:(id)sender;
- (IBAction)clk_btnLogin:(id)sender;


@end
