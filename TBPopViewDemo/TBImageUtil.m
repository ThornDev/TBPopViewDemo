//
//  TBImageUtil.m
//  TBPopViewDemo
//
//  Created by 思来氏 on 16/9/8.
//  Copyright © 2016年 ThornDemo. All rights reserved.
//

#import "TBImageUtil.h"
#import <CoreImage/CoreImage.h>
#import <Accelerate/Accelerate.h>
#import "GPUImage.h"
#import "UIImage+ImageEffects.h"
@implementation TBImageUtil


//Core Image
+ (UIImage *)blurryImage:(UIImage *)image
           withBlurLevel:(CGFloat)blur {
    // 创建基于GPU的CIContext对象
        CIContext* context=[CIContext contextWithOptions:nil];
    // 创建基于CPU的CIContext对象
//    CIContext* context = [CIContext contextWithOptions: [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:kCIContextUseSoftwareRenderer]];
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@(blur) forKey: @"inputRadius"];
    CIImage *outputImage = filter.outputImage;
    CGImageRef outImage = [context createCGImage:outputImage
                                        fromRect:[outputImage extent]];
    
    return [UIImage imageWithCGImage:outImage];
}

+(UIImage *)blurryGPUImageWithImage:(UIImage *)image withBlurLevel:(CGFloat)blur{
    GPUImageGaussianBlurFilter * blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = blur;
    UIImage *blurredImage = [blurFilter imageByFilteringImage:image];
    return blurredImage;
}

+(UIImage *)blurryVImageWithImage:(UIImage *)image withBlurHeight:(CGFloat)blur{
    // blur Image at specified frame
    UIImage *tpimage    = [image blurImageAtFrame:CGRectMake(0, 0, image.size.width, image.size.height * blur)];
    return  tpimage;
}

@end
