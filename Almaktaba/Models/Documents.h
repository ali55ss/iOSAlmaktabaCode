//
//  Documents.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 20/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Users.h"

@interface Documents : NSObject


@property (assign) int id;
@property (assign) int user_id;
@property (assign) int departmentcourse_id;
@property (strong, nonatomic) NSString *doc_title;
@property (strong, nonatomic) NSString *doc_description;
@property (strong, nonatomic) NSString *filename;
@property (strong, nonatomic) NSString *front_image;
@property (strong, nonatomic) NSString *mime_type;
@property (strong, nonatomic) NSString *created;
@property (strong, nonatomic) NSString *modified;
@property (strong, nonatomic) Users *Users;
@property (assign) int deleted_by;
@property (assign) int status;
@property (assign) int isDeleted;

+(void)uploadDocumentWithData:(NSData*)docData withMime_type:(NSString*)mime_type withCompletion:(void (^)(NSString *_fileName))completion;
+(void)uploadDocumentFrontPageWithData:(NSData*)docData withMime_type:(NSString*)mime_type withCompletion:(void (^)(NSString *_fileName))completion;
+(void)getDocumentsListOfdepartmentcourse:(int)departmentcourse_id WithCompletion:(void (^)(id responsedict))completion;
+(void)saveDocumentDetailsWithData:(NSMutableDictionary*)params withCompletion:(void (^)(NSDictionary *responsedic))completion;
+(void)deleteDocumentWithData:(NSMutableDictionary*)params withCompletion:(void (^)(NSDictionary *responsedic))completion;
@end
