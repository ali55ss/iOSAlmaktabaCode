//
//  CourseVC.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 13/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "CourseVC.h"
#import "CourseSuggestionVC.h"
#import "CourseListCell.h"


#import "DocsFeedVC.h"
#import "Departmentcourses.h"
@interface CourseVC ()

@end

@implementation CourseVC
static NSString* const courseCell = @"CourseListCell";
-(void)config{
    
    if (_isOpenFromUploadDocs) {
        self.title = _static_Select_a_Course;
        
        doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnDonePressed)];
        
    }else{
        self.title = _static_Courses;
        
        if ([userDefaults boolForKey:_static_USER_ENROLLED_DEPT] && self.isEnrolledDept) {
            
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(clk_menubtn)];
        }
    }
    
    _searchBar.delegate = self;
    _searchBar.placeholderText = _static_Search;
    
    
    if([userDefaults boolForKey:_static_IS_LOGEDIN_AS_GUEST]){
        [btnSeggestCourse setImage:[UIImage imageNamed:@"ic_guest_user"] forState:UIControlStateNormal];
    }
    
}
#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self config];
    [self setupTableView];
    
    
    /**
     Call API for get Course List
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
    [tblCourseList addSubview:self.refreshControl];
    
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [tblCourseList registerNib:[UINib nibWithNibName:courseCell bundle:nil] forCellReuseIdentifier:courseCell];
    
    tblCourseList.tableFooterView = [[UIView alloc] init];
}

-(void)refreshTable{
    
    [self callWebserviceForGetCourseList];
}
#pragma mark- Action Methods
-(void)clk_menubtn{
    openSideBarMenuFrom(self);
}
- (IBAction)clk_btnSuggestNewCourse:(id)sender {
    
    if([userDefaults boolForKey:_static_IS_LOGEDIN_AS_GUEST]){
        LoginVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:mainvc animated:YES];
        
    }else{
        CourseSuggestionVC *mainVC = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"CourseSuggestionVC"];
        mainVC.collegedepartment_id = self.collegedepartment_id;
        [self.navigationController pushViewController:mainVC animated:YES];
    }
}

-(void)btnDonePressed{
    Departmentcourses  *courseInfo = [arrCourseInfo objectAtIndex:selectedIndex];
    if (self.selectedCourse) {
        self.selectedCourse(courseInfo.Courses.course_code, courseInfo.Courses.course_name,courseInfo.id);
        
        [self.navigationController popViewControllerAnimated:YES];
        self.selectedCourse = nil;
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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.Courses.course_name contains[cd] %@", strSearchText];
        filteredArray = [arrCourseInfo filteredArrayUsingPredicate:predicate];
        NSLog(@"%@",filteredArray);
    }else{
        filteredArray = arrCourseInfo;
    }
    imgNoRecordFound.hidden = filteredArray.count;
    [tblCourseList reloadData];
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
    
    CourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:courseCell];
    
    if (cell == nil)
    {
        cell = [[CourseListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:courseCell] ;
    }
    
    Departmentcourses  *courseInfo = [filteredArray objectAtIndex:indexPath.row];
    
    [cell setCourseData:courseInfo];
    
    if (_isOpenFromUploadDocs){
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isOpenFromUploadDocs) {
        selectedIndex = indexPath.row;
        
        self.navigationItem.rightBarButtonItem = doneBtn;
        
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        
    }else{
        Departmentcourses  *courseInfo = [filteredArray objectAtIndex:indexPath.row];
        
        DocsFeedVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"DocsFeedVC"];
        mainvc.collegedepartment_id = self.collegedepartment_id;
        mainvc.departmentcourse_id = courseInfo.id;
        mainvc.course_code = courseInfo.Courses.course_code;
        mainvc.course_name = courseInfo.Courses.course_name;
        [self.navigationController pushViewController:mainvc animated:YES];
    }
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isOpenFromUploadDocs){
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

#pragma mark - callback function
-(void)notifySelectedCourse:(SelectedCourse)callBack{
    self.selectedCourse = callBack;
}


#pragma mark- Reset Course Data
-(void)resetCoursedata{
    if (arrCourseInfo != nil) {
        arrCourseInfo = nil;
    }
    arrCourseInfo = [[NSMutableArray alloc] init];
    if (filteredArray != nil) {
        filteredArray = nil;
    }
    filteredArray = [[NSMutableArray alloc] init];
}
#pragma mark- API Service
-(void)callWebserviceForGetCourseList{
    
    [Departmentcourses getCourseListOfDeptID:self.collegedepartment_id WithCompletion:^(id responsedict) {
        
        [self resetCoursedata];
        if (responsedict) {
            arrCourseInfo = [RMMapper mutableArrayOfClass:[Departmentcourses class] fromArrayOfDictionary:responsedict];
            filteredArray = arrCourseInfo;
            imgNoRecordFound.hidden = filteredArray.count;
        }
        [tblCourseList reloadData];
        [_refreshControl endRefreshing];
    }];
}

@end
