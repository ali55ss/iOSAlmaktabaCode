//
//  SettingsVC.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 15/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "SettingsVC.h"
#import "UniversityVC.h"
#import "ChangePassVC.h"
@interface SettingsVC ()

@end

@implementation SettingsVC

#pragma mark- Comman Init
-(void)commanInit{
    self.title = _static_Settings;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(btnMenuPressed)];
    
    /**
     Set Appearance
     */
    
    lblLogout.textColor = theme_Red_Color;
    lblLogout.font = [Font setFont_SemiBold_Size:16];
    lblLogout.text = _static_Logout;

    lblMyDepartment.textColor = theme_Black_Color;
    lblMyDepartment.font = [Font setFont_Medium_Size:16];
    lblMyDepartment.text = _static_my_department;
    

    lblChangePassword.textColor = theme_Black_Color;
    lblChangePassword.font = [Font setFont_Medium_Size:16];
    lblChangePassword.text = _static_Change_Password;
    
    lblTaptoChangeDepartment.textColor = theme_Gray_Color;
    lblTaptoChangeDepartment.font = [Font setFont_Regular_Size:14];
    lblTaptoChangeDepartment.text = _static_change_department;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self commanInit];
    [self setupTableviewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- SetupTable view data
-(void)setupTableviewData{
    arrTableCell = [[NSArray alloc] init];
    if ([[[Global objectFromDataWithKey:_static_USER_INFO] valueForKey:_param_register_type] intValue] == 1) {
        arrTableCell = @[@[tblCellMyDepartments,tblCellChangePassword],@[tblCellLogout]];

    }else{
        arrTableCell = @[@[tblCellMyDepartments],@[tblCellLogout]];
    }
    
    
    tblSettings.tableFooterView = [[UIView alloc] init];
    [tblSettings reloadData];
}
#pragma mark - Action Methods
-(void)btnMenuPressed{
    openSideBarMenuFrom(self);
}


#pragma mark- Tableview Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrTableCell.count;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[arrTableCell objectAtIndex:section] count];
    
    //count number of row from counting array hear cataGorry is An Array
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  [arrTableCell objectAtIndex:indexPath.section][indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UniversityVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"UniversityVC"];
            mainvc.isOpenFromSettings = YES;
            [self.navigationController pushViewController:mainvc animated:YES];
        }else if (indexPath.row == 1){
            ChangePassVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"ChangePassVC"];
            [self.navigationController pushViewController:mainvc animated:YES];
        }
        
    }else{
        [self logoutUser];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 60;
    }
    return 44.0f;
}
#pragma mark- Logout
-(void)logoutUser{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:appName andMessage:_notify_CONFIRM_LOGOUT];
    [alertView addButtonWithTitle:_static_NO
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {

                          }];
    [alertView addButtonWithTitle:_static_YES
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              
                              [userDefaults setBool:NO
                                             forKey:_static_IS_ALLREADY_LOGEDIN];
                              [userDefaults setBool:NO forKey:_static_USER_ENROLLED_DEPT];
                              [userDefaults removeObjectForKey:_static_userdepartments];
                              [userDefaults setBool:NO forKey:_static_IS_LOGEDIN_AS_GUEST];
                              [userDefaults synchronize];
                              
//                              UINavigationController *cnav = (UINavigationController*) appDelegateObj.window.rootViewController;
//                              [cnav popToRootViewControllerAnimated:NO];
                              
                              UINavigationController *nav = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"LoginNavControll"];
                              
                              appDelegateObj.window.rootViewController = nav;
                              
                          }];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    [alertView show];
}

@end
