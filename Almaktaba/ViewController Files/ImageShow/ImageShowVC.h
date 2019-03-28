//
//  ImageShowVC.h
//  DocumentScanner
//
//  Created by TechnoMac-11 on 02/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageShowVC : UIViewController
{
    NSMutableArray * arrImagesFromPDF;
    __weak IBOutlet UICollectionView *collectionvwMain;
}
@end
