//
//  CollegeSuggestionVC.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 13/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "CollegeSuggestionVC.h"
#import "Colleges.h"
#import "Suggestion.h"
@interface CollegeSuggestionVC ()

@end

@implementation CollegeSuggestionVC

#pragma mark- Config
-(void)commanInit{
    
    self.title = @"";
    /**
     Set Fonts
     */
    
    lblTitle.text = _static_Suggest_College;
    lblTitle.font = [Font setFont_Medium_Size:18];
    lblTitle.textColor = theme_Black_Color;
    
    txtFieldCollegeName.font = [Font setFont_Regular_Size:16];
    btnSubmit.titleLabel.font = [Font setFont_Bold_Size:16];
    [btnSubmit setTitle:_static_Submit forState:UIControlStateNormal];
    /**
     Set Corner radious
     */
    setCornerRadius(imgCollegeLogo.layer, 3, 0.5, [UIColor lightGrayColor], YES);
    setCornerRadius(btnSubmit.layer, 3, 0.5, [UIColor lightGrayColor], NO);
    
    /**
     Config Textfield
     */
    txtFieldCollegeName.tintColor = theme_Gray_Color;
    txtFieldCollegeName.textColor = theme_Black_Color;
    txtFieldCollegeName.defaultPlaceholderColor = theme_Gray_Color;
    txtFieldCollegeName.placeholderAnimatesOnFocus = YES;
    txtFieldCollegeName.placeholder = _static_College_Name;
    
}
#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self commanInit];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action Methods
- (IBAction)clk_BtnSubmit:(id)sender {
    if ([self isValidSuggestion]) {
        [self callWebserviceForSuggestNewCollege];
    }
}

- (IBAction)clk_SelectCollegeLogo:(id)sender {
    [self selectCollegeLogo];
}

- (IBAction)textFieldDidEndEditing:(UITextField *)sender {
//    [btnSubmit sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self validateTxtFieldCollegeName];
}

- (IBAction)textFieldDidBegin:(UITextField *)sender {
    [txtFieldCollegeName setError:nil animated:YES];
}

#pragma mark- Validations
-(BOOL)isValidSuggestion{
    
    return [self validateTxtFieldCollegeName];;
}
#pragma mark - Text field validation
- (BOOL)validateTxtFieldCollegeName
{
    NSError *error = nil;
    if ([self txtFieldCollegeNameIsInValid]) {
        error = [Global errorWithLocalizedDescription:_static_Please_enter_college_name];
        
    }
    [txtFieldCollegeName setError:error animated:YES];
    return !error;
}
- (BOOL)txtFieldCollegeNameIsInValid
{
    return trimmedString(txtFieldCollegeName.text).length == 0;
}

#pragma mark- Select Image
-(void)selectCollegeLogo{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:_static_Choose_College_Logo_From message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:_static_Open_Camera style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) { PresentPhotoCamera(self, NO); }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:_static_Photo_Library style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) { PresentPhotoLibrary(self, NO); }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:_static_Cancel style:UIAlertActionStyleDestructive handler:nil];
    
    [alert addAction:action1]; [alert addAction:action2]; [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark- ImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    imgCollegeLogo.image = image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



#pragma mark- API Service

-(void)callWebserviceForSuggestNewCollege{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:trimmedString(txtFieldCollegeName.text) forKey:_param_name];
    [params setValue:[NSString stringWithFormat:@"%d",self.university_id] forKey:_param_type_id];
    [params setValue:@"2" forKey:_param_suggestion_type];
    [params setValue:[[Global objectFromDataWithKey:_static_USER_INFO] valueForKey:@"id"] forKey:_param_user_id];
    
    
    [Suggestion suggestNewWithData:params withCompletion:^(NSDictionary *responsedic) {
        if (responsedic) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

@end
