//
//  DepartmentListCell.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 13/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "DepartmentListCell.h"

@implementation DepartmentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    /**
     Set Font
     */
    self.lblDepartmentName.font = [Font setFont_Regular_Size:16];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDepartmentData:(Collegedepartments*)deptInfo{
    self.lblDepartmentName.text = deptInfo.Departments.department_name;
}
@end
