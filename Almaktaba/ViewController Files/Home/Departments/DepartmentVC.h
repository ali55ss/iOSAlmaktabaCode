//
//  DepartmentVC.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 13/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOSearchBar.h"
@interface DepartmentVC : UIViewController <TOSearchBarDelegate>
{
    NSMutableArray * arrDeptInfo;
    NSArray *filteredArray;
    
    __weak IBOutlet UITableView *tblDepartmentList;
    __weak IBOutlet UIImageView *imgNoRecordFound;
    
    __weak IBOutlet UIButton *btnSuggestDept;
}

@property (strong, nonatomic) UIRefreshControl *refreshControl;
- (IBAction)clk_btnSuggestNewDepartment:(id)sender;

@property (nonatomic, strong, readwrite) IBOutlet TOSearchBar *searchBar;

@property (assign) int college_id;

/**
 It will use for change department from settings
 */
@property(assign)BOOL isOpenFromSettings;
@end
