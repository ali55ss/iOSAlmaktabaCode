//
//  UIView+Frame.h
//  DigitalEMS
//
//  Created by TechnoMac-11 on 17/11/17.
//  Copyright © 2017 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)
@property (nonatomic, assign) float width;
@property (nonatomic, assign) float height;
@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
- (void) removeSubviews;
- (void) removeSubviewsRecursively;
- (void) removeSubviewsOfClass:(Class)cls;
@end
