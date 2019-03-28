//
//  DocsPreviewVC.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 20/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "DocsPreviewVC.h"
#import "Documents.h"
#import "DocsFeedVC.h"

@interface DocsPreviewVC ()

@end

@implementation DocsPreviewVC
#pragma mark- commanInit
-(void)commanInit{
    self.title = _static_Preview;
    
    //      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:_static_Upload style:UIBarButtonItemStylePlain target:self action:@selector(btnUploadPressed)];
    
    /**
     Set Fonts & title
     */
    
    btnUploadNow.titleLabel.font = [Font setFont_Bold_Size:16];
    [btnUploadNow setTitle:_static_Upload_Now forState:UIControlStateNormal];
    /**
     Set Corner radious
     */
    setCornerRadius(btnUploadNow.layer, 3, 0.5, [UIColor lightGrayColor], NO);
    
}
#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self commanInit];
    
    
    
    fileURL = [NSURL URLWithString:self.filePath];
    
    if (self.file_type == 1 || self.file_type == 3) {
        btnUploadNow.enabled = NO;
        btnUploadNow.alpha = 0.5;
        
        if (self.file_type == 1) {
            fileData = [NSData dataWithContentsOfFile:self.filePath];
        }else{
            fileData = [NSData dataWithContentsOfURL:fileURL];
        }
        
        CGPDFDocumentRef pdfDocumentRef = CGPDFDocumentCreateWithURL((CFURLRef)fileURL);
        CGPDFPageRef pdfPageRef = CGPDFDocumentGetPage(pdfDocumentRef, 1);
        
        CGRect pdfPageRect = CGPDFPageGetBoxRect(pdfPageRef, kCGPDFMediaBox);
        float width = pdfPageRect.size.width;
        float height = pdfPageRect.size.height;
        documentPageSize = CGSizeMake(width, height);
        
        NSLog(@"documentPageSize : %@", NSStringFromCGSize(documentPageSize));
        
        
        if (fileData.length) {
            btnUploadNow.enabled = YES;
            btnUploadNow.alpha = 1.0;
        }
        
        NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
        _webview.delegate = self;
        [_webview loadRequest:request];
        
    }else if (self.file_type == 2){
        
        [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.filePath]]];
        _webview.scrollView.bounces = NO;
        _webview.delegate = self;
        [_webview setMediaPlaybackRequiresUserAction:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Webview Delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [Global HideHUDwithAnimation:YES];
    NSLog(@"finish");
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [Global HideHUDwithAnimation:YES];
    
    NSLog(@"Error for WEBVIEW: %@", [error description]);
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"Loading URL :%@",request.URL.absoluteString);
    
    [Global ShowHUDwithAnimation:YES];
    
    //return FALSE; //to stop loading
    return YES;
}
#pragma mark- Create Pdf File from webview
-(void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    
//    [Global showProgressHUD];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        // Main thread work (UI usually)
        
        @autoreleasepool {
            
            NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"PDFFiles"];
            NSString *pdfFileName = [stringPath stringByAppendingPathComponent:aFilename];
            
            
            self.PDFCreator = [NDHTMLtoPDF createPDFWithURL:fileURL pathForPDF:pdfFileName pageSize:documentPageSize margins:UIEdgeInsetsMake(10, 5, 10, 5) successBlock:^(NDHTMLtoPDF *htmlToPDF) {
                
                NSString *result = [NSString stringWithFormat:@"HTMLtoPDF did succeed (%@ / %@)", htmlToPDF, htmlToPDF.PDFpath];
                NSLog(@"%@",result);
                
                PDFDocument *thumbImage = [[PDFDocument alloc] initWithURL:[NSURL fileURLWithPath:htmlToPDF.PDFpath]];
                
                _imgFrontImage = [thumbImage imageForPage:1 size:documentPageSize];
                
                fileData = [NSData dataWithContentsOfFile:htmlToPDF.PDFpath];
                
                [self prepareAndUploadDocument];
                
                [Global showProgressHUDWithSuccess];
                
            } errorBlock:^(NDHTMLtoPDF *htmlToPDF) {
                NSString *result = [NSString stringWithFormat:@"HTMLtoPDF did fail (%@)", htmlToPDF];
                NSLog(@"%@",result);
                
                showAlertWithErrorMessage(result);
            }];
        }
    }];
}

#pragma mark- Action Methods
- (IBAction)clk_btnUploadNow:(id)sender {
    [self notifyForUploadDocument];
}
-(void)notifyForUploadDocument{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:appName andMessage:_notify_Are_you_sure_want_to_upload];
    
    [alertView addButtonWithTitle:_static_NO
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                          }];
    [alertView addButtonWithTitle:_static_Upload
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              
                              if(self.file_type == 1){
                                  [self prepareAndUploadDocument];
                              }else if(self.file_type == 2){
                                  [self prepareVideoFromFilePath];
                              }else if(self.file_type == 3){
                                  if (self.is_needtoconvert_pdf) {
                                      [self createPDFfromUIView:_webview saveToDocumentsWithFileName:[SharedClass generateFilePathNameWithDefualtNmae:@"Doc"]];
                                  }else{
                                      PDFDocument *thumbImage = [[PDFDocument alloc] initWithURL:fileURL];
                                      
                                      _imgFrontImage = [thumbImage imageForPage:1 size:documentPageSize];
                                      [self prepareAndUploadDocument];
                                  }
                                  
                              }
                          }];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    [alertView show];
}

-(void)prepareVideoFromFilePath{
    
    [Global clearVideoCache];
    
    _imgFrontImage = [Global generateThumbImage:[NSURL URLWithString:self.filePath]];
    
    NSURL* uploadURL = [NSURL fileURLWithPath:
                        [NSTemporaryDirectory() stringByAppendingPathComponent:@"temporaryPreview.mov"]];
    
    
    [Global compressVideo:[NSURL URLWithString:self.filePath] outputURL:uploadURL handler:^(AVAssetExportSession *completion) {
        if (completion.status == AVAssetExportSessionStatusCompleted) {
            fileData = [NSData dataWithContentsOfURL:uploadURL];
            
            if (((fileData.length/1024)/1024) > 50) {
                showAlertWithErrorMessage(_error_video_file_size_greter_50mb);
            }else{
                _mime_type = @"mov";
                [self prepareAndUploadDocument];
            }
        }
    }];
}
-(void)prepareAndUploadDocument{
    if (((fileData.length/1024)/1024) > 25)  {
        showAlertWithErrorMessage(_error_document_file_size_greter_25mb);
    }else{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            @autoreleasepool {
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                
                [Documents uploadDocumentFrontPageWithData:UIImageJPEGRepresentation(self.imgFrontImage, 0) withMime_type:@"jpg" withCompletion:^(NSString *_fileName) {
                    
                    [params setValue:_fileName forKey:_param_front_image];
                    
                    if (_fileName) {
                        [Documents uploadDocumentWithData:fileData withMime_type:_mime_type withCompletion:^(NSString *_fileName) {
                            if (_fileName) {
                                
                                [params setValue:_fileName forKey:_param_filename];
                                [self saveDocumentDetails:params];
                            }
                        }];
                    }
                    
                }];
            }
        }];
    }
}

-(void)saveDocumentDetails:(NSMutableDictionary*)_params{
    
    [_params setValue:[[SharedClass sharedManager] deptCourse_id] forKey:_param_departmentcourse_id];
    [_params setValue:[[Global objectFromDataWithKey:_static_USER_INFO] valueForKey:_param_id] forKey:_param_user_id];
    [_params setValue:[[SharedClass sharedManager] documentTitle] forKey:_param_title];
    [_params setValue:[[SharedClass sharedManager] documentDescription] forKey:_param_description];
    [_params setValue:_mime_type forKey:_param_mime_type];
    
    [Documents saveDocumentDetailsWithData:_params withCompletion:^(NSDictionary *responsedic) {
        
        [[SharedClass sharedManager] setIsUploadNewDocument:YES];
        for (UIViewController *viewC in self.navigationController.viewControllers) {
            
            if ([viewC isKindOfClass:[DocsFeedVC class]]) {
                
                [self.navigationController popToViewController:viewC animated:YES];
            }
        }
    }];
}

@end
