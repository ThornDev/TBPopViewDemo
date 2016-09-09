//
//  TBPopoverView.h
//  TBPopoverView
//
//  Created by ThornVBear on 16/9/7.
//  Copyright © 2016年 ThornDemo. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,TBPopArrowDirection){
    PopArrowDirectionLeft,
    PopArrowDirectionMiddle,
    PopArrowDirectionRight
};

@interface TBPopoverView : UIView

-(id)initWithPoint:(CGPoint)point popWidth:(CGFloat)width;
-(void)showWithAnimate:(BOOL)animate;
-(void)dismiss;
-(void)dismiss:(BOOL)animated;

@property (nonatomic, copy) UIColor *borderColor;
@property (nonatomic, copy) void (^selectRowAtIndex)(NSInteger index);


@property (assign, nonatomic) TBPopArrowDirection popArrowDirection;
@property (assign, nonatomic) CGFloat fontSize;
@property (strong, nonatomic) UIColor *fontColor;
@property (assign, nonatomic) CGFloat cellHeight;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;

@end
