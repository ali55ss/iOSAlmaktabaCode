//
//  LeftMenuVC.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 14/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuVC : UIViewController <RESideMenuDelegate>
{
    NSArray *arrMenuItem;
    NSInteger selectedIndex;
    
    __weak IBOutlet UITableView *tblMenu;
    __weak IBOutlet UIImageView *imgUserImage;
    
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    __weak IBOutlet UILabel *lblUserName;
    __weak IBOutlet UILabel *lblUserEmail;
    __weak IBOutlet UIButton *btnClose;
    
}
- (IBAction)clk_btnClose:(id)sender;


@end
