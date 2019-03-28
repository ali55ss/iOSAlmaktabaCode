//
//  CameraControl.h
//  iWALLET
//
//  Created by Pradip on 10/29/17.
//  Copyright © 2017 Pradip Sutariya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraControl : NSObject
BOOL PresentPhotoCamera(id target, BOOL canEdit);
BOOL PresentVideoCamera(id target, BOOL canEdit);
BOOL PresentMultiCamera(id target, BOOL canEdit);
BOOL PresentPhotoLibrary(id target, BOOL canEdit);
BOOL PresentVideoLibrary(id target, BOOL canEdit);
@end
