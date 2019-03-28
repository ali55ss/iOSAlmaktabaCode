//
//  CourseListVC.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 13/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "CourseListCell.h"

@implementation CourseListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    /**
     Set Fonts
     */
    
    self.lblCourseName.font = [Font setFont_Regular_Size:16];
    self.lblCourseCode.font = [Font setFont_Medium_Size:16];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setCourseData:(Departmentcourses*)course_info{
    self.lblCourseName.text = course_info.Courses.course_name;
    self.lblCourseCode.text = [NSString stringWithFormat:@"%d",course_info.Courses.course_code];
}

@end
