//
//  LoginNavControll.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 07/03/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "LoginNavControll.h"

@interface LoginNavControll ()

@end

@implementation LoginNavControll


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: theme_Blue_Color,NSFontAttributeName:[Font setFont_Bold_Size:18]};
    
    self.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationBar setBottomBorderColor:[UIColor whiteColor] height:1];
    
    [self.navigationBar setTintColor:theme_Blue_Color];
    
    NSDictionary *barButtonAppearanceDict = @{NSFontAttributeName : [Font setFont_SemiBold_Size:18], NSForegroundColorAttributeName: theme_Blue_Color};
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];
    
    
    //    [[UIBarButtonItem appearance] setTintColor:theme_Blue_Color];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

#pragma mark-
@implementation UINavigationBar (Helper)

- (void)setBottomBorderColor:(UIColor *)color height:(CGFloat)height {
    CGRect bottomBorderRect = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), height);
    UIView *bottomBorder = [[UIView alloc] initWithFrame:bottomBorderRect];
    [bottomBorder setBackgroundColor:color];
    [self addSubview:bottomBorder];
}

@end
