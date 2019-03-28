//
//  UITextField+textfield.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 06/04/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "UITextField+textfield.h"
#import "Utilities.h"

@implementation UITextField (textfield)
- (UITextInputMode *) textInputMode {
    for (UITextInputMode *tim in [UITextInputMode activeInputModes]) {
        if ([[Utilities langFromLocale:@"en"] isEqualToString:[Utilities langFromLocale:tim.primaryLanguage]]) return tim;
    }
    return [super textInputMode];
}
@end
