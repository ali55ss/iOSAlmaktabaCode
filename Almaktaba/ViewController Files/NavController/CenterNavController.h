//
//  CenterNavController.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 12/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterNavController : UINavigationController <GADBannerViewDelegate>

@property(nonatomic, strong) GADBannerView *bannerView;

@end
@interface UINavigationBar (Helper)
- (void)setBottomBorderColor:(UIColor *)color height:(CGFloat)height;
@end
