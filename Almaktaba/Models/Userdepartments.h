//
//  Userdepartments.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 27/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Userdepartments : NSObject

@property (assign) int id;
@property (assign) int user_id;
@property (assign) int collegedepartment_id;
@property (assign) int status;
@property (assign) int isDeleted;
@property (strong, nonatomic) NSString *created;
@property (strong, nonatomic) NSString *modified;

+(void)enrollUserDepartmentWithData:(NSMutableDictionary*)params withCompletion:(void (^)(NSDictionary *responsedic))completion;
+(void)editEnrollUserDepartmentWithData:(NSMutableDictionary*)params withCompletion:(void (^)(NSDictionary *responsedic))completion;

@end
