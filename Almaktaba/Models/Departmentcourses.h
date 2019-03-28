//
//  Departmentcourses.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 19/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Courses.h"
@interface Departmentcourses : NSObject

@property (assign) int id;
@property (assign) int collegedepartment_id;
@property (assign) int course_id;
@property (assign) int status;
@property (assign) int isDeleted;
@property (strong, nonatomic) NSString *created;
@property (strong, nonatomic) NSString *modified;
@property (strong, nonatomic) Courses *Courses;

+(void)getCourseListOfDeptID:(int)department_id WithCompletion:(void (^)(id responsedict))completion;

@end
