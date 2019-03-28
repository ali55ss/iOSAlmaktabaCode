//
//  DepartmentSuggestionVC.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 13/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "DepartmentSuggestionVC.h"
#import "Departments.h"
#import "Suggestion.h"
@interface DepartmentSuggestionVC ()

@end

@implementation DepartmentSuggestionVC
-(void)commanInit{
    
    self.title = @"";
    /**
     Set Fonts
     */
    
    lblTitle.text = _static_Suggest_Departments;
   lblTitle.font = [Font setFont_Medium_Size:18];
    lblTitle.textColor = theme_Black_Color;

    
    txtDepartmentName.font = [Font setFont_Regular_Size:16];
    btnSubmit.titleLabel.font = [Font setFont_Bold_Size:16];
    [btnSubmit setTitle:_static_Submit forState:UIControlStateNormal];
    /**
     Set Corner radious
     */
    setCornerRadius(btnSubmit.layer, 3, 0.5, [UIColor lightGrayColor], NO);
    
    txtDepartmentName.tintColor = theme_Gray_Color;
    txtDepartmentName.textColor = theme_Black_Color;
    txtDepartmentName.defaultPlaceholderColor = theme_Gray_Color;
    txtDepartmentName.placeholderAnimatesOnFocus = YES;
    txtDepartmentName.placeholder = _static_Department_name;
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
    if([self isValidSuggestion]){
        [self callWebserviceForSuggestNewDepartment];
    }
}
- (IBAction)textFieldDidEndEditing:(UITextField *)sender {
    [self validateTxtFieldDeptName];
}

- (IBAction)textFieldDidBegin:(UITextField *)sender {
    [txtDepartmentName setError:nil animated:YES];
}

#pragma mark- Validations
-(BOOL)isValidSuggestion{

    return [self validateTxtFieldDeptName];
}
#pragma mark - Text field validation
- (BOOL)validateTxtFieldDeptName
{
    NSError *error = nil;
    if ([self txtFieldDeptNameIsInValid]) {
        error = [Global errorWithLocalizedDescription:_static_Please_enter_department_name];
    }
    [txtDepartmentName setError:error animated:YES];
    return !error;
}
- (BOOL)txtFieldDeptNameIsInValid
{
    return trimmedString(txtDepartmentName.text).length == 0;
}


#pragma mark- API Service
-(void)callWebserviceForSuggestNewDepartment{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:trimmedString(txtDepartmentName.text) forKey:_param_name];
    [params setValue:[NSString stringWithFormat:@"%d",self.college_id] forKey:_param_type_id];
    [params setValue:@"3" forKey:_param_suggestion_type];
    [params setValue:[[Global objectFromDataWithKey:_static_USER_INFO] valueForKey:@"id"] forKey:_param_user_id];
    
    [Suggestion suggestNewWithData:params withCompletion:^(NSDictionary *responsedic) {
        if (responsedic) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
   
}
@end
