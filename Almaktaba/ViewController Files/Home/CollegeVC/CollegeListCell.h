//
//  CollegeListCell.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 13/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Colleges.h"
@interface CollegeListCell : UITableViewCell
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *collegeLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblCollegeName;


-(void)setCollegeData:(Colleges*)collegeInfo;
@end
