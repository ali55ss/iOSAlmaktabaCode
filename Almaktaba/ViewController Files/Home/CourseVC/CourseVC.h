//
//  CourseVC.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 13/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOSearchBar.h"
@interface CourseVC : UIViewController<TOSearchBarDelegate>
{
    NSMutableArray *arrCourseInfo;
    NSArray *filteredArray;

    NSInteger selectedIndex;
    UIBarButtonItem *doneBtn;
    
    __weak IBOutlet UITableView *tblCourseList;
    __weak IBOutlet UIImageView *imgNoRecordFound;
    
    __weak IBOutlet UIButton *btnSeggestCourse;
}
- (IBAction)clk_btnSuggestNewCourse:(id)sender;

@property (nonatomic, strong, readwrite) IBOutlet TOSearchBar *searchBar;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (assign) int collegedepartment_id;

/**
 it is useful for identify from which screen open
 */
@property (assign) BOOL isOpenFromUploadDocs;

/**
 it is useful for supply selected course
 */
typedef void (^SelectedCourse)(int course_code,NSString * course_name,int departmentcourse_id);
@property (copy, nonatomic) SelectedCourse selectedCourse;

-(void)notifySelectedCourse:(SelectedCourse)callBack;


/**
 It will use for change department from settings
 */
@property(assign)BOOL isOpenFromSettings;

/**
 It will use for identify user is enroll or not;
 */
@property(assign)BOOL isEnrolledDept;


@end
