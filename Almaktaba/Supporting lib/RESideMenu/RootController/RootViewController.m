//
//  RootViewController.m
//  Dashbord
//
//  Created by Mac Backup on 8/3/17.
//  Copyright © 2017 Mac Backup. All rights reserved.
//

#import "RootViewController.h"
#import "LeftMenuVC.h"
#import "RESideMenu.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    this.rootVCDelegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = theme_Blue_Color;
    self.contentViewShadowOffset = CGSizeMake(1, 1);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 12;
    self.contentViewShadowEnabled = YES;
    
    LeftMenuVC * leftVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LeftMenuVC"];
    
 self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CenterNavController"];
    
    if (isAppLanguageRightToLeft()) {
        self.rightMenuViewController = leftVC;

    }else{
        self.leftMenuViewController = leftVC;
    }


    
//    self.backgroundImage = [UIImage imageNamed:@"Dashboard_bg"];
    
    self.delegate = self;
}

#pragma mark- Handle notification
-(void)handleReceivedPushNotification:(NSArray*)userInfo{
//    NSLog(@"handleReceivedPushNotification");
//    
//    UINavigationController *topVC = (UINavigationController*)self.contentViewController;
//    
//    if ([[userInfo valueForKey:@"notification_type"] isEqualToString:@"driver_request_update"] || [[userInfo valueForKey:@"notification_type"] isEqualToString:@"driver_accept_reject_ride_letter"]) {// driver accept or reject ride
//        
//        if ([topVC.visibleViewController isKindOfClass:[ConfirmOberRequestVC class]]) {
//            dispatch_async(dispatch_get_main_queue(),^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:OBSERVER_GET_RIDE_REQUEST_RESPONSE object:userInfo];
//            });
//        }else{
//            
//            if ([[userInfo valueForKey:@"status"] intValue]) {
//                dispatch_async(dispatch_get_main_queue(),^{
//                    ConfirmOberRequestVC * mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmOberRequestVC"];
//                    mainVC.arrNotificationInfo = userInfo;
//                    [topVC pushViewController:mainVC animated:NO];
//                });
//            }else{
//                [userDefaults setBool:NO ForKey:KEY_DRIVER_ACCEPT_RIDE];
//                [userDefaults removeObjectForKey:KEY_CURRENT_TRIP_ID];
//                FailureVC *mainView  =[self.storyboard instantiateViewControllerWithIdentifier:@"FailureVC"];
//                [topVC pushViewController:mainView animated:NO];
//            }
//        }
//    }else if ([[userInfo valueForKey:@"notification_type"] isEqualToString:@"update_ride_status"] || [[userInfo valueForKey:@"notification_type"] isEqualToString:@"update_shipment_status"] ){// driver update ride status
//        
//        if ([topVC.visibleViewController isKindOfClass:[DriverTrackingVC class]]){
//            dispatch_async(dispatch_get_main_queue(),^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:OBSERVER_UPDATE_STATUS object:userInfo];
//            });
//        }else{
//            if ([topVC.visibleViewController isKindOfClass:[RideStatusVC class]]){
//                dispatch_async(dispatch_get_main_queue(),^{
//                    [[NSNotificationCenter defaultCenter] postNotificationName:OBSERVER_GET_CURRENT_RIDE_STATUS object:userInfo];
//                });
//            }else{
//                RideStatusVC *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RideStatusVC"];
//                mainVC.strTripID = [userInfo valueForKey:PM_TRIP_ID];
//                mainVC.strService_type = [userInfo valueForKey:PM_SERVICE_TYPE];
//                [topVC pushViewController:mainVC animated:NO];
//            }
//        }
//        
//    }else if ([[userInfo valueForKey:@"notification_type"] isEqualToString:@"select_driver"]){// select driver for raide later
//        
//        
//        if ([self getDiffTime:[userInfo valueForKey:PM_START_TIME]]) {
//            showAlertWithErrorMessage(EM_RIDE_TIME_EXPIRE);
//        }else{
//            if ([topVC.visibleViewController isKindOfClass:[ConfirmOberRequestVC class]]){
//                dispatch_async(dispatch_get_main_queue(),^{
//                    [[NSNotificationCenter defaultCenter] postNotificationName:OBSERVER_SELECT_DRIVER object:userInfo];
//                    
//                });
//            }else{
//                ConfirmOberRequestVC *mainVC = [theAppDelegate.storyboard instantiateViewControllerWithIdentifier:@"ConfirmOberRequestVC"];
//                mainVC.arrNotificationInfo = userInfo;
//                mainVC.isRideLater = YES;
//                mainVC.strTrip_letter_id = [userInfo valueForKey:PM_TRIP_LETTER_ID];
//                [topVC pushViewController:mainVC animated:NO];
//                
//                //                  [self.navigationController pushViewController:mainVC animated:YES];
//            }
//        }
//    }
}

-(BOOL)getDiffTime:(NSString*)strDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *utc = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ z",strDate]];
    
    return [self isEndDateIsSmallerThanCurrent:utc];
}
- (BOOL)isEndDateIsSmallerThanCurrent:(NSDate *)checkEndDate
{
    NSDate* enddate = checkEndDate;
    NSDate* currentdate = [NSDate date];
    NSTimeInterval distanceBetweenDates = [enddate timeIntervalSinceDate:currentdate];
    double secondsInMinute = 60;
    NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
    
    if (secondsBetweenDates == 0)
        return YES;
    else if (secondsBetweenDates < 0)
        return YES;
    else
        return NO;
}
#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    //    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    //    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    //    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
    
    
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    //    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
    
}
@end
