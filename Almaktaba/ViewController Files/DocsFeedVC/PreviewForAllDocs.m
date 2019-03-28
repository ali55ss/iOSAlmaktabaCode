//
//  PreviewForAllDocs.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 27/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "PreviewForAllDocs.h"

@interface PreviewForAllDocs ()

@end

@implementation PreviewForAllDocs

#pragma mark- Comman Init
-(void)commanInit{
    self.title = _static_Preview;
    
    
}
#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self commanInit];
    [self configWebview];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- config Webview
-(void)configWebview{
    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.filePath] cachePolicy:NSURLRequestUseProtocolCachePolicy   timeoutInterval:60.0];
//
//    if ([userDefaults objectForKey:userdefaultAuthHeader]) {
//        NSLog(@"%@",[userDefaults objectForKey:userdefaultAuthHeader]);
//        [request setValue:[userDefaults objectForKey:userdefaultAuthHeader] forHTTPHeaderField:@"Authorization"];
//    }
//    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setHTTPMethod:@"POST"];
    
    NSLog(@"%@",[NSURL URLWithString:self.filePath]);
    [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.filePath]]];
    _webview.delegate = self;
    
    if ([self.mime_type isEqualToString:@"mov"]) {
        _webview.scrollView.bounces = NO;
        [_webview setMediaPlaybackRequiresUserAction:NO];
    }
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




@end
