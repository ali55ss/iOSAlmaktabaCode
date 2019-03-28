//
//  CollegeListCell.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 13/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "CollegeListCell.h"

@implementation CollegeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    /**
     Set Border and Fonts
     */
    
    setCornerRadius(self.collegeLogo.layer, 3, 0.5, [UIColor lightGrayColor], YES);
    
    self.lblCollegeName.font = [Font setFont_Regular_Size:16];
    self.collegeLogo.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setCollegeData:(Colleges*)collegeInfo{
    self.lblCollegeName.text = collegeInfo.college_name;
}
@end
