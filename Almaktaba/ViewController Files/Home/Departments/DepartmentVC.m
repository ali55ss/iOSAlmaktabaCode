//
//  DepartmentVC.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 13/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "DepartmentVC.h"
#import "DepartmentListCell.h"
#import "DepartmentSuggestionVC.h"
#import "CourseVC.h"
#import "Collegedepartments.h"
#import "Userdepartments.h"
@interface DepartmentVC ()

@end

@implementation DepartmentVC
static NSString* const deptCell = @"DepartmentListCell";

#pragma mark- Config

-(void)config{
    
    self.title = _static_Departments;
    
    _searchBar.delegate = self;
    _searchBar.placeholderText = _static_Search;
    
    if([userDefaults boolForKey:_static_IS_LOGEDIN_AS_GUEST]){
        [btnSuggestDept setImage:[UIImage imageNamed:@"ic_guest_user"] forState:UIControlStateNormal];
    }
    
}
#pragma mark- View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self config];
    [self setupTableView];
    
    /**
     Call API For Get Depatment List
     */
    [self refreshTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- setup TableView
-(void)setupTableView{
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [tblDepartmentList addSubview:self.refreshControl];
    
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [tblDepartmentList registerNib:[UINib nibWithNibName:deptCell bundle:nil] forCellReuseIdentifier:deptCell];
    
    tblDepartmentList.tableFooterView = [[UIView alloc] init];
}
-(void)refreshTable{
    [self callWebserviceForGetDepartmentList];
}
#pragma mark- Action Methods
- (IBAction)clk_btnSuggestNewDepartment:(id)sender {
    if([userDefaults boolForKey:_static_IS_LOGEDIN_AS_GUEST]){
        LoginVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:mainvc animated:YES];
        
    }else{
        DepartmentSuggestionVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"DepartmentSuggestionVC"];
        mainvc.college_id = self.college_id;
        [self.navigationController pushViewController:mainvc animated:YES];
    }
}

#pragma mark- Search Bar Delegate
- (void)searchBar:(TOSearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [NSThread cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(searchAutocomplete:) withObject:searchText afterDelay:0.5];
}

- (void)searchBarSearchButtonTapped:(TOSearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
    [self searchAutocomplete:searchBar.text];
}

-(void)searchAutocomplete:(NSString*)searchText{
    NSString *strSearchText = trimmedString(searchText);
    if (strSearchText.length) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.Departments.department_name contains[cd] %@", strSearchText];
        filteredArray = [arrDeptInfo filteredArrayUsingPredicate:predicate];
        NSLog(@"%@",filteredArray);
    }else{
        filteredArray = arrDeptInfo;
    }
    imgNoRecordFound.hidden = filteredArray.count;
    [tblDepartmentList reloadData];
}

#pragma mark - External Interactions -
- (void)dismissKeyboard
{
    if ([self.searchBar isFirstResponder])
    [self.searchBar resignFirstResponder];
}
#pragma mark- Tableview Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return filteredArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DepartmentListCell *cell = [tableView dequeueReusableCellWithIdentifier:deptCell];
    
    if (cell == nil)
    {
        cell = [[DepartmentListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:deptCell] ;
    }
    
    Collegedepartments *deptInfo = [filteredArray objectAtIndex:indexPath.row];
    
    [cell setDepartmentData:deptInfo];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Collegedepartments *deptInfo = [filteredArray objectAtIndex:indexPath.row];
    
    
     if([userDefaults boolForKey:_static_IS_LOGEDIN_AS_GUEST]){
         CourseVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"CourseVC"];
         mainvc.collegedepartment_id = deptInfo.id;
         [self.navigationController pushViewController:mainvc animated:YES];
         
     }else{
         SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:appName andMessage:_notify_enroll_department];
         [alertView addButtonWithTitle:_static_NO
                                  type:SIAlertViewButtonTypeDefault
                               handler:^(SIAlertView *alert) {
                                   [self showDepartmentCourse:deptInfo];
                               }];
         [alertView addButtonWithTitle:_static_YES
                                  type:SIAlertViewButtonTypeDestructive
                               handler:^(SIAlertView *alert) {
                                   if ([userDefaults boolForKey:_static_USER_ENROLLED_DEPT] && _isOpenFromSettings) {
                                       [self callWebserviceForEditEnrolledDepartment:deptInfo.id];
                                   }else{
                                       [self callWebserviceForEnrolledDepartment:[NSString stringWithFormat:@"%d",deptInfo.id]];
                                   }
                               }];
         
         alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
         [alertView show];
     }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

#pragma mark- Open Course
-(void)showDepartmentCourse:(Collegedepartments*)deptInfo{
    
    CourseVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"CourseVC"];
    mainvc.collegedepartment_id = deptInfo.id;
    mainvc.isEnrolledDept = NO;
    [self.navigationController pushViewController:mainvc animated:YES];
}

#pragma mark- Reset Deparment Data
-(void)resetDepartData{
    if (arrDeptInfo != nil) {
        arrDeptInfo = nil;
    }
    arrDeptInfo = [[NSMutableArray alloc] init];
    if (filteredArray != nil) {
        filteredArray = nil;
    }
    filteredArray = [[NSMutableArray alloc] init];
}
#pragma mark- API Service
-(void)callWebserviceForGetDepartmentList{
    
    [Collegedepartments getDepartmentsListOfCollegeID:self.college_id WithCompletion:^(id responsedict) {
        [self resetDepartData];
        if (responsedict) {
            arrDeptInfo = [RMMapper mutableArrayOfClass:[Collegedepartments class] fromArrayOfDictionary:responsedict];
            filteredArray = arrDeptInfo;
            imgNoRecordFound.hidden = filteredArray.count;
        }
        [tblDepartmentList reloadData];
        [_refreshControl endRefreshing];
    }];
}


-(void)callWebserviceForEnrolledDepartment:(NSString*)collegedepartment_id{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[Global objectFromDataWithKey:_static_USER_INFO] valueForKey:_param_id] forKey:_param_user_id];
    [param setValue:collegedepartment_id forKey:_param_collegedepartment_id];
    
    [Userdepartments enrollUserDepartmentWithData:param withCompletion:^(NSDictionary *responsedic) {
        if (responsedic) {
            [userDefaults setValue:responsedic forKey:_static_userdepartments];
            [userDefaults setBool:YES forKey:_static_USER_ENROLLED_DEPT];
            
            [userDefaults synchronize];
            
            
            CourseVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"CourseVC"];
            mainvc.collegedepartment_id = [collegedepartment_id intValue];
            mainvc.isEnrolledDept = YES;
            [self pushViewController:mainvc];
            
            //            [appDelegateObj addSlideMenuAfterLogin];
        }
    }];
}
-(void)callWebserviceForEditEnrolledDepartment:(int)collegedepartment_id{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[Global objectFromDataWithKey:_static_USER_INFO] valueForKey:_param_id] forKey:_param_user_id];
    [param setValue:[NSString stringWithFormat:@"%d",collegedepartment_id] forKey:_param_collegedepartment_id];
    [param setValue:[[userDefaults valueForKey:_static_userdepartments] valueForKey:_param_id]  forKey:_param_id];
    
    
    [Userdepartments editEnrollUserDepartmentWithData:param withCompletion:^(NSDictionary *responsedic) {
        if (responsedic) {
            [userDefaults setValue:responsedic forKey:_static_userdepartments];
            [userDefaults setBool:YES forKey:_static_USER_ENROLLED_DEPT];
            
            [userDefaults synchronize];
            
            CourseVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"CourseVC"];
            mainvc.collegedepartment_id = collegedepartment_id;
            mainvc.isEnrolledDept = YES;
            [self pushViewController:mainvc];
        }
    }];
    
}
#pragma mark- Push View Controller
-(void)pushViewController:(UIViewController*)viewCtrl{
    
    UINavigationController *nav = (UINavigationController*) self.sideMenuViewController.contentViewController;
    NSMutableArray *viewControllerArray = [nav.viewControllers mutableCopy];
    [viewControllerArray removeAllObjects];
    [viewControllerArray addObject:viewCtrl];
    [nav setViewControllers:viewControllerArray animated:NO];
    [self.sideMenuViewController hideMenuViewControllerAnimated:YES];
}
@end
