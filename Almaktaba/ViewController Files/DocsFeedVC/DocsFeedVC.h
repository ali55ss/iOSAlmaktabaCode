//
//  DocsFeedVC.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 14/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFTextField.h"
@interface DocsFeedVC : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>
{
    NSMutableArray * feedDataArray;
    NSMutableArray * documentsFeed;
    
    NSArray *arrReportType;
    NSInteger reportIndex;
    NSInteger documentIdForReport;

    int myUserID;

    
    /**
     @Reports View
     */
    __weak IBOutlet UIView *reportMainView;
    __weak IBOutlet UIView *reportDialog;
    __weak IBOutlet UILabel *lblReportTitle;
    __weak IBOutlet MFTextField *lblReportType;
    __weak IBOutlet UITextView *txtViewReportDesc;
    __weak IBOutlet UIButton *btnSubmitReports;
    __weak IBOutlet UILabel *errorLblDesc;
    
    __weak IBOutlet UIImageView *imgNoRecordFound;
    
    
    __weak IBOutlet UIButton *btnAddDocument;
}
- (IBAction)clk_btnUploadDocument:(id)sender;
- (IBAction)clk_btnSubmitReports:(id)sender;
- (IBAction)clk_closeReportMainView:(id)sender;
//- (IBAction)clk_btnSelectReportOption:(id)sender;
- (IBAction)txtReportTypeSelect:(UITextField *)sender;


@property (assign) int course_code;
@property (strong, nonatomic) NSString * course_name;

@property (nonatomic, weak) NSMutableDictionary *contentOffsetDictionary;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) UIRefreshControl *refreshControl;


/*!
 * @brief  it is useful for get course list based in college department.
 */
@property (assign) int collegedepartment_id;

@property (assign) int departmentcourse_id;

@end
