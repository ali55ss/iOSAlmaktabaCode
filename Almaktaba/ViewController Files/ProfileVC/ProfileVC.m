//
//  ProfileVC.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 15/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "ProfileVC.h"
#import "Users.h"
@interface ProfileVC ()

@end

@implementation ProfileVC

#pragma mark- commanInit
-(void)commanInit{
    
    self.title = _static_Profile;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(btnMenuPressed)];
    
    /**
     
     Set appearense
     */
    lblFirstNameTitle.textColor = theme_Black_Color;
    txtFirstName.textColor = theme_Black_Color;
    lblLastNameTitle.textColor = theme_Black_Color;
    txtLastName.textColor = theme_Black_Color;
    lblEmailTitle.textColor = theme_Black_Color;
    txtEmail.textColor = theme_Black_Color;
    lblMobileNumberTitle.textColor = theme_Black_Color;
    txtMobileNumber.textColor = theme_Black_Color;
    lblPasswordTitle.textColor = theme_Black_Color;
    txtPassword.textColor = theme_Black_Color;
    lblConfirmPasswordTitle.textColor = theme_Black_Color;
    txtConfirmPassword.textColor = theme_Black_Color;
    
    
    lblFirstNameTitle.font = [Font setFont_Medium_Size:14];
    txtFirstName.font = [Font setFont_Regular_Size:16];
    lblLastNameTitle.font = [Font setFont_Medium_Size:14];
    txtLastName.font = [Font setFont_Regular_Size:16];
    lblEmailTitle.font = [Font setFont_Medium_Size:14];
    txtEmail.font = [Font setFont_Regular_Size:16];
    lblMobileNumberTitle.font = [Font setFont_Medium_Size:14];
    txtMobileNumber.font = [Font setFont_Regular_Size:16];
    lblPasswordTitle.font = [Font setFont_Medium_Size:14];
    txtPassword.font = [Font setFont_Regular_Size:16];
    lblConfirmPasswordTitle.font = [Font setFont_Medium_Size:14];
    txtConfirmPassword.font = [Font setFont_Regular_Size:16];
    
    btnSubmit.titleLabel.font = [Font setFont_Medium_Size:18];
    
    lblFirstNameTitle.text = _static_First_Name;
    txtFirstName.placeholder = _static_Please_enter_your_firstname;
    
    lblLastNameTitle.text = _static_Last_Name;
    txtLastName.placeholder = _static_Please_enter_your_lastname;
    
    lblEmailTitle.text = _static_Email;
    txtEmail.placeholder = _static_Enter_your_email;
    
    lblMobileNumberTitle.text = _static_Mobile_Number;
    txtMobileNumber.placeholder = _static_Please_enter_your_mobile;
    
    lblPasswordTitle.text = _static_Password;
    txtPassword.placeholder = _static_Enter_your_password;
    
    lblConfirmPasswordTitle.text = _static_Confirm_password;
    txtConfirmPassword.placeholder = _static_Confirm_your_password;
    
    [btnSubmit setTitle:_static_Submit forState:UIControlStateNormal];
    
    /**
     Set Corner Radious
     */
    setCornerRadius(userProfileImage.layer, userProfileImage.height/2, 0, nil, NO);
    setCornerRadius(txtFirstName.layer, 3.0, 0, nil, NO);
    setCornerRadius(txtLastName.layer, 3.0, 0, nil, NO);
    setCornerRadius(txtEmail.layer, 3.0, 0, nil, NO);
    setCornerRadius(txtMobileNumber.layer, 3.0, 0, nil, NO);
    setCornerRadius(txtPassword.layer, 3.0, 0, nil, NO);
    setCornerRadius(txtConfirmPassword.layer, 3.0, 0, nil, NO);
    setCornerRadius(btnSubmit.layer, 3.0, 0, nil, NO);
    
    /**
     UITextField left Padding
     */
    leftPadding(txtFirstName);
    leftPadding(txtLastName);
    leftPadding(txtEmail);
    leftPadding(txtMobileNumber);
    leftPadding(txtPassword);
    leftPadding(txtConfirmPassword);
    
    
    /**
     Add Show password btn
     */
    UIButton *showPassword = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 35)];
    [showPassword setTitle:_static_Show forState:UIControlStateNormal];
    [showPassword setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    showPassword.titleLabel.font = [Font setFont_Bold_Size:12];
    [showPassword addTarget:self action:@selector(btnShowPasswordPressed:) forControlEvents:UIControlEventTouchUpInside];
    [txtPassword setRightViewMode:UITextFieldViewModeAlways];
    [txtPassword setRightView:showPassword];
    
    UIButton *showConfirmPassword = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 35)];
    [showConfirmPassword setTitle:_static_Show forState:UIControlStateNormal];
    [showConfirmPassword setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    showConfirmPassword.titleLabel.font = [Font setFont_Bold_Size:12];
    [showConfirmPassword addTarget:self action:@selector(btnShowConfirmPasswordPressed:) forControlEvents:UIControlEventTouchUpInside];
    [txtConfirmPassword setRightViewMode:UITextFieldViewModeAlways];
    [txtConfirmPassword setRightView:showConfirmPassword];
}
#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commanInit];
    
    /**
     Call API For Get User Details
     */
    [self callWebserserviceForGetUserDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods
-(void)btnMenuPressed{
    openSideBarMenuFrom(self);
}
-(void)btnShowPasswordPressed:(UIButton*)sender{
    if (isShowPassword) {
        isShowPassword = NO;
        [sender setTitle:_static_Show forState:UIControlStateNormal];
        txtPassword.secureTextEntry = YES;
    }else{
        isShowPassword = YES;
        [sender setTitle:_static_Hide forState:UIControlStateNormal];
        txtPassword.secureTextEntry = NO;
    }
}
-(void)btnShowConfirmPasswordPressed:(UIButton*)sender{
    if (isShowConfirmPassword) {
        isShowConfirmPassword = NO;
        [sender setTitle:_static_Show forState:UIControlStateNormal];
        txtConfirmPassword.secureTextEntry = YES;
    }else{
        isShowConfirmPassword = YES;
        [sender setTitle:_static_Hide forState:UIControlStateNormal];
        txtConfirmPassword.secureTextEntry = NO;
    }
}

- (IBAction)clk_btnSelectProfileImage:(id)sender {
    [self selectUserProfile];
}

- (IBAction)clk_btnSubmit:(id)sender {
    if ([self isValidProfileData]) {
        [self callWebserviceForUpdateUserProfile];
    }
}


#pragma mark- isValid
-(BOOL)isValidProfileData{
    if (trimmedString(txtFirstName.text).length == 0) {
        showAlertWithErrorMessage(_static_Please_enter_your_firstname);
        return NO;
    }else if (trimmedString(txtLastName.text).length == 0) {
        showAlertWithErrorMessage(_static_Please_enter_your_lastname);
        return NO;
    }else if (trimmedString(txtEmail.text).length == 0) {
        showAlertWithErrorMessage(_error_Please_enter_your_email);
        return NO;
    }else if(![Global IsValidEmail:trimmedString(txtEmail.text)]){
        showAlertWithErrorMessage(_error_Please_enter_valid_email);
        return NO;
    }else if (trimmedString(txtMobileNumber.text).length == 0) {
        showAlertWithErrorMessage(_static_Please_enter_your_mobile);
        return NO;
    }else if (trimmedString(txtMobileNumber.text).length < 4 || trimmedString(txtMobileNumber.text).length > 16) {
        showAlertWithErrorMessage(_error_Please_enter_valid_mobile);
        return NO;
    }
    return YES;
}
#pragma mark- Select Image
-(void)selectUserProfile{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:_static_Choose_Profile_Image_From] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
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
    userImageData = UIImageJPEGRepresentation(image, 0);
    
    userProfileImage.image = image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark- Set Profile Info
-(void)setUserProfileDetails{
    Users *user = [arrUserInfo firstObject];
    
    txtFirstName.text = user.firstname;
    txtLastName.text = user.lastname;
    txtEmail.text = user.email;
    txtMobileNumber.text = user.mobile;
    
    txtPassword.text = [userDefaults valueForKey:_static_REMEMBER_PASSWORD];
    txtConfirmPassword.text = txtPassword.text;
    
    [activityIndicator startAnimating];
    [activityIndicator setHidden:NO];
    
    [userProfileImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_PROFILE_IMAGE_URL,user.profile_image]] placeholderImage:[UIImage imageNamed:@"noUser"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [activityIndicator stopAnimating];
        [activityIndicator setHidden:YES];
    }];
}

#pragma mark- API Service

-(void)callWebserserviceForGetUserDetails{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [Users getUserDetailsWithData:param withCompletion:^(NSDictionary *responsedic) {
        if (responsedic) {
            if (arrUserInfo != nil) {
                arrUserInfo = nil;
            }
            arrUserInfo = [[NSMutableArray alloc] init];
            arrUserInfo = [RMMapper mutableArrayOfClass:[Users class] fromArrayOfDictionary:[NSArray arrayWithArray:(NSArray*)responsedic]];
            [self setUserProfileDetails];
        }
    }];
}
-(void)callWebserviceForUpdateUserProfile{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[trimmedString(txtFirstName.text) capitalizedString] forKey:_param_firstname];
    [param setValue:[trimmedString(txtLastName.text) capitalizedString] forKey:_param_lastname];
    [param setValue:trimmedString(txtEmail.text) forKey:_param_email];
    [param setValue:trimmedString(txtMobileNumber.text) forKey:_param_mobile];
    [param setValue:trimmedString(txtPassword.text) forKey:_param_password];
    [param setValue:[[Global objectFromDataWithKey:_static_USER_INFO] valueForKey:_param_id] forKey:_param_id];
    
    if (userImageData) {
        [Users uploadImageWithData:userImageData withCompletion:^(NSString *_fileName) {
            if (_fileName.length) {
                [param setValue:_fileName forKey:_param_profile_image];
            }else{
                showAlertWithErrorMessage(_error_Profile_image_not_upload);
            }
            [self updateProfileData:param];
        }];
    }else{
        [self updateProfileData:param];
    }
}
-(void)updateProfileData:(NSMutableDictionary*)_param{
    [Users updateUserDetailsWithData:_param withCompletion:^(NSDictionary *responsedic) {
        if (responsedic) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responsedic];
            [dict setValue:@"" forKey:_param_date_of_birth];

            [userDefaults setValue:[NSKeyedArchiver archivedDataWithRootObject:dict] forKey:_static_USER_INFO];

            [userDefaults setValue:trimmedString(txtPassword.text) forKey:_static_REMEMBER_PASSWORD];
            dict = nil;
        }
    }];
}
@end
