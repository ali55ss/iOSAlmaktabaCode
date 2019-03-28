//
//  SharedClass.m
//  DocumentScanner
//
//  Created by TechnoMac-11 on 01/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import "SharedClass.h"

@implementation SharedClass
#pragma mark Singleton Methods

+ (id)sharedManager {
    static SharedClass *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    if (self = [super init]) {
        // alloc or set object
        self.arrMultiPages  = [[NSMutableArray alloc]init];
        self.arrCollectionImage = [[NSMutableArray alloc]init];
        self.dictCollectionImageRotationDegree = [[NSMutableDictionary alloc] init];
        self.arrSelection = [[NSMutableArray alloc]init];
        self.arrSelectionFile = [[NSMutableArray alloc]init];
        self.arrSelectionFileName = [[NSMutableArray alloc]init];
        self.arrPdfToImages = [NSMutableArray new];
        self.arrTempPdfToImages = [[NSMutableArray alloc]init];
        self.dictPDF = [[NSDictionary alloc]init];
        self.folderId = 0;
        self.isExportAs = 0;
        self.isQuesMrkON = YES;
        self.isFirstTimeCameraOn = YES;
        self.validProducts = [NSArray new];
    }
    return self;
}

+(NSString*)pdfFileNamewithTemplate
{
    NSMutableArray *arr = [[NSUserDefaults standardUserDefaults]valueForKey:@"file_nFormat"];
    
    if (arr == nil || arr.count == 0) {
        
        return [SharedClass generateFileNameWithDefualtNmae:_static_doc];
    }
    else
    {
        NSString *strtemp = @"";
        NSString *strFileNameFormat = @"";
        for (NSDictionary *dict in arr) {
            
            for (NSString *key in dict) {
                
                NSString *strVal = [dict valueForKey:key];
                
                if ([strVal isEqual:@"MMM dd,yyyy"]) {
                    
                    NSDate *time = [NSDate date];
                    NSDateFormatter* df = [NSDateFormatter new];
                    [df setDateFormat:@"MMM dd,yyyy"];
                    NSString *timeString = [df stringFromDate:time];
                    strtemp = timeString;
                }
                else if ([strVal isEqual:@"HH:mm a "])
                {
                    NSDate *time = [NSDate date];
                    NSDateFormatter* df = [NSDateFormatter new];
                    [df setDateFormat:@"HH:mm a"];
                    NSString *timeString = [df stringFromDate:time];
                    strtemp = timeString;
                }
                else
                {
                    strtemp =  [dict valueForKey:key];
                }
            }
            
            if (strFileNameFormat.length > 0) {
                
                strFileNameFormat = [NSString stringWithFormat:@"%@%@",strFileNameFormat,strtemp];
            }
            else
            {
                strFileNameFormat = [NSString stringWithFormat:@"%@",strtemp];
            }
        }
        
        return strFileNameFormat;
    }
}

+ (NSString*)generateFileNameWithDefualtNmae:(NSString *)defaultName
{
    NSDate *time = [NSDate date];
    NSDateFormatter* df = [NSDateFormatter new];
    [df setDateFormat:@"MMM dd,yyyy, hh:mm a"];
    NSString *timeString = [df stringFromDate:time];
    NSString *fileName = [NSString stringWithFormat:@"%@ %@", defaultName,timeString];
    
    return fileName;
}

+ (NSString*)generateFilePathNameWithDefualtNmae:(NSString *)defaultName
{
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];

    NSDate *time = [NSDate date];
    NSDateFormatter* df = [NSDateFormatter new];
    df.locale = usLocale;
    [df setDateFormat:@"dd-MMM-yyyy-HH-mm-ss"];
    NSString *timeString = [df stringFromDate:time];
    NSString *fileName = [NSString stringWithFormat:@"%@-%@.pdf", defaultName,timeString];
    
    return fileName;
}

-(void)genratePDFwithImage:(NSArray *)arrImages withFileName:(NSString *)fileName pageSize:(NSString *)pageType
{
    CGFloat height = 0,weidth = 0;
    if ([pageType isEqualToString:@"A4"])
    {
        height = 612;
        weidth = 792;
    }
    CGSize pageSize = CGSizeMake(weidth*5, height*5+30);
    NSLog(@"page size %@",NSStringFromCGSize(pageSize));
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFileName = [documentsDirectory stringByAppendingPathComponent:fileName];
    UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectMake(0, 0, weidth, height), nil);
    
    for (int i=0; i<arrImages.count; i++) {
        UIImage * myPNG = [arrImages objectAtIndex:i];
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0.0, myPNG.size.width, myPNG.size.height), nil);
        [myPNG drawInRect:CGRectMake(0, 0, myPNG.size.width, myPNG.size.height)];
    }
    
    UIGraphicsEndPDFContext();
}

-(BOOL)isCreatePdfFilesFolderInDocuement
{
    NSError *error;
    
    NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"/PDFFiles"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])//
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:stringPath withIntermediateDirectories:NO attributes:nil error:&error];
        
        return YES;
    }
    
    return NO;
}

-(BOOL)isRemovePdfFilesFolderInDocuement
{
    NSError *error;
    
    NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"/PDFFiles"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:stringPath])//
    {
        [[NSFileManager defaultManager] removeItemAtPath:stringPath error:&error];
        return YES;
    }
    return NO;
}
-(BOOL)isCreateFolderInDocuementForArchiveDocumets
{
    
    NSString *stringPath = [[self documentsPath] stringByAppendingPathComponent:@"/Archive Documents"];
  return  [FCFileManager createDirectoriesForPath:stringPath];

    
//    if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])//
//    {
//        [[NSFileManager defaultManager] createDirectoryAtPath:stringPath withIntermediateDirectories:NO attributes:nil error:&error];
//
//        return YES;
//    }
//
//    return NO;
}
- (NSString *)documentsPath
{
    static NSString *sharedDocumentsDirectoryPath = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedDocumentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    });
    return sharedDocumentsDirectoryPath;
}


-(NSString *)GetPDFFilePath:(NSString *)fileName
{
    if (![self checkPDFFilesExistAtDocumentDirecory])
    {
    }
    
    NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"PDFFiles"];
    NSString *filePath = [stringPath stringByAppendingPathComponent:fileName];
    
    return filePath;
}

-(BOOL)checkPDFFilesExistAtDocumentDirecory
{
    //    NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"/PDFFiles"];
    //
    //    if ([[NSFileManager defaultManager] fileExistsAtPath:stringPath])//
    //    {
    //        return YES;
    //    }
    
    return NO;
}

-(BOOL)isInternetAvailable{
    BOOL isNetAvailable = NO;
    
    //    Reachability *reach = [Reachability reachabilityWithHostName: @"www.google.com"];
    //    NetworkStatus netStatus = [reach currentReachabilityStatus];
    //    if (netStatus != NotReachable)
    //    {
    //        isNetAvailable = YES;
    //    }
    //    else
    //    {
    //        isNetAvailable = NO;
    //    }
    return  isNetAvailable;
}

#pragma mark - Change orientation

@end

