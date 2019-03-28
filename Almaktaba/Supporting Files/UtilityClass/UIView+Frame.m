//
//  UIView+Frame.m
//  DigitalEMS
//
//  Created by TechnoMac-11 on 17/11/17.
//  Copyright © 2017 TechnoMac-11. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
- (float)height{
    return self.frame.size.height;
}

- (float)width{
    return self.frame.size.width;
}

- (float)x{
    return self.frame.origin.x;
}

- (float)y{
    return self.frame.origin.y;
}

- (CGSize)size{
    return self.frame.size;
}

- (CGPoint)origin{
    return self.frame.origin;
}

- (void)setWidth:(float)width{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (void)setHeight:(float)height{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (void)setX:(float)x{
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setY:(float)y{
    self.frame = CGRectMake(self.frame.origin.x, y,  self.frame.size.width, self.frame.size.height);
}

- (void)setSize:(CGSize)size{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}

- (void)setOrigin:(CGPoint)origin{
    self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)removeSubviewsOfClass:(Class)cls{
    for (UIView * sub in [self subviews]){
        if ([sub isKindOfClass:cls])
            [sub removeFromSuperview];
    }
}

- (void)removeSubviewsRecursively{
    for (UIView * sub in [self subviews]){
        [sub removeSubviewsRecursively];
        [sub removeFromSuperview];
    }
}

- (void) removeSubviews{
    for (UIView *subView in self.subviews){
        [subView removeFromSuperview];
    }
}

@end
