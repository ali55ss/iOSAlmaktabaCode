//
//  UniversitySuggetionVC.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 12/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFTextField.h"
@interface UniversitySuggetionVC : UIViewController
{
    NSData *uniLogoData;
    __weak IBOutlet UIImageView *imgUniLogo;

    __weak IBOutlet MFTextField *txtFieldUniName;
    __weak IBOutlet UIButton *btnSubmit;
    
}



- (IBAction)clk_BtnSubmit:(id)sender;
- (IBAction)clk_SelectUniLogo:(id)sender;
- (IBAction)textFieldDidBegin:(UITextField *)sender;
- (IBAction)textFieldDidEndEditing:(UITextField *)sender;

@end
