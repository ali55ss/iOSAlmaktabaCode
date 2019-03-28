//
//  FilterVC.m
//  DocumentScanner
//
//  Created by TechnoMac-11 on 02/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "FilterVC.h"
#import "CustomCollectionCell.h"
#import "CustomAddNewPageCell.h"
#import "IRLScannerViewController.h"
#import "UploadDocsVC.h"
#import "DocsPreviewVC.h"

#import "floatTableViewCell.h"

#import "ImageCropVC.h"

#import "MMOpenCVHelper.h"

#define degreesToRadians(x) (M_PI * (x) / 180.0)

@interface FilterVC () <IRLScannerViewControllerDelegate>

@end

@implementation FilterVC
#pragma mark- Config
-(void)config{
    
    lblClose.text = _static_Close;
    nscWidhtPopClosebtn.constant = self.view.width/5.0f;
    nscLeftPaddingPopClosebtn.constant = self.view.width/5.0f;
    
    
//    UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
//    [popupViewBG addGestureRecognizer:letterTapRecognizer];
    
    
    NSDate *time = [NSDate date];
    NSDateFormatter* df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-dd-MMM HH:mm"];
    NSString *timeString = [df stringFromDate:time];
    NSString *fileName = [NSString stringWithFormat:@"%@ %@", _static_doc,timeString];
    
    self.title = fileName;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:_static_Preview style:UIBarButtonItemStylePlain target:self action:@selector(btnPreviewPressed)];
    
    /**
     
     */
    
    
    
}
#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self config];
    [self setupCollectionView];
    
    
    [self getAllIMages];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
    [collection reloadData];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- Action Methods
-(void)btnPreviewPressed{
    [self clk_save];
}

- (IBAction)clk_closePopup:(id)sender {
    [self clk_closePopUP];
}

#pragma mark- UITapGestureRecognizer
- (void)highlightLetter:(UITapGestureRecognizer*)sender {
    UIView *view = sender.view;
    if (view == popupViewBG) {
//        [self clk_closePopUP];
    }
//    NSLog(@"%d", view.tag);//By tag, you can find out where you had tapped.
    
    
}
#pragma mark- setup Collection view
-(void)setupCollectionView{
    collection.contentOffset = CGPointZero;
    
    [collection setNeedsLayout];
    
    [collection registerNib:[UINib nibWithNibName:@"CustomCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    [collection registerNib:[UINib nibWithNibName:@"CustomAddNewPageCell" bundle:nil] forCellWithReuseIdentifier:@"CustomAddNew"];
    
    [collection setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    currentIndex = [[SharedClass sharedManager]selectedIndex];
    
    arrImage = [[NSMutableArray alloc]initWithObjects:@"nofilter",@"blackwhite",@"gray",@"magiccolor", nil];

    arrTblCellText = [[NSMutableArray alloc]initWithObjects:_static_no_filter,_static_black_white,_static_gray,_static_magic_color, nil];

    
//    tblPopUP.transform = CGAffineTransformMakeRotation(-M_PI);
    tblPopUP.backgroundColor = [UIColor clearColor];
    tblPopUP.scrollEnabled = NO;
    tblPopUP.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tblPopUP reloadData];
    
    arrBarItems = [[NSArray alloc] initWithObjects:_static_scan,_static_filter,_static_crop,_static_rotate,_static_delete, nil];
    arrBarImages = [[NSArray alloc] initWithObjects:@"scan",@"filter",@"crop",@"rotate",@"delete", nil];
    
   
    [bottomBarCollection reloadData];
}

#pragma mark- Get All Image
-(void)getAllIMages
{
    @try {
        
        if ([[SharedClass sharedManager]cropVCtag] != 1)
        {
            if ([[SharedClass sharedManager]cameraPageGTag] == 1)// gllry
            {
                
                [[[SharedClass sharedManager] arrCollectionImage] removeAllObjects];
                
                for (UIImage *image in [[[SharedClass sharedManager]arrMultiPages] mutableCopy]) {
                    
                    NSLog(@"%f", [[NSUserDefaults standardUserDefaults]floatForKey:@"quality"]);
                    
                    NSData * data = UIImageJPEGRepresentation(image, [[NSUserDefaults standardUserDefaults]floatForKey:@"quality"]);
                    UIImage * image1 = [UIImage imageWithData:data];
                    //
                    //                    NSString * strFilter = [[NSUserDefaults standardUserDefaults]valueForKey:NSUDKeySwitchDefaultFilter];
                    //
                    //                    if ([strFilter isEqualToString:@"bw"]){
                    //                        image1 = [MMOpenCVHelper grayImage:image1];
                    //
                    //                    }
                    //                    else if([strFilter isEqualToString:@"gray"]){
                    //                        image1 = [MMOpenCVHelper blackandWhite:image1];
                    //
                    //                    }
                    //                    else{
                    //                        image1 = image1;
                    //                    }
                    [[[SharedClass sharedManager]arrCollectionImage] addObject:image1];
                }
                
                
                [[SharedClass sharedManager]setSelectedIndex:0];
                currentIndex = 0;
                [collection reloadData];
            }
            else
            {
                [[[SharedClass sharedManager]arrCollectionImage] removeAllObjects];  //camera
                for (UIImage *image in [[SharedClass sharedManager]arrMultiPages] ) {
                    
                    NSData * data = UIImageJPEGRepresentation(image, [[NSUserDefaults standardUserDefaults]floatForKey:@"quality"]);
                    UIImage * image1 = [UIImage imageWithData:data];
                    
                    //                    NSString * strFilter = [[NSUserDefaults standardUserDefaults]valueForKey:NSUDKeySwitchDefaultFilter];
                    //
                    //                    if ([strFilter isEqualToString:@"bw"]){
                    //                        image1 = [MMOpenCVHelper grayImage:image1];
                    //
                    //                    }
                    //                    else if([strFilter isEqualToString:@"gray"]){
                    //                        image1 = [MMOpenCVHelper blackandWhite:image1];
                    //
                    //                    }
                    //                    else{
                    //                        image1 = image1;
                    //                    }
                    
                    [[[SharedClass sharedManager]arrCollectionImage] addObject:image1];
                }
                
                currentIndex = 0;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [collection reloadData];
                    
                    if ([[[SharedClass sharedManager]arrCollectionImage] count] != 0)
                    {
                        NSLog(@"%lu",(unsigned long)[[SharedClass sharedManager] selectedIndex]);
                        [collection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentIndex inSection:0]
                                           atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                   animated:NO];
                        
                        //                        [collection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[[SharedClass sharedManager] selectedIndex] inSection:0]
                        //                                           atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                        //                                                   animated:NO];
                        currentIndex = [[SharedClass sharedManager]selectedIndex];
                        //                        lblTitlePgCount.text = [NSString stringWithFormat:@"%ld / %lu",currentIndex+1,(unsigned long)[[SharedClass sharedManager]arrCollectionImage].count];
                    }
                });
            }
        }
        else
        {
            [[SharedClass sharedManager]setCropVCtag:0];
            [collection reloadData];
        }
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
//    if ([[[SharedClass sharedManager] arrCollectionImage] count]) {
//        imgFrontImage =  [[[SharedClass sharedManager]arrCollectionImage] objectAtIndex:0];
//    }
    
    
    
    /* UIScrollView  *scrollVie=[[UIScrollView alloc]init];
     
     scrollVie.delegate = self;
     scrollVie.scrollEnabled = YES;
     int scrollWidth = collection.width;
     //scrollVie.contentSize = CGSizeMake(scrollWidth,100);
     scrollVie.pagingEnabled = YES;
     scrollVie.frame=CGRectMake(0, 72, self.view.frame.size.width, collection.height);
     scrollVie.backgroundColor=[UIColor redColor];
     
     
     int xOffset = 10;
     
     for(int index=0; index < [[[SharedClass sharedManager]arrCollectionImage] count]; index++)
     {
     
     //        CGRectMake(10, 0, cell.frame.size.width-20, cell.frame.size.height-20)
     
     UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset,10,collection.width - 20, collection.height)];
     img.contentMode = UIViewContentModeScaleAspectFit;
     img.image = (UIImage*)  [[[SharedClass sharedManager]arrCollectionImage] objectAtIndex:index];
     
     [scrollVie addSubview:img];
     
     xOffset += collection.width - 10;
     
     }
     
     [self.view addSubview:scrollVie];
     
     scrollVie.contentSize = CGSizeMake(scrollWidth+xOffset,collection.height);
     */
    
    
    //[self clk_save];
}

#pragma mark- Action Methods


#pragma mark - UICollectionView Datasource & Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == bottomBarCollection) {
        CGSize cellSize = CGSizeMake(collectionView.frame.size.width/5.0f, collectionView.frame.size.height);
        return  cellSize;
    }else{
        CGSize cellSize = CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
        
        return cellSize;
    }
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (collectionView == bottomBarCollection) {
        return 1;
    }else{
        return 1;
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == bottomBarCollection) {
        return arrBarItems.count;
    }else{
//        if (section==0) {
//            return [[[SharedClass sharedManager]arrCollectionImage] count];
//        }
//        else{
//            return 1;
//        }
        return [[[SharedClass sharedManager]arrCollectionImage] count];
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == bottomBarCollection) {
        UICollectionViewCell *ccell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cvcell" forIndexPath:indexPath];
        UILabel *itemName = (UILabel*)[ccell viewWithTag:102];
        UIImageView *itemImage = (UIImageView*)[ccell viewWithTag:101];
        
        itemName.text = [[arrBarItems objectAtIndex:indexPath.row] capitalizedString];
        itemImage.image = [UIImage imageNamed:[arrBarImages objectAtIndex:indexPath.row]];
        return ccell;
    }else{
//        if (indexPath.section==0)
        {
            [collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionCell" bundle:nil] forCellWithReuseIdentifier:[NSString stringWithFormat:@"cell%ld",(long)indexPath.row]];
            
            CustomCollectionCell *cell = (CustomCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"cell%ld",(long)indexPath.row] forIndexPath:indexPath];
            
            //            cell.imgCollection.transform = CGAffineTransformMakeRotation(degreesToRadians(0));
            
            
            
            cell.imgCollection.image = [[[SharedClass sharedManager]arrCollectionImage] objectAtIndex:indexPath.row];
            
            //            cell.imgCollection.transform = [self orientationTransformedRectOfImage:cell.imgCollection.image];
            
            cell.imgCollection.contentMode = UIViewContentModeScaleAspectFit;
            
            
            
            return cell;
        }
//        else{
//            CustomAddNewPageCell *cell = (CustomAddNewPageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CustomAddNew" forIndexPath:indexPath];
//            cell.imgvwAddPage.image = [UIImage imageNamed:@"addnewpage"];
//            return cell;
//        }
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == bottomBarCollection) {
        [[SharedClass sharedManager]setSelectedIndex:indexPath.row];
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                [self openIRLScannerViewController];
            }else if (indexPath.row == 1){
                
                UICollectionViewCell *cell = (UICollectionViewCell *)[bottomBarCollection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                [cell setAlpha:0];
                
                [popupViewBG setHidden:NO];
            }else if (indexPath.row == 2) {
                ImageCropVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"ImageCropVC"];
                mainvc.cropImage =  [[[SharedClass sharedManager]arrCollectionImage] objectAtIndex:currentIndex];
                mainvc.currentIndex = currentIndex;
                [self.navigationController pushViewController:mainvc animated:YES];
                
            }else if (indexPath.row == 3) {
                [self rotatImage];
            }else if (indexPath.row == 4){
                [self clk_deleteImage];
            }
        }
        return;
    }else{
//        if (indexPath.section==1) {
//            [self openIRLScannerViewController];
//        }
    }
}
-(void)openIRLScannerViewController{
    IRLScannerViewController *scanner = [IRLScannerViewController cameraViewWithDefaultType:IRLScannerViewTypeNormal defaultDetectorType:IRLScannerDetectorTypeAccuracy withDelegate:self];
    scanner.showControls = YES;
    scanner.showAutoFocusWhiteRectangle = YES;
    [[SharedClass sharedManager]setIsAutometicCapture:YES];
    [self.navigationController pushViewController:scanner animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = collection.frame.size.width;
    int currentPage = collection.contentOffset.x / pageWidth;
    NSIndexPath *indxPath;
    
    if (currentPage==[[[SharedClass sharedManager]arrCollectionImage] count]) {
        indxPath = [NSIndexPath indexPathForRow:0 inSection:1];
    }
    else{
        indxPath = [NSIndexPath indexPathForRow:currentPage inSection:0];
    }
    /*if (indxPath.section == 0) {
        
        currentIndex = indxPath.row;
        [[SharedClass sharedManager]setSelectedIndex:currentIndex];
        [bottomBarCollection setHidden:NO];
    }
    else{
        [bottomBarCollection setHidden:YES];
    }*/
    currentIndex = indxPath.row;
    [[SharedClass sharedManager]setSelectedIndex:currentIndex];
    [bottomBarCollection setHidden:NO];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = collection.frame.size.width;
    int currentPage = collection.contentOffset.x / pageWidth;
    NSIndexPath *indxPath;
    
    if (currentPage==[[[SharedClass sharedManager]arrCollectionImage] count]) {
        indxPath = [NSIndexPath indexPathForRow:0 inSection:1];
    }
    else{
        indxPath = [NSIndexPath indexPathForRow:currentPage inSection:0];
    }
    
//    if (indxPath.section == 0) {
//        currentIndex = indxPath.row;
//        [[SharedClass sharedManager]setSelectedIndex:currentIndex];
//        [bottomBarCollection setHidden:NO];
//    }
//    else{
//        [bottomBarCollection setHidden:YES];
//    }
    currentIndex = indxPath.row;
    [[SharedClass sharedManager]setSelectedIndex:currentIndex];
    [bottomBarCollection setHidden:NO];
    
//    [self getOrientationOfImage:[[[SharedClass sharedManager]arrCollectionImage] objectAtIndex:currentIndex]];
}

#pragma mark- UITableView Delegate & Datasource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrTblCellText count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    floatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"floatTableViewCell" bundle:nil]forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    [cell setTitle:[arrTblCellText objectAtIndex:indexPath.row] andImage:[arrImage objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"selected CEll: %tu",indexPath.row);
    
    if ([[[SharedClass sharedManager]arrMultiPages]count] > 0 && [[[SharedClass sharedManager]arrCollectionImage] count] > 0)
    {
        switch (indexPath.row)
        {
            case 0:
                [[[SharedClass sharedManager]arrCollectionImage] replaceObjectAtIndex:currentIndex withObject:[[[SharedClass sharedManager] arrMultiPages] objectAtIndex:currentIndex]];
                break;
                
            case 1:
                
                [self imageConvertToBlackWhite];

                break;
                
            case 2:
                [self imageConvertToGray];
                
                break;
                
            case 3:
                
//                [[[SharedClass sharedManager]arrCollectionImage] replaceObjectAtIndex:[[SharedClass sharedManager] selectedIndex] withObject:[[[SharedClass sharedManager] arrMultiPages] objectAtIndex:[[SharedClass sharedManager] selectedIndex]]];
                [self imageConvertToMagicColor];

                break;
                
            case 4:
//       [[[SharedClass sharedManager]arrCollectionImage] replaceObjectAtIndex:[[SharedClass sharedManager] selectedIndex] withObject:[[[SharedClass sharedManager] arrMultiPages] objectAtIndex:[[SharedClass sharedManager] selectedIndex]]];
                [self imageConvertToMagicColor];
                //                }
                //                else{
                //                    [self clk_buyProVersion];
                //                }
                break;
                
            default:
                break;
        }
    }
    
    [collection reloadData];
    
    [self clk_closePopUP];
}
-(void)clk_closePopUP
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[bottomBarCollection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [cell setAlpha:1];
    [popupViewBG setHidden:YES];
}

#pragma mark - UIimage Color effect method
-(void)imageConvertToGray
{
    
    UIImage *imm = [MMOpenCVHelper grayImage:[[[SharedClass sharedManager] arrMultiPages] objectAtIndex:currentIndex]];
    
    [[[SharedClass sharedManager]arrCollectionImage] replaceObjectAtIndex:currentIndex withObject:imm];
}

-(void)imageConvertToBlackWhite
{
    
//    UIImage *imgTmp = [MMOpenCVHelper blackandWhite:[[[SharedClass sharedManager]arrMultiPages] objectAtIndex:[[SharedClass sharedManager] selectedIndex]]];
//    [[[SharedClass sharedManager]arrCollectionImage] replaceObjectAtIndex:[[SharedClass sharedManager] selectedIndex] withObject:imgTmp];
    
    UIImage *imm = [MMOpenCVHelper blackandWhite:[[[SharedClass sharedManager] arrMultiPages] objectAtIndex:currentIndex]];
    
    [[[SharedClass sharedManager]arrCollectionImage] replaceObjectAtIndex:currentIndex withObject:imm];

}

-(void)imageConvertToMagicColor
{
//    UIImage *imgTmp = [MMOpenCVHelper magicColor:[[[SharedClass sharedManager] arrMultiPages] objectAtIndex:[[SharedClass sharedManager] selectedIndex]]];
//    [[[SharedClass sharedManager]arrCollectionImage] replaceObjectAtIndex:[[SharedClass sharedManager] selectedIndex] withObject:imgTmp];
    
    UIImage *imm = [MMOpenCVHelper magicColor:[[[SharedClass sharedManager] arrMultiPages] objectAtIndex:currentIndex]];
    
    [[[SharedClass sharedManager]arrCollectionImage] replaceObjectAtIndex:currentIndex withObject:imm];

}



#pragma mark- Rotate File
#define rad(angle) ((angle) / 180.0 * M_PI)
- (CGAffineTransform)orientationTransformedRectOfImage:(UIImage *)img
{
    CGAffineTransform rectTransform;
    switch (img.imageOrientation)
    {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -img.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -img.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -img.size.width, -img.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    
    return CGAffineTransformScale(rectTransform, img.scale, img.scale);
}
-(void)rotatImage{
   
    
//    UIImage *imageToDisplay =
    
    
    
    CustomCollectionCell *cell = (CustomCollectionCell *)[collection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
    //double angle = atan2(cell.imgCollection.transform.b, cell.imgCollection.transform.a);
    

    UIImageOrientation orientation;
     float degree = 0;
    
    switch (cell.imgCollection.image.imageOrientation) {
        case UIImageOrientationUp: //Left
            NSLog(@"OrientationUp");
             degree = -90;
            orientation = UIImageOrientationLeft;
            break;
        case UIImageOrientationDown: //Right
            NSLog(@"OrientationDown");
            orientation = UIImageOrientationRight;
            degree = -180;

            break;
        case UIImageOrientationLeft: //Down
            NSLog(@"OrientationLeft");
            orientation = UIImageOrientationDown;
            degree = 90;

            break;
        case UIImageOrientationRight: //Up
            NSLog(@"OrientationRight");
            orientation = UIImageOrientationUp;
            degree = 0;
            break;
        default:
            orientation = UIImageOrientationUp;
            break;
    }
    
    
    
    //    double angle = [self orientationTransformedRectOfImage:[[[SharedClass sharedManager]arrCollectionImage] objectAtIndex:currentIndex]];
    
//    float degree = 0;
    
//    if (angle == 0)
//    {
//        degree = -90;
//    }
//    else if (angle == -1.5707963267948966)
//    {
//        degree = -180;
//    }
//    else if (angle == -3.1415926535897931)
//    {
//        degree = 90;
//    }
    
    NSLog(@"%f",degree);
    
   __block UIImage *imgRotated;
    [UIView animateWithDuration:0.5 animations:^{
        
//        cell.imgCollection.transform = CGAffineTransformMakeRotation(degreesToRadians(degree));
//
//        cell.imgCollection.frame = CGRectMake(10, 16, cell.frame.size.width-20, cell.frame.size.height - 32);
//
//        cell.imgCollection.contentMode = UIViewContentModeScaleAspectFit;
        
        imgRotated =   [UIImage imageWithCGImage:[cell.imgCollection.image CGImage]
                                           scale:[cell.imgCollection.image scale]
                                     orientation: orientation];
        
    } completion:^(BOOL finished) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
//          UIImage *imgRotated =   [UIImage imageWithCGImage:[cell.imgCollection.image CGImage]
//                                    scale:[cell.imgCollection.image scale]
//                              orientation: orientation];
            
//            UIImage *imgRotated = [self imageRotatedByDegrees: [[[SharedClass sharedManager]arrCollectionImage] objectAtIndex:currentIndex] deg:degree];
            
            if (imgRotated) {
//                 cell.imgCollection.contentMode = UIViewContentModeScaleAspectFit;
//                cell.imgCollection.frame = CGRectMake(10, 16, cell.frame.size.width-20, cell.frame.size.height - 32);
                cell.imgCollection.image = imgRotated;
//                cell.imgCollection.transform = CGAffineTransformMakeRotation(degreesToRadians(0));
                
                [[[SharedClass sharedManager]arrCollectionImage] replaceObjectAtIndex:currentIndex withObject:imgRotated];
                
                [[[SharedClass sharedManager]arrMultiPages] replaceObjectAtIndex:currentIndex withObject:imgRotated];

                
                //                [collection reloadData];
            }
        });
    }];
}

#pragma mark- delete Image
-(void)clk_deleteImage
{
    [bottomBarCollection setUserInteractionEnabled:NO];
    [collection performBatchUpdates:^{
        
        NSArray *arrVisibleCells = [collection visibleCells];
        CustomCollectionCell *cell = [arrVisibleCells lastObject];
        NSIndexPath *indexPath = [collection indexPathForCell:cell];
        [[[SharedClass sharedManager]arrCollectionImage] removeObjectAtIndex:indexPath.row];
        [[[SharedClass sharedManager] arrMultiPages] removeObjectAtIndex:indexPath.row];
        
        [collection deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        currentIndex = indexPath.row;
        [[SharedClass sharedManager] setSelectedIndex:currentIndex];
        
    } completion:^(BOOL finished) {
        
        [collection reloadData];
        [bottomBarCollection setUserInteractionEnabled:YES];
        if ([[[SharedClass sharedManager]arrCollectionImage]count] == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    if ([[[SharedClass sharedManager]arrCollectionImage]count] == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}




#pragma mark- Save PDF File

-(void)clk_save
{
    if ([[SharedClass sharedManager]isDocAddNewPage])
    {
        [self CratePDF];
        return;
    }
    NSString *strFilenameDB;
    /*if (isDocNameChanged) {
     if (txtTitle.text.length>0) {
     strFilenameDB = [NSString stringWithFormat:@"%@.pdf",txtTitle.text];
     }
     else{
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please enter Document Name" preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
     }];
     [alertController addAction:okAction];
     [self presentViewController:alertController animated: YES completion: nil];
     return;
     }
     }else{
     strFilenameDB = [SharedClass generateFilePathNameWithDefualtNmae:@"Doc"];
     }*/
    
    strFilenameDB = [SharedClass generateFilePathNameWithDefualtNmae:_static_doc];
    
    [self genratePDFwithImage:[[SharedClass sharedManager]arrCollectionImage] withFileName:strFilenameDB pageSize:@"A4"];
    
    
    NSString *strFilePath = [[SharedClass sharedManager]GetPDFFilePath:strFilenameDB];
    
    
    [[SharedClass sharedManager] setStrURL:strFilePath];
    
    //       [self CratePDF];
}
-(void)genratePDFwithImage:(NSArray *)arrImages withFileName:(NSString *)fileName pageSize:(NSString *)pageType
{
    CGFloat height = 0,weidth = 0;
    if ([pageType isEqualToString:@"A4"])
    {
        height = 612;
        weidth = 792;
    }
    
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        
//        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
//        [SVProgressHUD setBackgroundColor:svProgreesHUDColor];
//        [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
//        [SVProgressHUD showWithStatus:@"Creating Pdf"];
        
        [Global ShowHUDwithAnimation:YES];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // Main thread work (UI usually)
            
            @autoreleasepool {
                
                NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"PDFFiles"];
                NSString *pdfFileName = [stringPath stringByAppendingPathComponent:fileName];
                UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectMake(0, 0, weidth, height), nil);
                
                for (int i=0; i<arrImages.count; i++) {
                    
                    UIImage * myPNG = [arrImages objectAtIndex:i];
                    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0.0, myPNG.size.width, myPNG.size.height), nil);
                    [myPNG drawInRect:CGRectMake(0, 0, myPNG.size.width, myPNG.size.height)];
                }
                
                UIGraphicsEndPDFContext();
                
//                [SVProgressHUD dismiss];
                [Global HideHUDwithAnimation:YES];
                
                DocsPreviewVC *mainvc = [appDelegateObj.storyboard instantiateViewControllerWithIdentifier:@"DocsPreviewVC"];
                mainvc.filePath = pdfFileName;
                mainvc.imgFrontImage  = [arrImages objectAtIndex:0];
                mainvc.file_type = 1;
                mainvc.mime_type = @"pdf";
                [self.navigationController pushViewController:mainvc animated:YES];

            }
        }];
        
    }];
}
-(void)CratePDF
{
    //    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
    //
    //        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    //        [SVProgressHUD setBackgroundColor:svProgreesHUDColor];
    //        [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    //        [SVProgressHUD showWithStatus:@"Adding pages in Pdf"];
    //
    //    }];
    NSURL *url = [NSURL fileURLWithPath:[[SharedClass sharedManager] strURL]];
    CGPDFDocumentRef  SourcePDFDocument = CGPDFDocumentCreateWithURL((CFURLRef)url);
    size_t numberOfPages = CGPDFDocumentGetNumberOfPages(SourcePDFDocument);
    
    NSMutableArray * arrImagesFromPDF = [NSMutableArray new];
    for (int i=1; i<=numberOfPages; i++) {
        UIImage * image = [UIImage imageWithPDFURL:url atSize:CGSizeMake( 612, 792 ) atPage:i];
        
        [arrImagesFromPDF addObject:image];
        image = nil;
    }
    
    for (UIImage * img  in [[SharedClass sharedManager]arrCollectionImage]) {
        [arrImagesFromPDF addObject:img];
    }
    
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    BOOL success = [fm removeItemAtPath:[[SharedClass sharedManager]strURL] error:&error];
    
    if (success) {
        UIGraphicsBeginPDFContextToFile([[SharedClass sharedManager]strURL], CGRectMake(0, 0, 612   , 792), nil);
        
        for (int i=0; i<arrImagesFromPDF.count; i++) {
            
            UIImage * myPNG = [arrImagesFromPDF objectAtIndex:i];
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0.0, myPNG.size.width, myPNG.size.height), nil);
            [myPNG drawInRect:CGRectMake(0, 0, myPNG.size.width, myPNG.size.height)];
        }
        
        UIGraphicsEndPDFContext();
    }
    
    [[[SharedClass sharedManager]arrCollectionImage] removeAllObjects];
    [[[SharedClass sharedManager] dictCollectionImageRotationDegree] removeAllObjects];
    [[[SharedClass sharedManager] arrMultiPages] removeAllObjects];
//    [SVProgressHUD dismiss];
    [Global HideHUDwithAnimation:YES];
    for (UIViewController *viewC in self.navigationController.viewControllers)
    {
        if ([viewC isKindOfClass:[UploadDocsVC class]])
        {
            [self.navigationController popToViewController:viewC animated:YES];
        }
    }
    
    //PSPDFDocument *docSaved = [PSPDFDocument documentWithURL:[NSURL fileURLWithPath:[[SharedClass sharedManager] strURL]]];
    // [docSaved unlockWithPassword:pdfOwnerPassword];
    
    //PSPDFDocumentEditor *editor = [[PSPDFDocumentEditor alloc] initWithDocument:docSaved];
    //NSInteger pageCount = 0;//docSaved.pageCount;
    /*   for (UIImage *im in [[SharedClass sharedManager]arrCollectionImage]) {
     
     PSPDFNewPageConfiguration *newPageConfiguration = [PSPDFNewPageConfiguration newPageConfigurationWithEmptyPageBuilder:^(PSPDFNewPageConfigurationBuilder * _Nonnull builder) {
     
     builder.item = [PSPDFProcessorItem processorItemWithImage:im jpegCompressionQuality:compressQuality builderBlock:nil];
     builder.pageSize = im.size;
     
     }];
     
     [editor addPageAt:pageCount withConfiguration:newPageConfiguration];
     pageCount++;
     }
     
     // Save and overwrite the document.
     [editor saveWithCompletionBlock:^(PSPDFDocument *savedDocument, NSError *error) {
     
     
     if (error) {
     NSLog(@"Document editing failed: %@", error);
     [[[SharedClass sharedManager]arrCollectionImage] removeAllObjects];
     [[[SharedClass sharedManager] arrMultiPages] removeAllObjects];
     [SVProgressHUD dismiss];
     for (UIViewController *viewC in self.navigationController.viewControllers)
     {
     if ([viewC isKindOfClass:[ViewController class]])
     {
     [self.navigationController popToViewController:viewC animated:YES];
     }
     }
     return;
     }
     
     [[[SharedClass sharedManager]arrCollectionImage] removeAllObjects];
     [[[SharedClass sharedManager] arrMultiPages] removeAllObjects];
     
     [[NSOperationQueue mainQueue]addOperationWithBlock:^{
     [SVProgressHUD dismiss];
     
     for (UIViewController *viewC in self.navigationController.viewControllers)
     {
     if ([viewC isKindOfClass:[ViewController class]])
     {
     [self.navigationController popToViewController:viewC animated:YES];
     }
     }
     }];
     
     }];*/
}

- (UIImage *)imageRotatedByDegrees:(UIImage*)oldImage deg:(CGFloat)degrees{
    
    //Calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,oldImage.size.width, oldImage.size.height)];
    
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    
    //Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    //Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //Rotate the image context
    CGContextRotateCTM(bitmap, (degrees * M_PI / 180));
    
    //Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-oldImage.size.width / 2, -oldImage.size.height / 2, oldImage.size.width, oldImage.size.height), [oldImage CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)getOrientationOfImage:(UIImage*)image{
    switch (image.imageOrientation) {
        case UIImageOrientationUp: //Left
            NSLog(@"OrientationUp");
            break;
        case UIImageOrientationDown: //Right
              NSLog(@"OrientationDown");
            break;
        case UIImageOrientationLeft: //Down
              NSLog(@"OrientationLeft");
            break;
        case UIImageOrientationRight: //Up
              NSLog(@"OrientationRight");
            break;
        default:
            break;
    }
}

- (UIImage *)convertImageToGrayScale:(UIImage *)image {
    
    
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}




@end
