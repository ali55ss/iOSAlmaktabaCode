//
//  VerifyEmailVC.h
//  ContactBackup
//
//  Created by TechnoMac-11 on 16/01/18.
//  Copyright © 2018 TechnoMac-5. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyEmailVC : UIViewController <UITextFieldDelegate>
{
    NSArray *labels;
    __weak IBOutlet UIButton *btnSubmit;
    
    __weak IBOutlet UILabel *fieldOneLabel;
    __weak IBOutlet UILabel *fieldTwoLabel;
    __weak IBOutlet UILabel *fieldThreeLabel;
    __weak IBOutlet UILabel *fieldFourLabel;
    __weak IBOutlet UITextField *inputField;
    
    __weak IBOutlet UILabel *lblTitle;
    __weak IBOutlet UILabel *lblInfo;
    __weak IBOutlet UILabel *lblEnterOTP;
    __weak IBOutlet UIButton *btnNotReceiveOTP;
    
    __weak IBOutlet UIButton *btnBack;
    
}
- (IBAction)btnBackOtherPressed:(id)sender;


- (IBAction)btnSubmitPressed:(id)sender;
- (IBAction)btnReSendEmailPressed:(id)sender;
- (IBAction)btnBackPressed:(id)sender;

@property (assign)BOOL isForgotPassword;
@property (strong, nonatomic) NSString *strForgotEmail;
@property (strong, nonatomic) NSString *forgotPassword_verification_code;
@property (strong, nonatomic) NSString *verification_code;



@property (strong, nonatomic) NSString *strUserID;
@end
