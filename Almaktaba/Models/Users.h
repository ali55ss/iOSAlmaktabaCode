//
//  Users.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 15/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Userdepartments.h"
@interface Users : NSObject

@property (assign) int id;
@property (assign) int role_id;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *api_key;
@property (strong, nonatomic) NSString *api_plain_key;
@property (strong, nonatomic) NSString *firstname;
@property (strong, nonatomic) NSString *lastname;
@property (strong, nonatomic) NSString *profile_image;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *date_of_birth;
@property (strong, nonatomic) NSString *verification_code;
@property (strong, nonatomic) NSString *register_type;
@property (strong, nonatomic) Userdepartments *userdepartments;

@property (assign) int status;
@property (assign) int isDeleted;
@property (strong, nonatomic) NSString *created;
@property (strong, nonatomic) NSString *modified;

+(void)registerUserWithData:(NSMutableDictionary*)params withCompletion:(void (^)(NSDictionary *responsedic))completion;
+(void)loginUserWithData:(NSMutableDictionary*)params withCompletion:(void (^)(NSDictionary *responsedic))completion;
+(void)forgotPasswordWithData:(NSMutableDictionary*)params withCompletion:(void (^)(NSDictionary *responsedic))completion;
+(void)uploadImageWithData:(NSData*)imageData withCompletion:(void (^)(NSString *_fileName))completion;
+(void)updateUserDetailsWithData:(NSMutableDictionary*)params withCompletion:(void (^)(NSDictionary *responsedic))completion;
+(void)getUserDetailsWithData:(NSMutableDictionary*)params withCompletion:(void (^)(NSDictionary *responsedic))completion;

@end
