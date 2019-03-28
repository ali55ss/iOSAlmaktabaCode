//
//  DocsFeedVC.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 14/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "DocsFeedVC.h"
#import "UploadDocsVC.h"

#import "Documents.h"

#import "UploadedOn.h"
#import "TotalLikes_Comments.h"
#import "SuggestedPeopleCell.h"
#import "PostImage.h"
#import "PostDescription.h"
#import "DetailText.h"
#import "Buttons.h"
#import "SectionHeaderOfPost.h"

#import "ActionSheetStringPicker.h"

#import "Documentreports.h"
#import "PreviewForAllDocs.h"
@interface DocsFeedVC ()

@end

@implementation DocsFeedVC

#pragma mark- commanInit
-(void)commanInit{
    self.title = _static_document_feed;
    
    /**
     Report Documents
     */
    
    [reportMainView setHidden:YES];
    
    
    lblReportTitle.text = _static_Report;
    lblReportTitle.textColor = theme_Black_Color;
    lblReportTitle.font = [Font setFont_Bold_Size:16];
    
    lblReportType.textColor = theme_Black_Color;
    lblReportType.font = [Font setFont_Regular_Size:16];;
    lblReportType.placeholder = _static_Select_Report_Type;
    
    txtViewReportDesc.font = [Font setFont_Regular_Size:16];
    txtViewReportDesc.delegate = self;
    txtViewReportDesc.text = _static_Please_enter_docs_desc;
    txtViewReportDesc.textColor = [UIColor lightGrayColor]; //optional
    
    errorLblDesc.font = [Font setFont_Medium_Size:12];
    errorLblDesc.textColor = theme_Red_Color;
    
    btnSubmitReports.titleLabel.font = [Font setFont_Bold_Size:16];
    [btnSubmitReports setTitle:_static_Submit forState:UIControlStateNormal];
    
    
    /**
     Set Corner radious
     */
    setCornerRadius(btnSubmitReports.layer, 3, 0.5, [UIColor lightGrayColor], NO);
    setCornerRadius(reportDialog.layer, 3.0, 1, theme_Gray_Color, NO);
    
    if([userDefaults boolForKey:_static_IS_LOGEDIN_AS_GUEST]){
        [btnAddDocument setImage:[UIImage imageNamed:@"ic_guest_user"] forState:UIControlStateNormal];
    }
}
#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commanInit];
    [self registerCells];
    [self setupTableView];
    
    
    /**
     Fetch my userid
     */
    myUserID = [[[Global objectFromDataWithKey:_static_USER_INFO] valueForKey:_param_id] intValue];
    
    
    /**
     Call API For get document feed
     */
    [self refreshTable];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([[SharedClass sharedManager] isUploadNewDocument]) {
        [self refreshTable];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Setup Tableview
-(void)setupTableView{
    _tableview.estimatedRowHeight=10;
    _tableview.rowHeight=UITableViewAutomaticDimension;
    
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [ _tableview addSubview:self.refreshControl];
    
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    
    _tableview.tableFooterView = [[UIView alloc] init];
    
    // Feed data array set add one extra array for which cell should be shown as per your json I have used six cells
    
}
-(void)refreshTable{
    [self callWebserviceForGetUploadedDocument];
}
-(void)createFeedCell{
    
    if (feedDataArray != nil) {
        feedDataArray = nil;
    }
    feedDataArray = [[NSMutableArray alloc] init];
    NSArray * data;
    if([userDefaults boolForKey:_static_IS_LOGEDIN_AS_GUEST]){
        data = @[@"date",@"description",@"PostImage",@"Postdescription"];
    }else{
        data = @[@"date",@"description",@"PostImage",@"Postdescription",@"Buttons"];
    }
    NSDictionary * dict =@{
                           @"dataToshow":data
                           };
    
    for (int i = 0; i< documentsFeed.count; i++) {
    
        [feedDataArray addObject:dict];
    }
    
}
#pragma mark- Register Cell
-(void)registerCells{
    
    UINib *nib = [UINib nibWithNibName:@"SectionHeaderOfPost" bundle:nil];
    [_tableview registerNib:nib forCellReuseIdentifier:@"SectionHeaderOfPost"];
    
    nib = [UINib nibWithNibName:@"UploadedOn" bundle:nil];
    [_tableview registerNib:nib forCellReuseIdentifier:@"UploadedOn"];
    
    nib = [UINib nibWithNibName:@"TotalLikes_Comments" bundle:nil];
    [_tableview registerNib:nib forCellReuseIdentifier:@"TotalLikes_Comments"];
    
    nib = [UINib nibWithNibName:@"PostImage" bundle:nil];
    [_tableview registerNib:nib forCellReuseIdentifier:@"PostImage"];
    
    nib = [UINib nibWithNibName:@"Buttons" bundle:nil];
    [_tableview registerNib:nib forCellReuseIdentifier:@"Buttons"];
    
    nib = [UINib nibWithNibName:@"DetailText" bundle:nil];
    [_tableview registerNib:nib forCellReuseIdentifier:@"DetailText"];
    
    nib = [UINib nibWithNibName:@"PostDescription" bundle:nil];
    [_tableview registerNib:nib forCellReuseIdentifier:@"PostDescription"];
    
    nib = [UINib nibWithNibName:@"SuggestedPeopleCell" bundle:nil];
    [_tableview registerNib:nib forCellReuseIdentifier:@"SuggestedPeopleCell"];
}

#pragma mark- Action Methods
- (IBAction)clk_btnUploadDocument:(id)sender {
    
    if([userDefaults boolForKey:_static_IS_LOGEDIN_AS_GUEST]){
        LoginVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:mainvc animated:YES];
        
    }else{
        UploadDocsVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"UploadDocsVC"];
        mainvc.collegedepartment_id = self.collegedepartment_id;
        mainvc.departmentcourse_id = self.departmentcourse_id;
        mainvc.course_code = self.course_code;
        mainvc.course_name = self.course_name;
        [self.navigationController pushViewController:mainvc animated:YES];
    }
}
- (IBAction)clk_btnSubmitReports:(id)sender {
    
    if ([self validateTxtFieldReportType]) {
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        if(![trimmedString(txtViewReportDesc.text) isEqualToString:_static_Please_enter_docs_desc]){
            [params setValue:trimmedString(txtViewReportDesc.text) forKey:@"description"];
        }
        [params setValue:[arrReportType objectAtIndex:reportIndex] forKey:_param_report_type];
        [params setValue:[NSString stringWithFormat:@"%d",myUserID] forKey:_param_user_id];
        [params setValue:[NSString stringWithFormat:@"%ld",(long)documentIdForReport] forKey:_param_document_id];
        [Documentreports addReportOnInappropriateDocumentWithData:params WithCompletion:^(id responsedict) {
            if (responsedict) {
                [self clk_closeReportMainView:sender];
                //                [self refreshTable];
            }
        }];
    }
}

- (IBAction)clk_closeReportMainView:(id)sender {
    [reportMainView setHidden:YES];
    lblReportType.text = nil;
    txtViewReportDesc.text = _static_Please_enter_docs_desc;
    txtViewReportDesc.textColor = [UIColor lightGrayColor]; //optional
    
}

- (void)clk_SelectReportOption:(id)sender {
    [ActionSheetStringPicker showPickerWithTitle:_static_Report_Type
                                            rows:arrReportType
                                initialSelection:reportIndex
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           reportIndex = selectedIndex;
                                           
                                           lblReportType.text = [arrReportType objectAtIndex:selectedIndex];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
}


- (IBAction)txtReportTypeSelect:(UITextField *)sender {
    if (sender == lblReportType) {
        [sender resignFirstResponder];
        [self clk_SelectReportOption:sender];
    }
}
#pragma mark === Tableview DataSources=======
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return feedDataArray.count+1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 0; // If wanna to show suggested people then 1 otherwise 0
    }else{
        
        // No of things you wanna to show into a feed View.
        NSArray * arr =[[feedDataArray objectAtIndex:section - 1] valueForKey:@"dataToshow"];
        return arr.count;
        
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            SuggestedPeopleCell * cell1 =(SuggestedPeopleCell *)cell;
            [cell1 setCollectionViewDataSourceDelegate:self indexPath:indexPath];
            NSInteger index = cell1.collectionView.tag;
            CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
            [cell1.collectionView setContentOffset:CGPointMake(horizontalOffset, 0)];
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell ;
    
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
            SuggestedPeopleCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"SuggestedPeopleCell" forIndexPath:indexPath];
            return cell;
        }
    }else{
        
        Documents *docInfo = [documentsFeed objectAtIndex:indexPath.section - 1];
        
        __block  NSMutableDictionary * dataDict =[[NSMutableDictionary alloc]initWithDictionary:[feedDataArray objectAtIndex:indexPath.section-1]];
        NSArray * arr =[dataDict valueForKey:@"dataToshow"];
        
        if ([[arr objectAtIndex:indexPath.row]isEqualToString:@"date"]) {
            
            UploadedOn *cell = [self.tableview dequeueReusableCellWithIdentifier:@"UploadedOn" forIndexPath:indexPath];
            cell.titleLabel.text = [NSDate mysqlDatetimeFormattedAsTimeAgo:docInfo.created];//@"Uploaded 10 Min Ago.";
            return cell;
            
        }else if ([[arr objectAtIndex:indexPath.row]isEqualToString:@"description"]) {
            
            PostDescription *cell = [self.tableview dequeueReusableCellWithIdentifier:@"PostDescription" forIndexPath:indexPath];
            cell.titleLabel.text = docInfo.doc_title;//@"Major Details Of Post";
            return cell;
            
        } else  if ([[arr objectAtIndex:indexPath.row]isEqualToString:@"PostImage"]) {
            
            PostImage *cell = [self.tableview dequeueReusableCellWithIdentifier:@"PostImage" forIndexPath:indexPath];
            
            
            [cell.postImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_DOCUMENT_URL,docInfo.front_image]] placeholderImage:[UIImage imageNamed:@"PostImage"] options:SDWebImageProgressiveDownload];
            
            cell.postImage.layer.masksToBounds = YES;
            
            if ([docInfo.mime_type isEqualToString:@"pdf"]) {
                cell.playIcon.hidden = YES;
            }else{
                cell.playIcon.hidden = NO;
            }
            //             cell.postImage.image=[UIImage imageNamed:@""];
            
            
            return cell;
        }else if ([[arr objectAtIndex:indexPath.row]isEqualToString:@"Postdescription"]) {
            
            DetailText *cell = [self.tableview dequeueReusableCellWithIdentifier:@"DetailText" forIndexPath:indexPath];
            cell.titleLabel.text = docInfo.doc_description; //@"Minor details of Post \n You can Hide this too.";
            
            return cell;
            
        }else if ([[arr objectAtIndex:indexPath.row]isEqualToString:@"LikeComment"]) {
            
            TotalLikes_Comments *cell = [self.tableview dequeueReusableCellWithIdentifier:@"TotalLikes_Comments" forIndexPath:indexPath];
            
            
            cell.LikeButtonTapAction = ^(TotalLikes_Comments *aCell){
                NSLog(@"Like ButtonClicked");
            };
            
            cell.CommentButtonTapAction = ^(TotalLikes_Comments *aCell){
                NSLog(@"Comment ButtonClicked");
            };
            
            cell.openLikesTapAction = ^(TotalLikes_Comments * aCell){
                NSLog(@"Open Likes ButtonClicked");
            };
            return cell;
            
        }else if ([[arr objectAtIndex:indexPath.row]isEqualToString:@"Buttons"]) {
            
            Buttons *cell = [self.tableview dequeueReusableCellWithIdentifier:@"Buttons" forIndexPath:indexPath];
            
            
            //            __weak typeof(Buttons) *weakSelf = cell;
            
            cell.LikeButtonTapAction = ^(Buttons *aCell){
                NSLog(@"Likes ButtonClicked");
            };
            
            
            cell.CommentButtonTapAction = ^(Buttons *aCell){
                NSLog(@" Comments ButtonClicked");
                
                documentIdForReport = docInfo.id;
                
                [self showReportsOptions];
                
            };
            
            cell.ShareButtonTapAction = ^(Buttons * aCell){
                NSLog(@" Share ButtonClicked");
                
                
                SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:appName andMessage:_notify_Are_you_sure_want_to_download];
                
                [alertView addButtonWithTitle:_static_NO
                                         type:SIAlertViewButtonTypeDefault
                                      handler:^(SIAlertView *alert) {
                                      }];
                [alertView addButtonWithTitle:_static_Download
                                         type:SIAlertViewButtonTypeDestructive
                                      handler:^(SIAlertView *alert) {
                                          
                                          [self showAlertForSaveDocumentInDirectory:indexPath];
                                          
                                      }];
                
                alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
                [alertView show];
                
            };
            
            return cell;
            
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Documents *docInfo = [documentsFeed objectAtIndex:indexPath.section - 1];
    
    
    if ([docInfo.mime_type isEqualToString:@"pdf"]) {
        PreviewForAllDocs *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"PreviewForAllDocs"];
        mainvc.mime_type = docInfo.mime_type;
        mainvc.filePath = [NSString stringWithFormat:@"%@%@",BASE_DOCUMENT_URL,docInfo.filename];
        [self.navigationController pushViewController:mainvc animated:YES];
        
    }else{
        
        NSString *stringPath = [NSString stringWithFormat:@"%@%@",BASE_DOC_VIDEO_URL,docInfo.filename];
        
        NSURL *v_url = [NSURL URLWithString:stringPath];
        AVPlayer *player = [AVPlayer playerWithURL:v_url];
        
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        playerViewController.player = player;
        [playerViewController.player play];//Used to Play On start
        [self presentViewController:playerViewController animated:YES completion:nil];
    }
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *CellIdentifier = @"SectionHeaderOfPost";
    SectionHeaderOfPost *headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (headerView == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    if (section!=0) {
        
        Documents *docInfo = [documentsFeed objectAtIndex:section - 1];
        headerView.titleLabel.text = [NSString stringWithFormat:@"%@ %@",docInfo.Users.firstname,docInfo.Users.lastname];
        
        
        [headerView.profileImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_PROFILE_IMAGE_URL,docInfo.Users.profile_image]] placeholderImage:[UIImage imageNamed:@"noUser"] options:SDWebImageTransformAnimatedImage];
        
        //@"Post Uploaded by User";
        headerView.menuButtonclick = ^(SectionHeaderOfPost *aCell){
            
            UIAlertController * view=   [UIAlertController
                                         alertControllerWithTitle:nil//@"Instagram-Feed"
                                         message:nil
                                         preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:_static_Cancel
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action)
                                 {
                                     NSLog(@" Cancel ButtonClicked");
                                 }];
            //            UIAlertAction* edit = [UIAlertAction
            //                                   actionWithTitle:@"Edit Post"
            //                                   style:UIAlertActionStyleDefault
            //                                   handler:^(UIAlertAction * action)
            //                                   {
            //                                       NSLog(@" Edit ButtonClicked");
            //                                   }];
            UIAlertAction* delete = [UIAlertAction
                                     actionWithTitle:_static_delete_post
                                     style:UIAlertActionStyleDestructive
                                     handler:^(UIAlertAction * action)
                                     {
                                         NSLog(@" Delete ButtonClicked");
                                         
                                         SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:appName andMessage:_notify_Are_you_sure_want_to_delete];
                                         
                                         [alertView addButtonWithTitle:_static_NO
                                                                  type:SIAlertViewButtonTypeDefault
                                                               handler:^(SIAlertView *alert) {
                                                               }];
                                         [alertView addButtonWithTitle:_static_Delete
                                                                  type:SIAlertViewButtonTypeDestructive
                                                               handler:^(SIAlertView *alert) {
                                                                   
                                                                   [self deleteDocumentWithID:[NSString stringWithFormat:@"%d",docInfo.id]];
                                                                   
                                                               }];
                                         
                                         alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
                                         [alertView show];
                                         
                                         
                                         
                                     }];
            
            UIAlertAction* share =    [UIAlertAction
                                       actionWithTitle:_static_share_post
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           NSLog(@" Share ButtonClicked");
                                           
                                           
                                           NSString *textToShare = appName;
                                           NSURL *myWebsite = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_DOCUMENT_URL,docInfo.filename]];
                                           
                                           NSArray *objectsToShare = @[textToShare, myWebsite];
                                           
                                           UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
                                           
                                           [self presentViewController:activityVC animated:YES completion:nil];
                                           
                                       }];
            
            [view addAction:ok];
            
            if (myUserID == docInfo.user_id) {
                //                [view addAction:edit];
                //                [view addAction:remove];
                [view addAction:delete];
            }
            [view addAction:share];
            
            CGPoint windowPoint = [aCell convertPoint:aCell.menuBtn.bounds.origin toView:self.view.window];
            view.popoverPresentationController.sourceView = self.view;
            view.popoverPresentationController.sourceRect = CGRectMake(aCell.menuBtn.frame.origin.x, windowPoint.y+15, aCell.menuBtn.frame.size.width, aCell.menuBtn.frame.size.height);;
            [self presentViewController: view animated:YES completion:nil];
        };
        
        headerView.clickedOnname = ^(SectionHeaderOfPost *aCell){
        };
    }
    
    headerView.layer.borderWidth = 0.5;
    headerView.layer.borderColor= [UIColor lightGrayColor].CGColor;
    
    UIView *view = [[UIView alloc] initWithFrame:[headerView frame]];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [view addSubview:headerView];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return CGFLOAT_MIN;
    }else{
        return 44.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

#pragma mark - UICollectionViewDataSource Methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 15;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SuggestedPeopleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    //cell.titleLabel.text=@"Name";
    // cell.subTitleLabel.text = @"Detail Text";
    cell.layer.cornerRadius=4;
    cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth=0.5;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(140, 150);
}

#pragma mark - UIScrollViewDelegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[UICollectionView class]]) return;
    
    CGFloat horizontalOffset = scrollView.contentOffset.x;
    
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    NSInteger index = collectionView.tag;
    self.contentOffsetDictionary[[@(index) stringValue]] = @(horizontalOffset);
}
#pragma mark- Textview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([trimmedString(textView.text) isEqualToString:_static_Please_enter_docs_desc]) {
        textView.text = @"";
        textView.textColor = theme_Black_Color; //optional
    }
    [textView becomeFirstResponder];
    
//    errorLblDesc.text = nil;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([trimmedString(textView.text) isEqualToString:@""]) {
        textView.text = _static_Please_enter_docs_desc;
        textView.textColor = [UIColor lightGrayColor]; //optional
//        errorLblDesc.text = _static_Please_enter_docs_desc;
    }
    [textView resignFirstResponder];
    
}
- (BOOL)validateTxtFieldReportType
{
    NSError *error = nil;
    if ([self txtFieldReportTypeIsInValid]) {
        error = [Global errorWithLocalizedDescription:_error_Please_select_report_type];
    }
    [lblReportType setError:error animated:YES];
    return !error;
}
- (BOOL)txtFieldReportTypeIsInValid
{
    return trimmedString(lblReportType.text).length == 0;
}
#pragma mark- show Report Options
-(void)showReportsOptions{
    if (arrReportType == nil) {
        arrReportType = [[NSArray alloc] initWithObjects:_static_not_related_to_this_course,_static_contains_advertisement, _static_other,nil];
    }
    
    [reportMainView setHidden:NO];
}

#pragma mark- Save Document in directory
-(void)showAlertForSaveDocumentInDirectory:(NSIndexPath*)indexPath{
    
    Documents *docInfo = [documentsFeed objectAtIndex:indexPath.section - 1];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:appName message:_static_Enter_document_name preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *submit = [UIAlertAction actionWithTitle:_static_Submit style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        if (alert.textFields.count > 0) {
            
            UITextField *textField = [alert.textFields firstObject];
            
            if (trimmedString(textField.text).length) {
                
                [Global ShowHUDwithAnimation:YES];
                
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    NSLog(@"Do some work");
                    NSString *stringPath = [[[SharedClass sharedManager] documentsPath] stringByAppendingPathComponent:@"/Archive Documents"];
                    NSData *pdfData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_DOCUMENT_URL,docInfo.filename]]];
                    
                    BOOL success = false ;
                    
                    if (pdfData.length > 0) {
                        success =  [FCFileManager writeFileAtPath:[stringPath stringByAppendingString:[NSString stringWithFormat:@"/%@_%@",trimmedString(textField.text),docInfo.filename]] content:pdfData];
                    }
                    if (success) {
                        showAlertWithErrorMessage(_success_Successfully_Download_document);
                    }else{
                        showAlertWithErrorMessage(_error_while_documet_save);
                    }
                    [Global HideHUDwithAnimation:YES];
                    
                });
                
                
            }else{
                
                showAlertWithErrorMessage(_error_Please_enter_document_name);
                [self showAlertForSaveDocumentInDirectory:indexPath];
            }
            
        }
    }];
    
    UIAlertAction *close = [UIAlertAction actionWithTitle:_static_Cancel style:UIAlertActionStyleDefault  handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:close];
    [alert addAction:submit];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = _static_document_name; // if needs
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark- API Service
-(void)callWebserviceForGetUploadedDocument{
    [Documents getDocumentsListOfdepartmentcourse:self.departmentcourse_id WithCompletion:^(id responsedict) {
        if (documentsFeed != nil) {
            documentsFeed = nil;
        }
        documentsFeed = [[NSMutableArray alloc] init];
        if (responsedict) {
            
            documentsFeed = [RMMapper mutableArrayOfClass:[Documents class] fromArrayOfDictionary:responsedict];
            
            imgNoRecordFound.hidden = documentsFeed.count;
            [self createFeedCell];
            
            [[SharedClass sharedManager] setIsUploadNewDocument:NO];
        }else{
            if (feedDataArray != nil) {
                feedDataArray = nil;
            }
            feedDataArray = [[NSMutableArray alloc] init];
        }
        [_tableview reloadData];
        [_refreshControl endRefreshing];
    }];
    
}


-(void)deleteDocumentWithID:(NSString*)doc_id{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:doc_id forKey:_param_id];
    [param setValue:[NSString stringWithFormat:@"%d",myUserID] forKey:_param_deleted_by];
    [Documents deleteDocumentWithData:param withCompletion:^(NSDictionary *responsedic) {
        if (responsedic) {
            [self callWebserviceForGetUploadedDocument];
        }
    }];
}

@end
