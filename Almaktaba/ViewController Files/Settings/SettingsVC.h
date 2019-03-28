//
//  SettingsVC.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 15/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsVC : UIViewController
{
    
    NSArray *arrTableCell;
    
    __weak IBOutlet UILabel *lblLogout;
    __weak IBOutlet UILabel *lblMyDepartment;
    __weak IBOutlet UILabel *lblTaptoChangeDepartment;
    __weak IBOutlet UILabel *lblChangePassword;
    
    IBOutlet UITableViewCell *tblCellMyDepartments;
    IBOutlet UITableViewCell *tblCellLogout;
    IBOutlet UITableViewCell *tblCellChangePassword;
    
    __weak IBOutlet UITableView *tblSettings;
}
@end
