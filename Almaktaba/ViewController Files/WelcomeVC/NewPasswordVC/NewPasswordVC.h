//
//  NewPasswordVC.h
//  ContactBackup
//
//  Created by TechnoMac-11 on 31/01/18.
//  Copyright © 2018 TechnoMac-5. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFTextField.h"
@interface NewPasswordVC : UIViewController
{
    BOOL isShowPass, isShowRepass;
    
    __weak IBOutlet UILabel *lblTitle;
    __weak IBOutlet UILabel *lblPasswordTitle;
    __weak IBOutlet UILabel *lblConfirmPasswordTitle;
    __weak IBOutlet UITextField *txtPassword;
    __weak IBOutlet UITextField *txtConfirmPassword;
    __weak IBOutlet UIButton *btnShowPassword;
    __weak IBOutlet UIButton *btnShowConfirmPassword;
    
    __weak IBOutlet UIButton *btnResetPassword;
}
- (IBAction)btnBackPressed:(id)sender;
- (IBAction)btnResetPressed:(id)sender;
- (IBAction)clk_btnShowPassword:(id)sender;
- (IBAction)clk_btnShowConfirmPassword:(id)sender;


@property (strong, nonatomic) NSString *strUserID;

@end
