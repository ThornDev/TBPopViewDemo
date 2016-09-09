//
//  ViewController.m
//  TBPopViewDemo
//
//  Created by 思来氏 on 16/9/7.
//  Copyright © 2016年 ThornDemo. All rights reserved.
//

#import "ViewController.h"
#import "TBPopoverView.h"
#import "TBImageUtil.h"
@interface ViewController ()
{
    UIImageView * imageview;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"c"]];
    imageview.userInteractionEnabled = YES;
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    imageview.frame = CGRectMake(0, 80, 181, 175);
    [self.view addSubview:imageview];
    
}
- (IBAction)showPopViewAction:(UIButton *)sender {
    CGRect buttonFrame = sender.frame;
    CGPoint point = CGPointMake(CGRectGetMinX(buttonFrame), CGRectGetMaxY(buttonFrame));
    NSArray *titles = @[@"未评", @"初级", @"中级",@"高级"];
    NSArray *images = @[@"1", @"2", @"3",@"4"];
    TBPopoverView *pop = [[TBPopoverView alloc] initWithPoint:point popWidth:200];
    [pop setTitleArray:titles];
    [pop setImageArray:images];
    [pop setPopArrowDirection:PopArrowDirectionRight];
    [pop setFontSize:18.0f];
    [pop setFontColor:[UIColor whiteColor]];
    
    pop.selectRowAtIndex = ^(NSInteger index){
        [sender setTitle:titles[index] forState:UIControlStateNormal];
    };
    [pop showWithAnimate:NO];
}
- (IBAction)sliderAction:(UISlider *)sender {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [imageview setImage:[TBImageUtil blurryImage:[UIImage imageNamed:@"c"]
//                                       withBlurLevel:sender.value]];
        [imageview setImage:[TBImageUtil blurryGPUImageWithImage:[UIImage imageNamed:@"c"] withBlurLevel:sender.value]];
//        [imageview setImage:[TBImageUtil blurryVImageWithImage:[UIImage imageNamed:@"c"] withBlurHeight:sender.value]];
//    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
