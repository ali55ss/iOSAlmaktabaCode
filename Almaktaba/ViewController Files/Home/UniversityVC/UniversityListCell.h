//
//  UniversityListCell.h
//  Almaktaba
//
//  Created by TechnoMac-11 on 12/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Universities.h"
@interface UniversityListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *universityLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblUniName;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

-(void)setUniversityData:(Universities*)uniInfo;
@end
