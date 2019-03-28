//
//  ChangePassVC.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 05/03/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePassVC : UIViewController
{
    
    BOOL isShowPassword,isShowConfirmPassword;

    __weak IBOutlet UILabel *lblTitle;
    
    __weak IBOutlet UILabel *lblCurrentPass;
    __weak IBOutlet UITextField *txtCurrentPass;
    
    __weak IBOutlet UILabel *lblNewPass;
    __weak IBOutlet UITextField *txtNewPass;
    
    __weak IBOutlet UILabel *lblConfirmPass;
    __weak IBOutlet UITextField *txtConfirmPass;
    
    __weak IBOutlet UIButton *btnSubmit;
}
- (IBAction)clk_btnSubmit:(id)sender;


@end
