//
//  Colleges.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 16/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Colleges : NSObject

@property (assign) int id;
@property (assign) int university_id;
@property (strong, nonatomic) NSString *college_name;
@property (strong, nonatomic) NSString *college_name_ar;
@property (strong, nonatomic) NSString *logo;
@property (assign) int status;
@property (assign) int isDeleted;
@property (strong, nonatomic) NSString *created;
@property (strong, nonatomic) NSString *modified;



+(void)getCollegesListOfUniversityID:(int)uni_id WithCompletion:(void (^)(id responsedict))completion;
@end
