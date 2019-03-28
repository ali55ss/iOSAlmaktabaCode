//
//  CouseSuggestionVC.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 13/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "CourseSuggestionVC.h"
#import "Suggestion.h"
@interface CourseSuggestionVC ()

@end

@implementation CourseSuggestionVC
-(void)commanInit{
    
    self.title = @"";
    /**
     Set Fonts
     */
    
    lblTitle.text = _static_Suggest_Course;
    lblTitle.font = [Font setFont_Medium_Size:18];
    lblTitle.textColor = theme_Black_Color;
    
    txtCourseCode.font = [Font setFont_Regular_Size:16];
    txtCourseName.font = [Font setFont_Regular_Size:16];
    
    btnSubmit.titleLabel.font = [Font setFont_Bold_Size:16];
    [btnSubmit setTitle:_static_Submit forState:UIControlStateNormal];

    /**
     Set Corner radious
     */
    setCornerRadius(btnSubmit.layer, 3, 0.5, [UIColor lightGrayColor], NO);
    
    txtCourseCode.tintColor = theme_Gray_Color;
    txtCourseCode.textColor = theme_Black_Color;
    txtCourseCode.defaultPlaceholderColor = theme_Gray_Color;
    txtCourseCode.placeholderAnimatesOnFocus = YES;
    txtCourseCode.placeholder = _static_Code;
    
    txtCourseName.tintColor = theme_Gray_Color;
    txtCourseName.textColor = theme_Black_Color;
    txtCourseName.defaultPlaceholderColor = theme_Gray_Color;
    txtCourseName.placeholderAnimatesOnFocus = YES;
    txtCourseName.placeholder = _static_Courses_Name
    
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
        [self callWebserviceForSuggestCource];
    }
}
- (IBAction)textFieldDidEndEditing:(UITextField *)sender {
    [self isValidSuggestion];
}

- (IBAction)textFieldDidBegin:(UITextField *)sender {
    if (sender == txtCourseName) {
        [txtCourseName setError:nil animated:YES];
    }
    if (sender == txtCourseCode) {
        [txtCourseCode setError:nil animated:YES];
    }
}

#pragma mark- Validations
-(BOOL)isValidSuggestion{
    
    if([self validateTxtFieldCourseCode] && [self validateTxtFieldCourseName]){
        return YES;
    }
    return NO;
}
#pragma mark - Text field validation
- (BOOL)validateTxtFieldCourseName
{
    NSError *error = nil;
    if ([self txtFieldCourseNameIsInValid]) {
        error = [Global errorWithLocalizedDescription:_static_Please_enter_course_name];
    }
    [txtCourseName setError:error animated:YES];
    return !error;
}
- (BOOL)validateTxtFieldCourseCode
{
    NSError *error = nil;
    if ([self txtFieldCourseCodeIsInValid]) {
        error = [Global errorWithLocalizedDescription:_static_Required];
    }
    [txtCourseCode setError:error animated:YES];
    return !error;
}
- (BOOL)txtFieldCourseNameIsInValid
{
    return trimmedString(txtCourseName.text).length == 0;
}
- (BOOL)txtFieldCourseCodeIsInValid
{
    return trimmedString(txtCourseCode.text).length == 0;
}

#pragma mark- API Service
-(void)callWebserviceForSuggestCource{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:trimmedString(txtCourseName.text) forKey:_param_name];
    [params setValue:trimmedString(txtCourseCode.text) forKey:_param_course_code];

    [params setValue:[NSString stringWithFormat:@"%d",self.collegedepartment_id] forKey:_param_type_id];
    [params setValue:@"4" forKey:_param_suggestion_type];
    [params setValue:[[Global objectFromDataWithKey:_static_USER_INFO] valueForKey:@"id"] forKey:_param_user_id];

    [Suggestion suggestNewWithData:params withCompletion:^(NSDictionary *responsedic) {
        if (responsedic) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

@end
