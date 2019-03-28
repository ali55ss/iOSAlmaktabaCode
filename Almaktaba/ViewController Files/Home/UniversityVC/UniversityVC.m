//
//  UniversityVC.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 12/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "UniversityVC.h"
#import "UniversityListCell.h"
#import "UniversitySuggetionVC.h"
#import "CollegeVC.h"


#import "Universities.h"
#import "CourseVC.h"

#import <math.h>

@interface UniversityVC ()

@end

@implementation UniversityVC
static NSString* const uniCell = @"UniversityListCell";

#pragma mark- Config

-(void)config{
    
    self.title = _static_Universities;
    
    _searchBar.delegate = self;
    _searchBar.placeholderText = _static_Search;
    
    if (!self.isOpenFromSettings) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(btnMenuPressed)];
    }
    
    if([userDefaults boolForKey:_static_IS_LOGEDIN_AS_GUEST]){
        [btnSuggestUni setImage:[UIImage imageNamed:@"ic_guest_user"] forState:UIControlStateNormal];
    }
    
}
#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isOpenFromSettings || [userDefaults boolForKey:_static_IS_LOGEDIN_AS_GUEST]) {
        [self initialiseView];
    }else{
        if ([userDefaults boolForKey:_static_USER_ENROLLED_DEPT]) {
            NSLog(@"%@",[userDefaults valueForKey:_static_userdepartments]);
            
            CourseVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"CourseVC"];
            mainvc.collegedepartment_id = [[[userDefaults valueForKey:_static_userdepartments] valueForKey:_param_collegedepartment_id] intValue];
            mainvc.isEnrolledDept = YES;
            [self.navigationController pushViewController:mainvc animated:NO];
            
        }else{
            [self initialiseView];
        }
    }
    
    //Construct the Notification
    [notificationCenter removeObserver:self name:@"NotifyGuestuserForLoginDidHappenNotification" object:nil];
    [notificationCenter addObserver:self selector:@selector(notifyGuestUserLogin)  name:@"NotifyGuestuserForLoginDidHappenNotification" object:nil];
    
    
  
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)initialiseView{
    [self config];
    [self setupTableView];
    
    [self refreshTable];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- notigy gest login
-(void)notifyGuestUserLogin{
    if([[SharedClass sharedManager] isGuestTapOnProfileOrSettings]){
        [[SharedClass sharedManager] setIsGuestTapOnProfileOrSettings:NO];
        [Global runAfterDelay:0 block:^{
            LoginVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
            [self.navigationController pushViewController:mainvc animated:YES];
        }];
    }
}

#pragma mark- setup TableView
-(void)setupTableView{
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [tblUniversityList addSubview:self.refreshControl];
    
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [tblUniversityList registerNib:[UINib nibWithNibName:uniCell bundle:nil] forCellReuseIdentifier:uniCell];
    
    tblUniversityList.tableFooterView = [[UIView alloc] init];
}
-(void)refreshTable{
    
    [self callWebserviceForGetUniversityList];
}
#pragma mark- Action Methods
- (IBAction)clk_btnSuggestUniversity:(id)sender {
    if([userDefaults boolForKey:_static_IS_LOGEDIN_AS_GUEST]){
        LoginVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:mainvc animated:YES];
        
    }else{
        UniversitySuggetionVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"UniversitySuggetionVC"];
        [self.navigationController pushViewController:mainvc animated:YES];
    }
}
-(void)btnMenuPressed{
    openSideBarMenuFrom(self);
    
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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.uni_name contains[cd] %@", strSearchText];
        filteredArray = [arrUniInfo filteredArrayUsingPredicate:predicate];
        NSLog(@"%@",filteredArray);
    }else{
        filteredArray = arrUniInfo;
    }
    imgNoRecordFound.hidden = filteredArray.count;
    [tblUniversityList reloadData];
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
    
    UniversityListCell *cell = [tableView dequeueReusableCellWithIdentifier:uniCell];
    
    if (cell == nil)
    {
        cell = [[UniversityListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:uniCell] ;
    }
    
    Universities *uniInfo = [filteredArray objectAtIndex:indexPath.row];
    
    [cell setUniversityData:uniInfo];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Universities *uniInfo = [filteredArray objectAtIndex:indexPath.row];
    
    CollegeVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"CollegeVC"];
    mainvc.university_id = uniInfo.id;
    mainvc.isOpenFromSettings = _isOpenFromSettings;
    [self.navigationController pushViewController:mainvc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark- API Service
-(void)callWebserviceForGetUniversityList{
    [Universities getUniversitiesListWithCompletion:^(id responsedict) {
        
        [self resetUniData];
        if (responsedict) {
            arrUniInfo = [RMMapper mutableArrayOfClass:[Universities class] fromArrayOfDictionary:responsedict];
            filteredArray = arrUniInfo;
            
            imgNoRecordFound.hidden = filteredArray.count;
        }
        [tblUniversityList reloadData];
        [_refreshControl endRefreshing];
    }];
}
-(void)resetUniData{
    if (arrUniInfo != nil) {
        arrUniInfo = nil;
    }
    arrUniInfo = [[NSMutableArray alloc] init];
    
    if (filteredArray != nil) {
        filteredArray = nil;
    }
    filteredArray = [[NSMutableArray alloc] init];
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
