//
//  UniversityVC.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 12/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOSearchBar.h"
@interface UniversityVC : UIViewController <TOSearchBarDelegate>
{
    NSMutableArray * arrUniInfo;
    NSArray *filteredArray;
    
    __weak IBOutlet UITableView *tblUniversityList;
    __weak IBOutlet UIImageView *imgNoRecordFound;
    __weak IBOutlet UIButton *btnSuggestUni;
}
@property (nonatomic, strong, readwrite) IBOutlet TOSearchBar *searchBar;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
- (IBAction)clk_btnSuggestUniversity:(id)sender;

/**
 It will use for change department from settings
 */
@property(assign)BOOL isOpenFromSettings;



@end
