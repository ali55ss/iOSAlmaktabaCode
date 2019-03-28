//
//  CouseSuggestionVC.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 13/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFTextField.h"
@interface CourseSuggestionVC : UIViewController
{
    __weak IBOutlet MFTextField *txtCourseCode;
    __weak IBOutlet MFTextField *txtCourseName;
    __weak IBOutlet UIButton *btnSubmit;
    __weak IBOutlet UILabel *lblTitle;
    
}
- (IBAction)clk_BtnSubmit:(id)sender;

- (IBAction)textFieldDidEndEditing:(UITextField *)sender;
- (IBAction)textFieldDidBegin:(UITextField *)sender;

@property (assign) int collegedepartment_id;

@end
