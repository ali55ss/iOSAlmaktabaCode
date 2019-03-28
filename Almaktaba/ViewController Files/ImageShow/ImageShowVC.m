//
//  ImageShowVC.m
//  DocumentScanner
//
//  Created by TechnoMac-11 on 02/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "ImageShowVC.h"
#import "EditPageCustomCell.h"
@interface ImageShowVC ()

@end

@implementation ImageShowVC
#pragma mark- config
-(void)config{
    
}
#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self config];
    [self setupCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- setupCollection view
-(void)setupCollectionView{
    collectionvwMain.contentOffset = CGPointZero;
    
    [collectionvwMain setNeedsLayout];
    
    [collectionvwMain registerNib:[UINib nibWithNibName:@"EditPageCustomCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    [collectionvwMain setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];

}
-(void)getImages{
    if ([[SharedClass sharedManager]strURL] != nil || ![[[SharedClass sharedManager]strURL] isEqualToString:@""]) {
        
        NSURL *url = [NSURL fileURLWithPath:[[SharedClass sharedManager] strURL]];
        
        CGPDFDocumentRef  SourcePDFDocument = CGPDFDocumentCreateWithURL((CFURLRef)url);
        
        size_t numberOfPages = CGPDFDocumentGetNumberOfPages(SourcePDFDocument);
        
        arrImagesFromPDF = [NSMutableArray new];
        for (int i=1; i<=numberOfPages; i++) {
            UIImage * image = [UIImage imageWithPDFURL:url atSize:CGSizeMake( 612, 792 ) atPage:i];
            
            [arrImagesFromPDF addObject:image];
            image = nil;
        }
//        currentIndex = 0;
    }
}
#pragma mark- Action Methods




#pragma mark - UICollectionView Datasource & Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize cellSize = CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
    
    return cellSize;
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
     return arrImagesFromPDF.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        [collectionView registerNib:[UINib nibWithNibName:@"EditPageCustomCell" bundle:nil] forCellWithReuseIdentifier:[NSString stringWithFormat:@"cell%ld",(long)indexPath.row]];
        
        EditPageCustomCell *cell = (EditPageCustomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"cell%ld",(long)indexPath.row] forIndexPath:indexPath];
        
        UIImage * __block image;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            image = [arrImagesFromPDF objectAtIndex:indexPath.row];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                cell.imgview.image = image;
                image = nil;
            });
        });
        return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
//    [btnColorSelect setBackgroundColor:[colors objectAtIndex:indexPath.row]];
//    colorSelected = [colors objectAtIndex:indexPath.row];
    
    //    arrSetArrowUnderTitle = [NSMutableArray new];
    //    [arrSetArrowUnderTitle addObject:indexPath];
    //
    //    NSIndexPath *IndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //    ProgressCollectionCell *cell= [_collectionView cellForItemAtIndexPath:IndexPath];
    
}
@end
