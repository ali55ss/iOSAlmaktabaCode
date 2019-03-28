//
//  DepartmentListCell.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 13/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Collegedepartments.h"
@interface DepartmentListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDepartmentName;

-(void)setDepartmentData:(Collegedepartments*)deptInfo;

@end
