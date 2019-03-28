//
//  ViewController.h
//  TestCroping
//
//  Created by Javier Berlana on 20/12/12.
//  Copyright (c) 2012 Mobile one2one. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CropToolbar.h"
@class JBCroppableImageView;
@interface ImageCropVC : UIViewController
{
    UIBarButtonItem *crop,*undo,*done;
}
@property (weak, nonatomic) IBOutlet UIButton *cropButton;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet JBCroppableImageView  *image;

@property (strong,nonatomic) UIImage *cropImage;
@property (assign) NSInteger currentIndex;;


/**
 The toolbar view managed by this view controller.
 */
@property (strong, nonatomic) CropToolbar *toolbar;


- (IBAction)cropTapped:(id)sender;
- (IBAction)undoTapped:(id)sender;
- (IBAction)subtractTapped:(id)sender;
- (IBAction)addTapped:(id)sender;

@end
