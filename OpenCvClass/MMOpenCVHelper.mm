//
//  MMOpenCVHelper.m
//  MMCamScanner
//
//  Created by mukesh mandora on 09/06/15.
//  Copyright (c) 2015 madapps. All rights reserved.
//

#import "MMOpenCVHelper.h"

@implementation MMOpenCVHelper
+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
    
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                     // Width
                                        cvMat.rows,                                     // Height
                                        8,                                              // Bits per component
                                        8 * cvMat.elemSize(),                           // Bits per pixel
                                        cvMat.step[0],                                  // Bytes per row
                                        colorSpace,                                     // Colorspace
                                        kCGImageAlphaNone | kCGBitmapByteOrderDefault,  // Bitmap info flags
                                        provider,                                       // CGDataProviderRef
                                        NULL,                                           // Decode
                                        false,                                          // Should interpolate
                                        kCGRenderingIntentDefault);                     // Intent
    
    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return image;
}

+ (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols,rows;
    if  (image.imageOrientation == UIImageOrientationLeft
         || image.imageOrientation == UIImageOrientationRight) {
        cols = image.size.height;
        rows = image.size.width;
    }
    else{
        cols = image.size.width;
        rows = image.size.height;
 
    }
    
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    
    cv::Mat cvMatTest;
    cv::transpose(cvMat, cvMatTest);
    
    if  (image.imageOrientation == UIImageOrientationLeft
         || image.imageOrientation == UIImageOrientationRight) {
       
    }
    else{
        return cvMat;
       
    }
    cvMat.release();
    
    cv::flip(cvMatTest, cvMatTest, 1);
    
    
    return cvMatTest;
}

+ (cv::Mat)cvMatFromAdjustedUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    return cvMat;
}

+ (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image
{
    cv::Mat cvMat = [self cvMatFromUIImage:image];
    cv::Mat grayMat;
    if ( cvMat.channels() == 1 ) {
        grayMat = cvMat;
    }
    else {
        grayMat = cv :: Mat( cvMat.rows,cvMat.cols, CV_8UC1 );
        cv::cvtColor( cvMat, grayMat, cv::COLOR_BGR2GRAY );
    }
    return grayMat;
}

+ (cv::Mat)cvMatGrayFromAdjustedUIImage:(UIImage *)image
{
    cv::Mat cvMat = [self cvMatFromAdjustedUIImage:image];
    cv::Mat grayMat;
    if ( cvMat.channels() == 1 ) {
        grayMat = cvMat;
    }
    else {
        grayMat = cv :: Mat( cvMat.rows,cvMat.cols, CV_8UC1 );
        cv::cvtColor( cvMat, grayMat, cv::COLOR_BGR2GRAY );
    }
    return grayMat;
}

void CalcBlockMeanVariance(cv::Mat& Img,cv::Mat& Res,float blockSide=21) // blockSide - the parameter (set greater for larger font on image)
{
    cv::Mat I;
    Img.convertTo(I,CV_32FC1);
    Res=cv::Mat::zeros(Img.rows/blockSide,Img.cols/blockSide,CV_32FC1);
    cv::Mat inpaintmask;
    cv::Mat patch;
    cv::Mat smallImg;
    cv::Scalar m,s;
    
    for(int i=0;i<Img.rows-blockSide;i+=blockSide)
    {
        for (int j=0;j<Img.cols-blockSide;j+=blockSide)
        {
            patch=I(cv::Range(i,i+blockSide+1),cv::Range(j,j+blockSide+1));
            cv::meanStdDev(patch,m,s);
            if(s[0]>0.01) // Thresholding parameter (set smaller for lower contrast image)
            {
                Res.at<float>(i/blockSide,j/blockSide)=m[0];
            }else
            {
                Res.at<float>(i/blockSide,j/blockSide)=0;
            }
        }
    }
    
    //cv::resize(I,smallImg,Res.size());
    
    cv::threshold(Res,inpaintmask,0.02,1.0,cv::THRESH_BINARY);
    
    cv::Mat inpainted;
    smallImg.convertTo(smallImg,CV_8UC1,255);
    
    inpaintmask.convertTo(inpaintmask,CV_8UC1);
    // inpaint(smallImg, inpaintmask, inpainted, 5, INPAINT_TELEA);
    
    
   // cv::resize(inpainted,Res,Img.size());
    Res.convertTo(Res,CV_32FC1,1.0/255.0);
    
}
//Image Processing
+(UIImage *)grayImage:(UIImage *)processedImage{ // B/W

    cv::Mat grayImage = [MMOpenCVHelper cvMatGrayFromAdjustedUIImage:processedImage];
    // cv::threshold(grayImage, grayImage, 122, 255, cv::THRESH_BINARY+cv::THRESH_OTSU);
    cv::adaptiveThreshold(grayImage, grayImage, 255, cv::ADAPTIVE_THRESH_MEAN_C, cv::THRESH_BINARY, 11, 7);
    cv::GaussianBlur(grayImage, grayImage, cv::Size(1,1), 50.0);
    
    UIImage *grayeditImage=[MMOpenCVHelper UIImageFromCVMat:grayImage];
    grayImage.release();
    
    return grayeditImage;

   /* cv::Mat grayImage = [MMOpenCVHelper cvMatGrayFromAdjustedUIImage:processedImage];

    
    cv::GaussianBlur(grayImage, grayImage, cv::Size(1,1), 50.0);
    
   // cv::medianBlur(grayImage, grayImage,7);
    
    int blockDim=MIN( grayImage.size().height/4, grayImage.size().width/4);
    if(blockDim % 2 != 1) blockDim++;
    
    cv::adaptiveThreshold(grayImage, grayImage, 255, cv::ADAPTIVE_THRESH_MEAN_C, cv::THRESH_BINARY, blockDim, 10);
    
     //cv2.threshold(img,127,255,cv2.THRESH_BINARY)
    // adaptiveThreshold(grayImage,255,cv::ADAPTIVE_THRESH_MEAN_C,
  //                     cv::THRESH_BINARY,11,2);
   // th3 = cv2.adaptiveThreshold(img,255,cv2.ADAPTIVE_THRESH_GAUSSIAN_C,\
                                cv2.THRESH_BINARY,11,2)
    
    UIImage *grayeditImage=[MMOpenCVHelper UIImageFromCVMat:grayImage];
    grayImage.release();
    
    return grayeditImage;*/
    
}

+(UIImage *)magicColor:(UIImage *)processedImage{
    cv::Mat  original = [MMOpenCVHelper cvMatFromAdjustedUIImage:processedImage];
    
    cv::Mat new_image = cv::Mat::zeros( original.size(), original.type() );
    
    original.convertTo(new_image, -1, 1.9, 80);
    
    original.release();
    UIImage *magicColorImage=[MMOpenCVHelper UIImageFromCVMat:new_image];
    new_image.release();
    return magicColorImage;
    
    
}

+(UIImage *)blackandWhite:(UIImage *)processedImage //gray
{
    
    cv::Mat original = [MMOpenCVHelper cvMatGrayFromAdjustedUIImage:processedImage];
    
    cv::Mat new_image = cv::Mat::zeros( original.size(), original.type() );
    
    original.convertTo(new_image, -1, 1.4, -50);
    original.release();
    
    UIImage *blackWhiteImage=[MMOpenCVHelper UIImageFromCVMat:new_image];
    new_image.release();
    
    return blackWhiteImage;
}
+(cv::Mat)CVGrayscaleMat:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat = cv::Mat(rows, cols, CV_8UC1); // 8 bits per component, 1 channel
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
                                                    cols,                      // Width of bitmap
                                                    rows,                     // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNone |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}

+ (UIImage*) processHistogram:(UIImage*)src{
    
    ImageProcessor processor;
    cv::Mat source=[self CVGrayscaleMat:src];
    cv::Mat output=processor.equalize(source);
    UIImage *equalized=[MMOpenCVHelper UIImageFromCVMat:output];
    return equalized;
    
}

+ (UIImage*) processFilter:(UIImage*)src{
    
    ImageProcessor processor;
    cv::Mat source=[self CVGrayscaleMat:src];
    cv::Mat output=processor.filterMedianSmoot(source);
    UIImage *filtered=[MMOpenCVHelper UIImageFromCVMat:output];
    return filtered;
    
}

+ (UIImage*) processBinarize:(UIImage*)src{
    
    ImageProcessor processor;
    cv::Mat source=[self CVGrayscaleMat:src];
    processor.filterGaussian(source);
    cv::Mat output=processor.binarize(source);
    UIImage *binarized=[MMOpenCVHelper UIImageFromCVMat:output];
    return binarized;
}


@end
