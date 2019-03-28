//
//  CollegeVC.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 13/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOSearchBar.h"
@interface CollegeVC : UIViewController <TOSearchBarDelegate>
{
    NSMutableArray * arrCollegeInfo;
 NSArray *filteredArray;
    __weak IBOutlet UITableView *tblCollegeList;
    __weak IBOutlet UIImageView *imgNoRecordFound;
    
    __weak IBOutlet UIButton *btnSuggestCollege;
}
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic, strong, readwrite) IBOutlet TOSearchBar *searchBar;
- (IBAction)clk_btnSuggestNewCollege:(id)sender;


/**
 it is useful for get college list of perticular university
 */
@property (assign) int university_id;

/**
 It will use for change department from settings
 */
@property(assign)BOOL isOpenFromSettings;
@end
