//
//  UploadDocsVC.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 14/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFTextField.h"
#import "GMImagePickerController.h"
#import "IRLScannerViewController.h"

@interface UploadDocsVC : UIViewController <GMImagePickerControllerDelegate,IRLScannerViewControllerDelegate, UITextViewDelegate,UIDocumentPickerDelegate>
{

    NSArray *arrImgsExt,*arrDocsExt, *arrVideosExt;
    
    __weak IBOutlet MFTextField *txtCourseCode;
    __weak IBOutlet MFTextField *txtCourseName;
    __weak IBOutlet MFTextField *txtDocsTitle;
    __weak IBOutlet UITextView *txtDocsDescription;
    __weak IBOutlet UIButton *btnUploadDocs;
    
    __weak IBOutlet UILabel *errorLblDesc;
    
}

- (IBAction)clk_btnUploadDocs:(id)sender;
- (IBAction)textFieldDidBegin:(UITextField *)sender;
- (IBAction)textFieldDidEndEditing:(MFTextField *)sender;
- (IBAction)clk_txtFieldSelectCourseName:(id)sender;


@property (assign) int course_code;
@property (strong, nonatomic) NSString * course_name;


/**
 requestOptions object use for get image from main array images(arrmultipages).
 */
@property (nonatomic, strong) PHImageRequestOptions *requestOptions;


/**
 it is useful for get course list based in college department
 */
@property (assign) int collegedepartment_id;
@property (assign) int departmentcourse_id;

- (IBAction)clk_SelectCourse:(id)sender;

@end
