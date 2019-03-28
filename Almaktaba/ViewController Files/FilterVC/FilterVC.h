//
//  FilterVC.h
//  DocumentScanner
//
//  Created by TechnoMac-11 on 02/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FilterVC : UIViewController <UIScrollViewDelegate>
{
    /**
     current index of images array
     */
    NSInteger currentIndex;
    
    /**
     arrImage for store popup text and arrTblCellText for store popup image icon
     */
    NSMutableArray *arrImage ,*arrTblCellText;
    
    __weak IBOutlet UICollectionView *collection;
    
    /**
     Bottom bar menu
     */
    NSArray *arrBarItems,*arrBarImages;
    __weak IBOutlet UIView *viewBottomBar;
    __weak IBOutlet UICollectionView *bottomBarCollection;
    
    
    /**
     Front Image
     */
    UIImage *imgFrontImage;
    
    
    /**
     
     Filter Image
     */
    __weak IBOutlet UIView *popupViewBG;
    __weak IBOutlet UILabel *lblClose;
    __weak IBOutlet UIView *viewfilterpopup;
    __weak IBOutlet UITableView *tblPopUP;
    __weak IBOutlet NSLayoutConstraint *nscLeftPaddingPopClosebtn;
    __weak IBOutlet NSLayoutConstraint *nscWidhtPopClosebtn;
    
}

- (IBAction)clk_closePopup:(id)sender;



@end
