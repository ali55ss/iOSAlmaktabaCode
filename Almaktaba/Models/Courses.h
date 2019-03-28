//
//  Courses.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 19/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Courses : NSObject
@property (assign) int id;
@property (assign) int course_code;
@property (strong, nonatomic) NSString * course_name;
@property (strong, nonatomic) NSString * course_name_ar;
@property (assign) int status;
@property (assign) int isDeleted;
@property (strong, nonatomic) NSString *created;
@property (strong, nonatomic) NSString *modified;

@end
