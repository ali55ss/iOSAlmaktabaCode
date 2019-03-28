//
//  Universities.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 15/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Universities : NSObject
@property (assign) int id;
@property (strong, nonatomic) NSString *uni_name;
@property (strong, nonatomic) NSString *uni_name_ar;
@property (strong, nonatomic) NSString *logo;
@property (assign) int status;
@property (assign) int isDeleted;
@property (strong, nonatomic) NSString *created;
@property (strong, nonatomic) NSString *modified;



+(void)getUniversitiesListWithCompletion:(void (^)(id responsedict))completion;
+(void)uploadImageWithData:(NSData*)imageData withCompletion:(void (^)(NSString *_fileName))completion;
@end
