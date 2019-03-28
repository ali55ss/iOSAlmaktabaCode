//
//  PreviewForAllDocs.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 27/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewForAllDocs : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@property(strong, nonatomic)NSString *filePath;
@property (strong, nonatomic) NSString *mime_type;

@end
