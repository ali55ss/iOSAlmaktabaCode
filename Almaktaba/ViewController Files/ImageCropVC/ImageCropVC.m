//
//  ViewController.m
//  TestCroping
//
//  Created by Javier Berlana on 20/12/12.
//  Copyright (c) 2012 Mobile one2one. All rights reserved.
//

#import "ImageCropVC.h"
#import "JBCroppableImageView.h"

@implementation ImageCropVC

#pragma mark- comman Init
-(void)commanInit{
    self.title = nil;
    
    
  crop = [[UIBarButtonItem alloc] initWithTitle:_static_Crop style:UIBarButtonItemStylePlain target:self action:@selector(cropTapped:)];
  undo = [[UIBarButtonItem alloc] initWithTitle:_static_Undo style:UIBarButtonItemStylePlain target:self action:@selector(undoTapped:)];

    done = [[UIBarButtonItem alloc] initWithTitle:_static_Done style:UIBarButtonItemStylePlain target:self action:@selector(doneTapped)];

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backTapped)];
    
    self.navigationItem.rightBarButtonItems = @[crop];
    
}
#pragma mark- View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self commanInit];
    self.image.image = self.cropImage;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)backTapped{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)doneTapped
{
    UIImage *cropedImg = [self.image getCroppedImage];
    if (cropedImg != nil) {
        [[[SharedClass sharedManager]arrCollectionImage] replaceObjectAtIndex:_currentIndex withObject:cropedImg];
        
        [[[SharedClass sharedManager]arrMultiPages] replaceObjectAtIndex:_currentIndex withObject:cropedImg];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cropTapped:(id)sender
{
    [self.image crop];
    
    self.navigationItem.rightBarButtonItems = @[done,undo];
}

- (IBAction)undoTapped:(id)sender
{
    [self.image reverseCrop];
    self.navigationItem.rightBarButtonItems = @[crop];
}

- (IBAction)subtractTapped:(id)sender {
    [self.image removePoint];
}

- (IBAction)addTapped:(id)sender {
    [self.image addPoint];
}

@end
