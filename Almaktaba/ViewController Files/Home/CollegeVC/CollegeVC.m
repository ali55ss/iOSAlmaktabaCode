//
//  CollegeVC.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 13/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "CollegeVC.h"
#import "CollegeListCell.h"
#import "CollegeSuggestionVC.h"
#import "DepartmentVC.h"

#import "Colleges.h"
@interface CollegeVC ()

@end

@implementation CollegeVC
static NSString* const collegCell = @"CollegeListCell";

#pragma mark- Config
-(void)config{
    self.title = _static_Colleges;
    
    _searchBar.delegate = self;
    _searchBar.placeholderText = _static_College_Name;
    
    if([userDefaults boolForKey:_static_IS_LOGEDIN_AS_GUEST]){
        [btnSuggestCollege setImage:[UIImage imageNamed:@"ic_guest_user"] forState:UIControlStateNormal];
    }
}


#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self config];
    [self setupTableView];
    
    /**
     call API for get college list
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
    [tblCollegeList addSubview:self.refreshControl];
    
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [tblCollegeList registerNib:[UINib nibWithNibName:collegCell bundle:nil] forCellReuseIdentifier:collegCell];
    
    tblCollegeList.tableFooterView = [[UIView alloc] init];
}
-(void)refreshTable{
    [self callWebserviceForGetCollegeList];
}

#pragma mark- Add Action Methods
- (IBAction)clk_btnSuggestNewCollege:(id)sender {
    if([userDefaults boolForKey:_static_IS_LOGEDIN_AS_GUEST]){
        LoginVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:mainvc animated:YES];
        
    }else{
        CollegeSuggestionVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"CollegeSuggestionVC"];
        mainvc.university_id = self.university_id;
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
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.college_name contains[cd] %@", strSearchText];
        filteredArray = [arrCollegeInfo filteredArrayUsingPredicate:predicate];
        NSLog(@"%@",filteredArray);
    }else{
        filteredArray = arrCollegeInfo;
    }
    imgNoRecordFound.hidden = filteredArray.count;
    [tblCollegeList reloadData];
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
    
    CollegeListCell *cell = [tableView dequeueReusableCellWithIdentifier:collegCell];
    
    if (cell == nil)
    {
        cell = [[CollegeListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:collegCell] ;
    }
    
    Colleges *collegeInfo = [filteredArray objectAtIndex:indexPath.row];
    
    [cell setCollegeData:collegeInfo];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Colleges *collegeInfo = [filteredArray objectAtIndex:indexPath.row];
    
    DepartmentVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"DepartmentVC"];
    mainvc.college_id = collegeInfo.id;
    mainvc.isOpenFromSettings = self.isOpenFromSettings;
    [self.navigationController pushViewController:mainvc animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


#pragma mark- Reset College data
-(void)resetCollegedata{
    if (arrCollegeInfo != nil) {
        arrCollegeInfo = nil;
    }
    arrCollegeInfo = [[NSMutableArray alloc] init];
    if (filteredArray != nil) {
        filteredArray = nil;
    }
    filteredArray = [[NSMutableArray alloc] init];
    
}
#pragma mark- API Service
-(void)callWebserviceForGetCollegeList{
    [Colleges getCollegesListOfUniversityID:self.university_id WithCompletion:^(id responsedict) {
        
        [self resetCollegedata];
        if (responsedict) {
            arrCollegeInfo = [RMMapper mutableArrayOfClass:[Colleges class] fromArrayOfDictionary:responsedict];
            filteredArray = arrCollegeInfo;
            imgNoRecordFound.hidden = filteredArray.count;
        }
        [tblCollegeList reloadData];
        [_refreshControl endRefreshing];
    }];
}
@end
