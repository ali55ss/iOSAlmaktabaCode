//
//  CollegeSuggestionVC.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 13/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFTextField.h"

@interface CollegeSuggestionVC : UIViewController
{
    __weak IBOutlet UILabel *lblTitle;

    __weak IBOutlet UIImageView *imgCollegeLogo;
    __weak IBOutlet MFTextField *txtFieldCollegeName;
    __weak IBOutlet UIButton *btnSubmit;
}

- (IBAction)clk_BtnSubmit:(id)sender;
- (IBAction)clk_SelectCollegeLogo:(id)sender;
- (IBAction)textFieldDidEndEditing:(UITextField *)sender;
- (IBAction)textFieldDidBegin:(UITextField *)sender;


/**
 it is useful for suggest college list of perticular university
 */
@property (assign) int university_id;

@end
