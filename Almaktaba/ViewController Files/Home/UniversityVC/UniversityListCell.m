//
//  UniversityListCell.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 12/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "UniversityListCell.h"

@implementation UniversityListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    setCornerRadius(self.universityLogo.layer, 3, 0.5, [UIColor lightGrayColor], YES);
    
    self.lblUniName.font = [Font setFont_Regular_Size:16];
    self.universityLogo.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUniversityData:(Universities*)uniInfo{
                             
    self.lblUniName.text = uniInfo.uni_name;
    
    __block UIActivityIndicatorView *activityIndicator = self.activityIndicator;
    [activityIndicator startAnimating];
    [activityIndicator setHidden:YES];
    
    [self.universityLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_UNI_LOGO_URL,uniInfo.logo]] placeholderImage:[UIImage imageNamed:@"PostImage"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [activityIndicator stopAnimating];
        [activityIndicator setHidden:YES];
    }];
    

    
//    [self.universityLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_UNI_LOGO_URL,uniInfo.logo]] placeholderImage:[UIImage imageNamed:@"PostImage"] options:SDWebImageProgressiveDownload];
    

    
    
}
@end
