//
//  QueryModel.h
//  FacialDetection
//
//  Created by TechnoMac-7 on 22/03/17.
//  Copyright © 2017 TechnoMac-7. All rights reserved.
//

#import <Foundation/Foundation.h>

// API parameters
#define parameterCondition @"conditions"
#define parameterContains @"contain"

#define parameterFields @"fields"
#define parameterGet @"get"
#define parameterOrder @"order"
#define parameterPage @"page"
#define parameterLimit @"limit"
#define parameterOffset @"offset"
#define parameterNotIn @"NOT IN"
#define parameterIN @"IN"
#define parameterStatus @"status"

@interface QueryModel : NSObject
{
    NSString *strClassname;
    NSMutableDictionary *dicUpdateFields,*dicMain,*dicUpdate,*dicRooms;
}
-(id)initWithClassName:(NSString *)classname;
-(id)initWithClass:(Class)_class;

-(id)initWithClassname:(NSString *)classname AndDict:(NSDictionary *)dicRoom;

#pragma mark Where Clause
-(void)WhereKey:(NSString *)field Equalto:(id)object;    // Any condition to fetch and Update data
-(void)AddObject:(NSString*)field Equelto:(id)object;
#pragma mark - Fields conditions
-(void)SetFields:(NSString *)strObject ;
#pragma marl Not In clause
-(void)FieldObjectNotInData:(NSString *)Field andValue:(id)object;

#pragma mark ORDER Clause 
-(void)SortinAscendingwithfield:(NSString *)strFieldName;
-(void)SortinDescendingwithfiled:(NSString *)strFieldName;

#pragma mark Contains Clause
-(void)ContainsObject:(NSString *)strObject;  // Need record of Join table

#pragma mark Update Object
-(void)SetUpdatedFieldsAndValues:(NSDictionary *)dicFields; // Set all update fields
-(void)updateObjectFields:(NSDictionary *)dicfields withCompletion:(void(^)(BOOL isUpdate))completion;   // update object to server

#pragma mark Get From table 
//-(void)GetRecordsQuerywithCompletion:(void (^)(id Response))completion;
-(void)getRecordsQuerywithCompletionWithLoader:(BOOL)isShowLoader showToastOnSuccess:(BOOL)isShowToast WitCompilation:(void (^)(id response))completion;




#pragma mark- ========= API Calling ============
-(void)loginwithCredentials:(NSDictionary *)dicCondition WithCompletion:(void (^)(NSDictionary *responsedic))completion;

#pragma mark - Forgot password

-(void)forgotPasswordWithData:(NSDictionary*)reqData withCompletion:(void (^)(NSDictionary *resposeDic))completion;

#pragma mark- Verify OTP
-(void)resendVerificationCodeWithData:(NSDictionary*)reqData withCompletion:(void (^)(NSDictionary *resposeDic))completion;

#pragma mark Varification Clause
-(void)verifyUserWithVarificationCode:(NSDictionary *)dicVarify withLoading:(BOOL)isLoading showToastOnSuccess:(BOOL)isShowToast withCompletion:(void (^)(NSDictionary *responseDic))completion;

#pragma mark register user
-(void)registerUserWithData:(NSDictionary *)dicData withLoading:(BOOL)isLoading showToastOnSuccess:(BOOL)isShowToast withCompletion:(void (^)(NSDictionary *responsedic))completion;

-(void)logoutUser:(NSDictionary*)reqData withCompletion:(void (^)(NSDictionary *resposeDic))completion;

#pragma mark Insert Clause
-(void)insertObject:(NSDictionary *)dicData withLoading:(BOOL)isLoading showToastOnSuccess:(BOOL)isShowToast withCompletion:(void (^)(NSDictionary *responsedic))completion;

#pragma mark delete clause
-(void)deleteObject:(NSDictionary*)dicData withLoading:(BOOL)isLoading showToastOnSuccess:(BOOL)isShowToast withCompletion:(void(^)(NSDictionary*dicResponse))completion;


#pragma mark Upload image Clause
-(void)uploadFileData:(NSData *)data ForField:(NSString *)strFieldName withfileExtention:(NSString *)strfileExtention withLoading:(BOOL)isShow withCompletion:(void (^)(NSString *fileName))completion;

#pragma mark update profile
-(void)updateUserProfileInformationWithValues:(NSDictionary *)dicValues withCompletion:(void (^)(NSDictionary *response))completion;

#pragma mark - Edit Record
-(void)editRecordWithValues:(NSDictionary *)dicValues withCompletion:(void (^)(NSDictionary *responsedic))completion;


@end
