//
//  UIImage+FixOriantion.h
//  SpeedyScan
//
//  Created by TechnoMac  6 on 19/10/16.
//  Copyright © 2016 TechnoMac  6. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FixOriantion)

+ (UIImage *) fixrotation:(UIImage *)image;

+ (UIImage *)scaleAndRotateImage:(UIImage *)image;

@end
