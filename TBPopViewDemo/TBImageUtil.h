//
//  TBImageUtil.h
//  TBPopViewDemo
//
//  Created by 思来氏 on 16/9/8.
//  Copyright © 2016年 ThornDemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TBImageUtil : NSObject

+ (UIImage *)blurryImage:(UIImage *)image
           withBlurLevel:(CGFloat)blur;

+(UIImage *)blurryGPUImageWithImage:(UIImage *)image withBlurLevel:(CGFloat)blur;
+(UIImage *)blurryVImageWithImage:(UIImage *)image withBlurHeight:(CGFloat)blur;
@end
