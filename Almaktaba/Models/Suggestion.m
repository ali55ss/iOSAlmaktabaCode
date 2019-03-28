//
//  Suggestion.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 19/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "Suggestion.h"

@implementation Suggestion
+(void)suggestNewWithData:(NSMutableDictionary*)params withCompletion:(void (^)(NSDictionary *responsedic))completion{
    QueryModel *model = [[QueryModel alloc] initWithClass:[Suggestion class]];
    [model insertObject:params withLoading:YES showToastOnSuccess:YES withCompletion:^(NSDictionary *responsedic) {
        if (completion) {
            completion (responsedic);
        }
    }];
}
@end
