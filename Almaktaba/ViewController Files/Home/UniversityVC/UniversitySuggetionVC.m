//
//  UniversitySuggetionVC.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 12/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "UniversitySuggetionVC.h"
#import "Suggestion.h"
#import "Universities.h"
@interface UniversitySuggetionVC ()

@end

@implementation UniversitySuggetionVC
#pragma mark- commanInit
-(void)commanInit{
    
    self.title = _static_Suggest_University;
    /**
     Set Fonts
     */
    
    txtFieldUniName.font = [Font setFont_Regular_Size:16];
    btnSubmit.titleLabel.font = [Font setFont_Bold_Size:16];
    [btnSubmit setTitle:_static_Submit forState:UIControlStateNormal];
    /**
     Set Corner radious
     */
    setCornerRadius(imgUniLogo.layer, 3, 0.5, [UIColor lightGrayColor], YES);
    setCornerRadius(btnSubmit.layer, 3, 0.5, [UIColor lightGrayColor], NO);

    txtFieldUniName.tintColor = theme_Gray_Color;
   txtFieldUniName.textColor = theme_Black_Color;
   txtFieldUniName.defaultPlaceholderColor = theme_Gray_Color;
    txtFieldUniName.placeholderAnimatesOnFocus = YES;
    txtFieldUniName.placeholder = _static_University_name  ;
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

#pragma mark- Action Methods

- (IBAction)clk_BtnSubmit:(id)sender {
    if ([self isValidSuggestion]) {
        [self callWebserviceForSuggestNewUniversity];
    }
}


- (IBAction)clk_SelectUniLogo:(id)sender {
    [self selectUniLogo];
}

- (IBAction)textFieldDidBegin:(UITextField *)sender {
    [txtFieldUniName setError:nil animated:YES];
}

- (IBAction)textFieldDidEndEditing:(UITextField *)sender {
    [self validateTxtFieldUniName];
}

#pragma mark- Validations
-(BOOL)isValidSuggestion{
    if (uniLogoData == nil) {
        showAlertWithErrorMessage(_error_University_logo_require);
        return NO;
    }
    return [self validateTxtFieldUniName];
}
#pragma mark - Text field validation
- (BOOL)validateTxtFieldUniName
{
    NSError *error = nil;
    if ([self txtFieldUniNameIsInValid]) {
        error = [Global errorWithLocalizedDescription:_static_Please_enter_university_name];
    }
    [txtFieldUniName setError:error animated:YES];
    
    return !error;
}
- (BOOL)txtFieldUniNameIsInValid
{
    return trimmedString(txtFieldUniName.text).length == 0;
}
#pragma mark- Select Image
-(void)selectUniLogo{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:_static_Choose_University_Logo_From  message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
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
    uniLogoData = UIImageJPEGRepresentation(image, 0);
    
    imgUniLogo.image = image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark- API Service
-(void)callWebserviceForSuggestNewUniversity{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:trimmedString(txtFieldUniName.text) forKey:_param_name];
    [params setValue:@"0" forKey:_param_type_id];
    [params setValue:@"1" forKey:_param_suggestion_type];
    [params setValue:[[Global objectFromDataWithKey:_static_USER_INFO] valueForKey:@"id"] forKey:_param_user_id];

    
    /**
     upload university logo first
     */
    
    [Universities uploadImageWithData:uniLogoData withCompletion:^(NSString *_fileName) {
        if (_fileName.length) {
            [params setValue:_fileName forKey:_param_logo];
            [Suggestion suggestNewWithData:params withCompletion:^(NSDictionary *responsedic) {
                if (responsedic) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }];
    
}




@end
