//
//  Suggestion.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 19/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Suggestion : NSObject
@property (assign) int id;
@property (strong, nonatomic) NSString  *suggestion_type;
@property (strong, nonatomic) NSString  *course_code;
@property (assign) int type_id;
@property (strong, nonatomic) NSString *logo;
@property (assign) int user_id;
@property (strong, nonatomic) NSString* name;
@property (assign) int status;
@property (assign) int isDeleted;
@property (strong, nonatomic) NSString *created;
@property (strong, nonatomic) NSString *modified;


+(void)suggestNewWithData:(NSMutableDictionary*)params withCompletion:(void (^)(NSDictionary *responsedic))completion;


@end
