//
//  ProfileVC.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 15/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileVC : UIViewController
{
    BOOL isShowPassword,isShowConfirmPassword;
    NSData* userImageData;
    
    NSMutableArray *arrUserInfo;
    
    __weak IBOutlet UIImageView *userProfileImage;
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    
    __weak IBOutlet UILabel *lblFirstNameTitle;
    __weak IBOutlet UITextField *txtFirstName;
    
    __weak IBOutlet UILabel *lblLastNameTitle;
    __weak IBOutlet UITextField *txtLastName;
    
    __weak IBOutlet UILabel *lblEmailTitle;
    __weak IBOutlet UITextField *txtEmail;
    
    __weak IBOutlet UILabel *lblMobileNumberTitle;
    __weak IBOutlet UITextField *txtMobileNumber;
    
    __weak IBOutlet UILabel *lblPasswordTitle;
    __weak IBOutlet UITextField *txtPassword;
    
    __weak IBOutlet UILabel *lblConfirmPasswordTitle;
    __weak IBOutlet UITextField *txtConfirmPassword;
    
    __weak IBOutlet UIButton *btnSubmit;
    
}
- (IBAction)clk_btnSelectProfileImage:(id)sender;
- (IBAction)clk_btnSubmit:(id)sender;

@end
