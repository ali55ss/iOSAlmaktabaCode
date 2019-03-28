//
//  LeftMenuVC.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 14/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "LeftMenuVC.h"
#import "ProfileVC.h"
#import "UniversityVC.h"
#import "SettingsVC.h"
#import "CourseVC.h"

@interface LeftMenuVC ()

@end

@implementation LeftMenuVC

#pragma mark- Comman Init
-(void)commanInit{
    
    /**
     Set Color and Fonts
     */
    lblUserName.textColor = theme_Black_Color;
    lblUserName.font = [Font setFont_Medium_Size:16];
    
    lblUserEmail.textColor = theme_Gray_Color;
    lblUserEmail.font = [Font setFont_Regular_Size:14];
    
    /**
     set Corner Radious
     */
    setCornerRadius(imgUserImage.layer, imgUserImage.height/2, 0, nil, NO);
    
    [btnClose setTitle:_static_Close forState:UIControlStateNormal];
}
#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commanInit];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    lblUserName.text = [NSString stringWithFormat:@"%@ %@",[[Global objectFromDataWithKey:_static_USER_INFO] valueForKey:_param_firstname],[[Global objectFromDataWithKey:_static_USER_INFO] valueForKey:_param_lastname]];
    
    if ([lblUserName.text containsString:@"<null>"]){
        
        lblUserName.text = @"";
    }
    lblUserEmail.text = [[Global objectFromDataWithKey:_static_USER_INFO] valueForKey:_param_email];
    
    [activityIndicator startAnimating];
    [activityIndicator setHidden:NO];
    [imgUserImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_PROFILE_IMAGE_URL,[[Global objectFromDataWithKey:_static_USER_INFO] valueForKey:_param_profile_image]]] placeholderImage:[UIImage imageNamed:@"noUser"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [activityIndicator stopAnimating];
        [activityIndicator setHidden:YES];
    }];
    
    [self setupTableView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- setup Tableview
-(void)setupTableView{
   
    if ([userDefaults boolForKey:_static_USER_ENROLLED_DEPT]) {
        arrMenuItem = [[NSArray alloc] initWithObjects: LocalizedString(@"My Department Cources"), LocalizedString(@"Profile"), LocalizedString(@"Settings"), nil];
    }else{
        arrMenuItem = [[NSArray alloc] initWithObjects: LocalizedString(@"My University"), LocalizedString(@"Profile"), LocalizedString(@"Settings"), nil];
    }
}
#pragma mark- Action Methods
- (IBAction)clk_btnClose:(id)sender {
    [self.sideMenuViewController hideMenuViewControllerAnimated:YES];
}
#pragma mark- Tableview Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrMenuItem.count;    //count number of row from counting array hear cataGorry is An Array
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             @"menuCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:@"menuCell"];
    }
    
    UILabel *lblLine = (UILabel*)[cell viewWithTag:101];
    UILabel *lblTitle = (UILabel*)[cell viewWithTag:102];
    
    
    lblTitle.textColor = theme_Black_Color;
    lblTitle.font = [Font setFont_Medium_Size:16];
    
    lblTitle.text = [arrMenuItem objectAtIndex:indexPath.row];
    
    //    UIView *bgColorView = [[UIView alloc] init];
    //    bgColorView.backgroundColor = theme_Gray_Color;
    //    [cell setSelectedBackgroundView:bgColorView];
    
    if (selectedIndex == indexPath.row) {
        [lblLine setHidden:NO];
        cell.backgroundColor = theme_Light_Gray_Color;
    }else{
        [lblLine setHidden:YES];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    if([userDefaults boolForKey:_static_IS_LOGEDIN_AS_GUEST]){
        if(indexPath.row == 1 || indexPath.row == 2){
            lblTitle.alpha = 0.5;
        }else
        {
            lblTitle.alpha = 1.0;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedIndex = indexPath.row;
    [tableView reloadData];
    UINavigationController *nav = (UINavigationController*) self.sideMenuViewController.contentViewController;
    
    if (indexPath.row == 0) {
        if ([userDefaults boolForKey:_static_USER_ENROLLED_DEPT]) {
            if ([nav.visibleViewController isKindOfClass:[CourseVC class]]) {
                [self.sideMenuViewController hideMenuViewController];
                return;
            }else{
                CourseVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"CourseVC"];
                mainvc.collegedepartment_id = [[[userDefaults valueForKey:_static_userdepartments] valueForKey:_param_collegedepartment_id] intValue];
                mainvc.isEnrolledDept = YES;
                [self pushViewController:mainvc];
            }
        }else{
            if ([nav.visibleViewController isKindOfClass:[UniversityVC class]]) {
                [self.sideMenuViewController hideMenuViewController];
                return;
            }else{
                UniversityVC *mainVC=[appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"UniversityVC"];
                [self pushViewController:mainVC];
            }
        }
    }else if (indexPath.row == 1) {
        
        if([userDefaults boolForKey:_static_IS_LOGEDIN_AS_GUEST]){
            [self showLoginAlert];
        }else{
            ProfileVC *mainVC=[appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"ProfileVC"];
            [self pushViewController:mainVC];
        }
        
        
        
    }else if (indexPath.row == 2) {
        if([userDefaults boolForKey:_static_IS_LOGEDIN_AS_GUEST]){
            [self showLoginAlert];
        }else{
            if ([nav.visibleViewController isKindOfClass:[SettingsVC class]]) {
                [self.sideMenuViewController hideMenuViewController];
                return;
            }else{
                SettingsVC *mainvc = [[SettingsVC alloc] initWithNibName:@"SettingsVC" bundle:nil];
                [self pushViewController:mainvc];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0f;
}


#pragma mark- Show Login Alert
-(void)showLoginAlert{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:appName andMessage:_notify_GUEST_LOGIN];
    [alertView addButtonWithTitle:_static_NO
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              
                          }];
    [alertView addButtonWithTitle:_static_YES_TAKE_ME_THERE
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              
                              [[SharedClass sharedManager] setIsGuestTapOnProfileOrSettings:YES];
                              
                              [notificationCenter postNotificationName:@"NotifyGuestuserForLoginDidHappenNotification" object:nil];
                              [self.sideMenuViewController hideMenuViewControllerAnimated:NO];

                          }];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    [alertView show];
}
#pragma mark- Push View Controller
-(void)pushViewController:(UIViewController*)viewCtrl{
    
    UINavigationController *nav = (UINavigationController*) self.sideMenuViewController.contentViewController;
    //    [nav pushViewController:viewCtrl animated:YES];
    NSMutableArray *viewControllerArray = [nav.viewControllers mutableCopy];
    [viewControllerArray removeAllObjects];
    [viewControllerArray addObject:viewCtrl];
    [nav setViewControllers:viewControllerArray animated:NO];
    
    [self.sideMenuViewController hideMenuViewControllerAnimated:YES];
}


@end
