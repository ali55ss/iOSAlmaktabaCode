//
//  SharedClass.h
//  DocumentScanner
//
//  Created by TechnoMac-11 on 01/02/18.
//  Copyright © 2018 TechnoMac-11. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedClass : NSObject
/**
 store images from camera capture or gallery as orignal copy of images
 */
@property (nonatomic ,retain) NSMutableArray *arrMultiPages;

/**
 store images from camera capture or gallery for display
 */
@property (nonatomic ,retain) NSMutableArray *arrCollectionImage;

/**
 store seleted documents when select docuemtns from tableveiew or collectionview in editing mode
 */
@property (nonatomic ,retain) NSMutableArray *arrSelection;

/**
 store images rotation Deree
 */
@property (nonatomic ,retain) NSMutableDictionary *dictCollectionImageRotationDegree;


/**
 store selected documents file path in arrSelectionFile and file name in arrSelectionFileName
 */
@property (nonatomic ,retain) NSMutableArray *arrSelectionFile ,*arrSelectionFileName;

@property (nonatomic ) BOOL isQuesMrkON; // Ques mrk in camera view
@property (nonatomic ) BOOL isFirstTimeCameraOn; // Ques mrk in camera view
@property (nonatomic ) BOOL isFirstTimeCameraOnAuto; // Ques mrk in camera view

@property (nonatomic ,retain) NSMutableArray *arrPdfToImages;
@property (nonatomic ,retain) NSMutableArray *arrTempPdfToImages;

@property (nonatomic ,retain) NSArray * validProducts;  //inApp


/**
 set which controller present from camera screen
 */
@property (nonatomic ) int pages;

/**
 set array index for images in filtervc
 */
@property (nonatomic) NSInteger selectedIndex;

/**
 integer tag for cropview controller
 */
@property (nonatomic) NSInteger cropVCtag;

@property (nonatomic) NSInteger MoveVCtag;

/**
 Documents local path url seltected
 */
@property (nonatomic ,retain) NSString *strURL;


/**
 document file name for display file in imageshowvc
 */
@property (nonatomic ,retain) NSString *strFileName;


/**
 Represent image orieantion when detect document
 */
@property (nonatomic) UIImageOrientation orientationImage;

/**
 camera view page tag
 */
@property (nonatomic ) NSInteger cameraPageGTag;

/**
 set boolean when click on add button in saved document
 */
@property (nonatomic ) BOOL isDocAddNewPage;


/**
 store folder id when go to folder in files
 */
@property (nonatomic )NSInteger folderId;

/**
 store document dictonary
 */
@property (nonatomic ,retain) NSDictionary *dictPDF;

@property (nonatomic ) BOOL isAutometicCapture;

@property (nonatomic ) BOOL isExportAs;  // 0 = pdf / 1 = jpg


/**
 singleton class sharemanager object method
 
 @return singleton class object
 */
+ (id)sharedManager;


/**
 use method for convert document file name with template
 
 @return filename as NSString
 */
+(NSString*)pdfFileNamewithTemplate;

/**
 convert local date and time to nsstring
 
 @param defaultName any string for temporary name
 @return file name as string
 */
+ (NSString*)generateFileNameWithDefualtNmae:(NSString *)defaultName;

/**
 convert local date and time to nsstring as database format
 
 @param defaultName any string for temporary name
 @return file name as string
 */
+ (NSString*)generateFilePathNameWithDefualtNmae:(NSString *)defaultName;

/**
 create 'PDFfiles' folder in document directory of local device when app install first time in device
 
 @return Yes:folder is created,NO:already created
 */
-(BOOL)isCreatePdfFilesFolderInDocuement;
-(BOOL)isRemovePdfFilesFolderInDocuement;
-(BOOL)isCreateFolderInDocuementForArchiveDocumets;
- (NSString *)documentsPath;
/**
 get local document directory path for saved docuements name in local storage sqlite database
 
 @param fileName store in local device storage
 @return full local documents path of file
 */
-(NSString *)GetPDFFilePath:(NSString *)fileName;
-(BOOL)isInternetAvailable;


/**
 save document details when "upload your docs" btn click
 */
@property (strong,nonatomic) NSString * deptCourse_id;
@property (strong,nonatomic) NSString * documentTitle;
@property (strong,nonatomic) NSString * documentDescription;




/**
 This below all bool refresh screen like (document feed);
 */

@property (assign) BOOL isUploadNewDocument;

/**
 Check Guest user tap on Profile and Settings button from side bar menu
 */

@property (assign ) BOOL isGuestTapOnProfileOrSettings;  

@end

