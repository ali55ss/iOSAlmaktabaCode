//
//  SectionHeaderOfPost.m
//  Traweller
//
//  Created by Sagar Shirbhate on 8/9/16.
//  Copyright © 2016 Sagar Shirbhate. All rights reserved.
//

#import "SectionHeaderOfPost.h"



@implementation SectionHeaderOfPost

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _profileImage.layer.cornerRadius = 19;
   
    _profileImage.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapRecognizerq = [[UITapGestureRecognizer alloc] init];
    [tapRecognizerq addTarget:self action:@selector(clickedmage:)];
    [_profileImage addGestureRecognizer:tapRecognizerq];
    
    if([userDefaults boolForKey:_static_IS_LOGEDIN_AS_GUEST]){
        self.menuBtn.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)menuButtonclick:(id)sender {
    if (self.menuButtonclick) {
        self.menuButtonclick(self);
    }
}

- (IBAction)clickedOnname:(id)sender {
    if (self.clickedOnname) {
        self.clickedOnname(self);
    }
}

-(void)clickedmage:(UITapGestureRecognizer *)sender {
    
    if (self.clickedOnname) {
        self.clickedOnname(self);
    }
    
}
@end
