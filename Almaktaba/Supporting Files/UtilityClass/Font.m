//
//  Font.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 12/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "Font.h"

@implementation Font
+ (UIFont *)setFont_Bold_Size:(CGFloat)fSize{
    return [UIFont fontWithName:@"Montserrat-SemiBold" size:fSize];
}
+ (UIFont *)setFont_SemiBold_Size:(CGFloat)fSize{
    return [UIFont fontWithName:@"Montserrat-Medium" size:fSize];
}
+ (UIFont *)setFont_Regular_Size:(CGFloat)fSize{
    return [UIFont fontWithName:@"Raleway-Medium" size:fSize];
}
+ (UIFont *)setFont_Medium_Size:(CGFloat)fSize{
    return [UIFont fontWithName:@"Montserrat" size:fSize];
}


@end
