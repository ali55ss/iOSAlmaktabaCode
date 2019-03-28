//
//  DocsPreviewVC.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 20/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocsPreviewVC : UIViewController <UIWebViewDelegate, NDHTMLtoPDFDelegate>
{
    NSData *fileData;
    NSURL *fileURL;
    __weak IBOutlet UIButton *btnUploadNow;
    
    CGSize documentPageSize;
    
}
@property (weak, nonatomic) IBOutlet UIWebView *webview;

- (IBAction)clk_btnUploadNow:(id)sender;

@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSString *mime_type;

//@property (strong, nonatomic) NSURL *videoURL;

@property (assign) int file_type; // 1 - pdf, 2 - video, 3 - for documents

@property (assign) BOOL is_needtoconvert_pdf; 

/*!
 * @brief Get Front Image which is useful on display document feed
*/
@property (strong,nonatomic)UIImage *imgFrontImage;


/**
 Create Pdf File from webview
 */
@property (nonatomic, strong) NDHTMLtoPDF *PDFCreator;


@end
