//
//  CourseListVC.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 13/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Departmentcourses.h"
@interface CourseListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblCourseName;
@property (weak, nonatomic) IBOutlet UILabel *lblCourseCode;

-(void)setCourseData:(Departmentcourses*)course_info;
@end
