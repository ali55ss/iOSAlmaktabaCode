//
//  DocumentReports.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 26/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Documentreports : NSObject
@property (assign) int id;
@property (assign) int document_id;
@property (assign) int user_id;
@property (assign) int report_type;

+(void)addReportOnInappropriateDocumentWithData:(NSMutableDictionary*)params WithCompletion:(void (^)(id responsedict))completion;

@end
