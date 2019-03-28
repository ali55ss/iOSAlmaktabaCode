//
//  DepartmentSuggestionVC.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 13/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFTextField.h"
@interface DepartmentSuggestionVC : UIViewController
{
    __weak IBOutlet MFTextField *txtDepartmentName;
    __weak IBOutlet UIButton *btnSubmit;
    
    __weak IBOutlet UILabel *lblTitle;
}

- (IBAction)clk_BtnSubmit:(id)sender;
- (IBAction)textFieldDidEndEditing:(UITextField *)sender;
- (IBAction)textFieldDidBegin:(UITextField *)sender;

@property (assign) int college_id;


@end
