//
//  ViewController.m
//  Almaktaba
//
//  Created by TechnoMac-11 on 08/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
#pragma mark- config
-(void)config{
}

#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Action Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSLog(@"%lu", (unsigned long)self.mycollectionData.count);
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *ccell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cvcell" forIndexPath:indexPath];
    return ccell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.frame.size.width - 8)/4, (self.view.frame.size.height - 28)/3);
}

@end
