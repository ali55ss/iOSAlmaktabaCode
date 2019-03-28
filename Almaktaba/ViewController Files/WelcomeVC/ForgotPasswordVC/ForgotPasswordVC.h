//
//  ForgotPasswordVC.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 12/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordVC : UIViewController
{
    __weak IBOutlet UILabel *lblResetPassword;
    __weak IBOutlet UILabel *lblResetPassDesc;
    __weak IBOutlet UILabel *lblEmail;
    __weak IBOutlet UITextField *txtFieldEmail;
    __weak IBOutlet UIButton *btnReset;
    __weak IBOutlet UIButton *btnBack;
    
}


- (IBAction)clk_btnReset:(id)sender;
- (IBAction)clk_btnBack:(id)sender;

@end
