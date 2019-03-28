//
//  UploadDocsVC.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 14/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "UploadDocsVC.h"
#import "FilterVC.h"
#import "DocsPreviewVC.h"
#import "CourseVC.h"
#import "Documents.h"
#import "DocsFeedVC.h"


@interface UploadDocsVC () <TODocumentPickerViewControllerDelegate>

@end

@implementation UploadDocsVC

#pragma mark- CommanInit
-(void)commanInit{
    
    self.title = _static_Upload_Docs;
    /**
     Set Fonts
     */
    
    txtCourseCode.font = [Font setFont_Regular_Size:16];
    txtCourseName.font = [Font setFont_Regular_Size:16];
    txtDocsTitle.font = [Font setFont_Regular_Size:16];
    txtDocsDescription.font = [Font setFont_Regular_Size:16];
    
    btnUploadDocs.titleLabel.font = [Font setFont_Bold_Size:16];
    [btnUploadDocs setTitle:_static_CHOOSE_YOUR_DOCS forState:UIControlStateNormal];
    
    /**
     Set Corner radious
     */
    setCornerRadius(btnUploadDocs.layer, 3, 0.5, [UIColor lightGrayColor], NO);
    
    
    /**
     Configure Textfields
     */
    txtCourseCode.tintColor = theme_Gray_Color;
    txtCourseCode.textColor = theme_Black_Color;
    txtCourseCode.defaultPlaceholderColor = theme_Gray_Color;
    txtCourseCode.placeholderAnimatesOnFocus = YES;
    txtCourseCode.placeholder = _static_Code;
    
    txtCourseName.tintColor = theme_Gray_Color;
    txtCourseName.textColor = theme_Black_Color;
    txtCourseName.defaultPlaceholderColor = theme_Gray_Color;
    txtCourseName.placeholderAnimatesOnFocus = YES;
    txtCourseName.placeholder = _static_Courses_Name
    
    txtDocsTitle.tintColor = theme_Gray_Color;
    txtDocsTitle.textColor = theme_Black_Color;
    txtDocsTitle.defaultPlaceholderColor = theme_Gray_Color;
    txtDocsTitle.placeholderAnimatesOnFocus = YES;
    txtDocsTitle.placeholder = _static_Docs_title;
    
    txtDocsDescription.delegate = self;
    txtDocsDescription.text = _static_Please_enter_docs_desc;
    txtDocsDescription.textColor = [UIColor lightGrayColor]; //optional
    
    errorLblDesc.font = [Font setFont_Medium_Size:12];
    errorLblDesc.textColor = theme_Red_Color;
    
    
    
    /**
     Default extentiom of documents
     */
    
    // Jpg,jpeg,gif,png,pdf,mov,mp4,avi,3gp,mkv,doc,docx,xls,xlsx,ppt,txt,m4v
    
    arrImgsExt = [[NSArray alloc] initWithObjects:@".jpg",@".jpeg",@".gif" ,@".png",nil];
    arrDocsExt = [[NSArray alloc] initWithObjects:@".doc",@".docx",@".xls" ,@".xlsx" ,@".ppt" ,@".txt",@".pdf",nil];
    arrVideosExt = [[NSArray alloc] initWithObjects:@".mov",@".mp4",@".avi" ,@".3gp" ,@".mkv" ,@".m4v" ,nil];
    
    
    /**
     Set course code and value
     */
    

    txtCourseCode.text = [NSString stringWithFormat:@"%d",self.course_code];
    txtCourseName.text = self.course_name;
     [[SharedClass sharedManager] setDeptCourse_id:[NSString stringWithFormat:@"%d",self.departmentcourse_id]];
}

#pragma mark- Action Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commanInit];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //    double delayInSeconds = 1.0;
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    //    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    //        // do something
    //        txtCourseName.enabled = YES;
    //        txtCourseCode.enabled = YES;
    //    });
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Action Methods
- (IBAction)clk_SelectCourse:(id)sender {
    
    
//    CourseVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"CourseVC"];
//    mainvc.collegedepartment_id = self.collegedepartment_id;
//    mainvc.isOpenFromUploadDocs = YES;
//    [self.navigationController pushViewController:mainvc animated:YES];
//
//    [mainvc notifySelectedCourse:^(int course_code, NSString *course_name, int departmentcourse_id) {
//
//        txtCourseCode.text = [NSString stringWithFormat:@"%d",course_code];
//        txtCourseName.text = course_name;
//
//        [self validateTxtFieldCourseCode];
//        [self validateTxtFieldCourseName];
//
//        [[SharedClass sharedManager] setDeptCourse_id:[NSString stringWithFormat:@"%d",departmentcourse_id]];
//
//    }];
}
- (IBAction)clk_btnUploadDocs:(id)sender {
    if ([self isvalidForUploadDocuments])
    {
        if (trimmedString(txtDocsDescription.text).length && ![trimmedString(txtDocsDescription.text) isEqualToString:_static_Please_enter_docs_desc]) {
            [[SharedClass sharedManager] setDocumentDescription:txtDocsDescription.text];
        }
        if (trimmedString(txtDocsTitle.text).length) {
            [[SharedClass sharedManager] setDocumentTitle:txtDocsTitle.text];
        }
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:nil
                                     message:nil
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        UIAlertAction* Camera = [UIAlertAction
                                 actionWithTitle:_static_Scan_Documents
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     //                                 IRLScannerViewController *scanner = [IRLScannerViewController standardCameraViewWithDelegate:self];
                                     //                                 scanner.showControls = YES;
                                     //                                 scanner.showAutoFocusWhiteRectangle = YES;
                                     //                                 [scanner setDetectionOverlayColor:[UIColor blueColor]];
                                     //                                 [self presentViewController:scanner animated:YES completion:nil];
                                     
                                     
                                     [[[SharedClass sharedManager] arrMultiPages]removeAllObjects];
                                     [[SharedClass sharedManager]setFolderId:0];
                                     [[SharedClass sharedManager]setIsDocAddNewPage:NO];
                                     IRLScannerViewController *scanner = [IRLScannerViewController cameraViewWithDefaultType:IRLScannerViewTypeNormal defaultDetectorType:IRLScannerDetectorTypeAccuracy withDelegate:self];
                                     scanner.showControls = YES;
                                     scanner.showAutoFocusWhiteRectangle = YES;
                                     [[SharedClass sharedManager]setIsAutometicCapture:YES];
                                     [self.navigationController pushViewController:scanner animated:YES];
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        UIAlertAction* Photos = [UIAlertAction
                                 actionWithTitle:_static_Photos
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                     /*[[SharedClass sharedManager]setFolderId:0];
                                      
                                      [[SharedClass sharedManager]setIsDocAddNewPage:NO];
                                      */
                                     /*GMImagePickerController *picker = [[GMImagePickerController alloc] init];
                                      picker.delegate = self;
                                      picker.title = _static_Photos;
                                      
                                      picker.customDoneButtonTitle = _static_Done;
                                      picker.customCancelButtonTitle = _static_Close;
                                      
                                      picker.colsInPortrait = 3;
                                      picker.colsInLandscape = 5;
                                      picker.minimumInteritemSpacing = 2.0;
                                      
                                      picker.modalPresentationStyle = UIModalPresentationPopover;
                                      
                                      picker.mediaTypes = @[@(PHAssetMediaTypeImage)];
                                      
                                      [self presentViewController:picker animated:YES completion:^{
                                      
                                      }];*/
                                     
                                     
                                     
                                     // new code
                                     
                                     GMImagePickerController *picker = [[GMImagePickerController alloc] init];
                                     picker.delegate = self;
                                     //Select the media types you want to show and filter out the rest
                                     picker.mediaTypes = @[@(PHAssetMediaTypeImage)];
                                     picker.title = _static_Photos;
                                     picker.customDoneButtonTitle = _static_Done;
                                     picker.customCancelButtonTitle = _static_Cancel;
                                    
                                     picker.customNavigationBarPrompt = _static_ChooseYourDocumentPhotos;
                                     [self presentViewController:picker animated:YES completion:nil];
                                     
                                 }];
        
        UIAlertAction* Videos = [UIAlertAction
                                 actionWithTitle:_static_Videos
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                     PresentVideoLibrary(self, YES);
                                     
                                 }];
        UIAlertAction* BrowseDocs = [UIAlertAction
                                     actionWithTitle:_static_BrowsDocs
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         
                                         
                                         [self browseDocumentForomLocalDisk];
                                         
                                     }];
        
        UIAlertAction* Cancel = [UIAlertAction
                                 actionWithTitle:_static_Cancel
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [Camera setValue:[[UIImage imageNamed:@"cameramain"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
        [Videos setValue:[[UIImage imageNamed:@"cameramain"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
        [Photos setValue:[[UIImage imageNamed:@"gallerymain"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
        [BrowseDocs setValue:[[UIImage imageNamed:@"gallerymain"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
        
        [view addAction:Camera];
        [view addAction:Videos];
        [view addAction:Photos];
        
        if (@available(iOS 11.0, *)) {
            [view addAction:BrowseDocs];
        }
        [view addAction:Cancel];
        
        [self presentViewController:view animated:YES completion:nil];
    }
}


#pragma mark- Validations


- (IBAction)textFieldDidEndEditing:(UITextField *)sender {
    //    [btnUploadDocs sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self isvalidForUploadDocuments];
}

- (IBAction)clk_txtFieldSelectCourseName:(id)sender {
}


- (IBAction)textFieldDidBegin:(UITextField *)sender {
    
    if (sender == txtCourseName || sender == txtCourseCode ) {
        
        [txtCourseName setError:nil animated:YES];
        [txtCourseCode setError:nil animated:YES];
    }
    
    if (sender == txtDocsTitle) {
        [txtDocsTitle setError:nil animated:YES];
    }
}

#pragma mark - Text field validation

-(BOOL)isvalidForUploadDocuments{
    if ([self validateTxtFieldCourseCode] && [self validateTxtFieldCourseName] && [self validateTxtFieldDocumentTitle]) {
        if (trimmedString(txtDocsDescription.text).length && [trimmedString(txtDocsDescription.text) isEqualToString:_static_Please_enter_docs_desc]){
            errorLblDesc.text = _static_Please_enter_docs_desc;
            return NO;
        }else{
            errorLblDesc.text = nil;
            return YES;
        }
    }
    return NO;
}
- (BOOL)validateTxtFieldCourseName
{
    NSError *error = nil;
    if ([self txtFieldCourseNameIsInValid]) {
        error = [Global errorWithLocalizedDescription:_static_Please_enter_course_name];
    }
    [txtCourseName setError:error animated:YES];
    return !error;
}
- (BOOL)validateTxtFieldCourseCode
{
    NSError *error = nil;
    if ([self txtFieldCourseCodeIsInValid]) {
        error = [Global errorWithLocalizedDescription:_static_Required];
    }
    [txtCourseCode setError:error animated:YES];
    return !error;
}
- (BOOL)validateTxtFieldDocumentTitle
{
    NSError *error = nil;
    if ([self txtFieldCourseDocumentTitleIsInValid]) {
        error = [Global errorWithLocalizedDescription:_static_Please_enter_docs_title];
    }
    [txtDocsTitle setError:error animated:YES];
    return !error;
}
- (BOOL)txtFieldCourseNameIsInValid
{
    return trimmedString(txtCourseName.text).length == 0;
}
- (BOOL)txtFieldCourseCodeIsInValid
{
    return trimmedString(txtCourseCode.text).length == 0;
}
- (BOOL)txtFieldCourseDocumentTitleIsInValid
{
    return trimmedString(txtDocsTitle.text).length == 0;
}


#pragma mark- UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    [picker dismissViewControllerAnimated:NO completion:^{
        [self notifyForUploadVideo:info[UIImagePickerControllerMediaURL]];
    }];
    
}
#pragma mark- Textview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([trimmedString(textView.text) isEqualToString:_static_Please_enter_docs_desc]) {
        textView.text = @"";
        textView.textColor = theme_Black_Color; //optional
    }
    [textView becomeFirstResponder];
    
    errorLblDesc.text = nil;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([trimmedString(textView.text) isEqualToString:@""]) {
        textView.text = _static_Please_enter_docs_desc;
        textView.textColor = [UIColor lightGrayColor]; //optional
        errorLblDesc.text = _static_Please_enter_docs_desc;
    }
    [textView resignFirstResponder];
    
}

#pragma mark - IRLScannerViewControllerDelegate

-(void)pageSnapped:(UIImage *)page_image from:(UIViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:^{
        //        [self.scannedImage setImage:page_image];
        
    }];
}

-(void)didCancelIRLScannerViewController:(IRLScannerViewController *)cameraView {
    [cameraView dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - GMImagePickerControllerDelegate

- (void)assetsPickerController:(GMImagePickerController *)picker didFinishPickingAssets:(NSArray *)assetArray
{
    @try {
        
        __block NSString *strHUDMsg = [NSString stringWithFormat:_loader_Loading_Images];
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            
//            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
//            [SVProgressHUD setBackgroundColor:svProgreesHUDColor];
//            [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
//            [SVProgressHUD showWithStatus:strHUDMsg];
            [Global ShowHUDwithAnimation:YES];
            
            self.requestOptions = [[PHImageRequestOptions alloc] init];
            self.requestOptions.resizeMode   = PHImageRequestOptionsResizeModeNone;
            self.requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            
            // this one is key
            self.requestOptions.synchronous = true;
            
            
            CGFloat height = 0,weidth = 0;
            if ([@"A4" isEqualToString:@"A4"])
            {
                height = 612;
                weidth = 792;
            }
            
            [[[SharedClass sharedManager] arrMultiPages]removeAllObjects];
            
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                
                // UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectMake(0, 0, weidth, height), nil);
                PHContentEditingInputRequestOptions *option = [[PHContentEditingInputRequestOptions alloc]init];
                [option setCanHandleAdjustmentData:^BOOL(PHAdjustmentData * _Nonnull PHdata) {
                    return YES;
                }];
                for(PHAsset *asset in assetArray) {
                    
                    @autoreleasepool {
                        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:[self requestOptions] resultHandler:^(UIImage *image, NSDictionary *info) {
                            
                            NSData *imageData = UIImageJPEGRepresentation(image, compressQuality);
                            
                            [[[SharedClass sharedManager]arrMultiPages]addObject:[UIImage imageWithData:imageData]];
                        }];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
//                    [SVProgressHUD dismiss];
                    
                    [Global HideHUDwithAnimation:YES];
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                    }];
                    
                    FilterVC *filterVC = (FilterVC *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"FilterVC"];
                    [self.navigationController pushViewController:filterVC animated:YES];
                });
            }];
        }];
        
        NSLog(@"GMImagePicker: User ended picking assets. Number of selected items is: %lu", (unsigned long)assetArray.count);
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}



#pragma mark- Browse Doc
-(void)iCloudDriveFullFolder{
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.data"]
                                                                                                            inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:documentPicker animated:NO completion:^{
        //        if (@available(iOS 11.0, *)) {
        //            documentPicker.allowsMultipleSelection = YES;
        //        } else {
        //            // Fallback on earlier versions
        //        }
    }];
    
    //    [self presentViewController:documentPicker animated:YES completion:nil];
}



#pragma mark - iCloud files
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)urls {
    
    
    if (controller.documentPickerMode == UIDocumentPickerModeImport) {
        NSString *alertMessage = [NSString stringWithFormat:@"%@ %@",_static_successful_imported,[urls lastPathComponent]];
        NSLog(@"%@",alertMessage);
        
        
        NSDictionary * properties = [[NSFileManager defaultManager] attributesOfItemAtPath:[urls path] error:nil];
        NSNumber * size = [properties objectForKey: NSFileSize];
        
        NSInteger filesize = ([size integerValue]/1024)/1024;
        //        unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:[urls path] error:nil] fileSize];
        NSLog(@"fileSize :%ld",filesize);
        
        //        NSError* error;
        //        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[url path] error: &error];
        //        NSNumber *size = [fileDictionary objectForKey:NSFileSize];
        //        NSLog(@"File Size :%@",size);
        //
        //
        
        //do stuff
        
        // Jpg,jpeg,gif,png,pdf,mov,mp4,avi,3gp,mkv,doc,docx,xls,xlsx,ppt,txt,m4v
        
        if ([Global array:arrImgsExt containsSubstring:[[[urls lastPathComponent] componentsSeparatedByString:@"."] lastObject]]) {
            NSLog(@"%@",[urls lastPathComponent]);
            
            [[[SharedClass sharedManager] arrMultiPages]removeAllObjects];
            [[SharedClass sharedManager]setFolderId:0];
            [[SharedClass sharedManager]setIsDocAddNewPage:NO];
            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:urls]];
            
            //        [UIImage imageWithData:[NSData dataWithContentsOfURL:url] scale:compressQuality]
            if (image) {
                NSData *imageData = UIImageJPEGRepresentation(image, compressQuality);
                [[[SharedClass sharedManager]arrMultiPages]addObject:[UIImage imageWithData:imageData]];
                FilterVC *filterVC = (FilterVC *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"FilterVC"];
                [self.navigationController pushViewController:filterVC animated:YES];
            }
        }else if([Global array:arrDocsExt containsSubstring:[[[urls lastPathComponent] componentsSeparatedByString:@"."] lastObject]]){
            
            if (filesize > 25) {
                showAlertWithErrorMessage(_error_document_file_size_greter_25mb);
            }else{
                DocsPreviewVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"DocsPreviewVC"];
                mainvc.filePath = [NSString stringWithFormat:@"%@",urls];
                mainvc.file_type = 3;
                mainvc.mime_type = @"pdf";
                mainvc.is_needtoconvert_pdf = YES;
                if ([[urls lastPathComponent] containsString:@".pdf"]) {
                    mainvc.is_needtoconvert_pdf = NO;
                }
                [self.navigationController pushViewController:mainvc animated:YES];
            }
        }else if([Global array:arrVideosExt containsSubstring:[[[urls lastPathComponent] componentsSeparatedByString:@"."] lastObject]]){
            
            if (filesize > 50) {
                showAlertWithErrorMessage(_error_video_file_size_greter_50mb);
            }else{
                DocsPreviewVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"DocsPreviewVC"];
                mainvc.filePath = [NSString stringWithFormat:@"%@",urls];
                mainvc.file_type = 2;
                mainvc.mime_type = @"mov";
                [self.navigationController pushViewController:mainvc animated:YES];
            }
            
        }else{
            showAlertWithErrorMessage(_error_file_type_not_supported);
        }
    }
}

- (void)browseDocumentForomLocalDisk
{
    [self iCloudDriveFullFolder];
    //    return;
    //
    //    NSLog(@"%@",[self documentsPath]);
    //    TODocumentPickerViewController *documentPicker = [[TODocumentPickerViewController alloc] initWithFilePath:[self documentsPath]];
    //    documentPicker.dataSource = [[TODocumentPickerLocalDiskDataSource alloc] init];
    //    documentPicker.documentPickerDelegate = self;
    //
    //    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:documentPicker];
    //    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    //
    //    [self presentViewController:controller animated:YES completion:nil];
}
- (NSString *)documentsPath
{
    static NSString *sharedDocumentsDirectoryPath = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedDocumentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    });
    return sharedDocumentsDirectoryPath;
}
- (void)documentPickerViewController:(TODocumentPickerViewController *)documentPicker didSelectItems:(nonnull NSArray<TODocumentPickerItem *> *)items inFilePath:(NSString *)filePath
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *absoluteItemPaths = [NSMutableArray array];
    for (TODocumentPickerItem *item in items) {
        NSString *absoluteFilePath = [filePath stringByAppendingPathComponent:item.fileName];
        [absoluteItemPaths addObject:absoluteFilePath];
    }
    
    NSLog(@"Paths for items selected: %@", absoluteItemPaths);
}


#pragma mark- generate pdf file

#pragma mark- API Service
-(void)notifyForUploadVideo:(NSURL*)_videoURL{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:appName andMessage:_notify_Are_you_sure_want_to_upload];
    
    [alertView addButtonWithTitle:_static_NO
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                          }];
    [alertView addButtonWithTitle:_static_Upload
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              [self prepareAndUploadVideo:_videoURL];
                          }];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    [alertView show];
}


-(void)prepareAndUploadVideo:(NSURL*)_videoURL{
    [Global clearVideoCache];
    
    NSURL* uploadURL = [NSURL fileURLWithPath:
                        [NSTemporaryDirectory() stringByAppendingPathComponent:@"temporaryPreview.mov"]];
    
//    [Global showProgressHUD];
    [Global compressVideo:_videoURL outputURL:uploadURL handler:^(AVAssetExportSession *completion) {
        if (completion.status == AVAssetExportSessionStatusCompleted) {
            //                NSLog(@"Size of new Video after compression is (bytes):%d",[newDataForUpload length]);
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            
            [Documents uploadDocumentFrontPageWithData:UIImageJPEGRepresentation([Global generateThumbImage:_videoURL], 0) withMime_type:@"jpg" withCompletion:^(NSString *_fileName) {
                
                [params setValue:_fileName forKey:_param_front_image];
                
                if (_fileName) {
                    [Documents uploadDocumentWithData:[NSData dataWithContentsOfURL:uploadURL] withMime_type:@"mov" withCompletion:^(NSString *_fileName) {
                        if (_fileName) {
                            [params setValue:_fileName forKey:_param_filename];
                            [self saveDocumentDetails:params];
                        }
                    }];
                }
            }];
        }
//        [Global dismissProgressHUD];
    }];
}
-(void)saveDocumentDetails:(NSMutableDictionary*)_params{
    
    [_params setValue:[[SharedClass sharedManager] deptCourse_id] forKey:_param_departmentcourse_id];
    
    [_params setValue:[[Global objectFromDataWithKey:_static_USER_INFO] valueForKey:_param_id] forKey:_param_user_id];
    [_params setValue:[[SharedClass sharedManager] documentTitle] forKey:_param_title];
    [_params setValue:[[SharedClass sharedManager] documentDescription] forKey:_param_description];
    [_params setValue:@"mov" forKey:_param_mime_type];
    
    [Documents saveDocumentDetailsWithData:_params withCompletion:^(NSDictionary *responsedic) {
        if (responsedic) {
            [[SharedClass sharedManager] setIsUploadNewDocument:YES];
            
            for (UIViewController *viewC in self.navigationController.viewControllers) {
                
                if ([viewC isKindOfClass:[DocsFeedVC class]]) {
                    
                    [self.navigationController popToViewController:viewC animated:YES];
                }
            }
            //            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
