//
//  RootViewController.h
//  Dashbord
//
//  Created by Mac Backup on 8/3/17.
//  Copyright © 2017 Mac Backup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
@interface RootViewController : RESideMenu <RESideMenuDelegate>
-(void)handleReceivedPushNotification:(NSArray*)userInfo;

@end
