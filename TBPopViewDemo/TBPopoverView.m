//
//  TBPopoverView.m
//  TBPopoverView
//
//  Created by ThornVBear on 16/9/7.
//  Copyright © 2016年 ThornDemo. All rights reserved.
//
#import "TBPopoverView.h"


#define kArrowHeight 10.0f
#define kArrowCurvature 6.0f
#define SPACE 2.0f
#define DEFAULT_ROW_HEIGHT 44.0f
#define DEFAULT_FONT_SIZE 16.0f
#define DEFAULT_SPACE_MARGIN 10.f

#define iOSVersion [[UIDevice currentDevice].systemVersion floatValue]
#define TITLE_FONT(fontSize) [UIFont systemFontOfSize:(fontSize)]
#define RGB(r, g, b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
@interface TBPopoverView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic) CGPoint showPoint;
@property (assign, nonatomic) CGFloat popWidth;

@property (nonatomic, strong) UIButton *handerView;

@end

@implementation TBPopoverView


-(id)initWithPoint:(CGPoint)point popWidth:(CGFloat)width
{
    self = [super init];
    if (self) {
        self.borderColor = RGB(200, 199, 204);
        self.backgroundColor = [UIColor clearColor];
        
        self.fontSize = DEFAULT_FONT_SIZE;
        self.cellHeight = DEFAULT_ROW_HEIGHT;
        self.showPoint = point;
        self.popWidth = width;
        self.frame = [self fetchViewFrame];
        [self addSubview:self.tableView];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
//    border color
    [self.borderColor set];
    CGRect frame = CGRectMake(0, kArrowHeight, self.bounds.size.width,self.bounds.size.height - kArrowHeight );
    
    float xMin = CGRectGetMinX(frame);
    float yMin = CGRectGetMinY(frame);
    float xMax = CGRectGetMaxX(frame);
    float yMax = CGRectGetMaxY(frame);
    
    CGPoint arrowPoint = [self convertPoint:self.showPoint fromView:_handerView];
    switch (_popArrowDirection) {
        case PopArrowDirectionLeft:
            arrowPoint = CGPointMake(xMin+kArrowHeight+DEFAULT_SPACE_MARGIN, arrowPoint.y);
            break;
        case PopArrowDirectionMiddle:
            
            break;
        case PopArrowDirectionRight:
            arrowPoint = CGPointMake(xMax-kArrowHeight-DEFAULT_SPACE_MARGIN, arrowPoint.y);
            break;
            
        default:
            break;
    }
    UIBezierPath *popoverPath = [UIBezierPath bezierPath];
    // start point
    [popoverPath moveToPoint:CGPointMake(xMin, yMin)];
    /********************Arrow**********************/
    //   Draw Line to the arrow's first inflexion point
    [popoverPath addLineToPoint:CGPointMake(arrowPoint.x - kArrowHeight, yMin)];
    
    /*
     Draw Cubic Bezeir Curve From above end point to arrowPoint with two control points
     that are point1 and point2
     */
    [popoverPath addCurveToPoint:arrowPoint
                   controlPoint1:CGPointMake(arrowPoint.x - kArrowHeight + kArrowCurvature, yMin)
                   controlPoint2:arrowPoint];
    
    [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x + kArrowHeight, yMin)
                   controlPoint1:arrowPoint
                   controlPoint2:CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMin)];
    /********************Arrow**********************/
    
    //top right corner
    [popoverPath addLineToPoint:CGPointMake(xMax, yMin)];
    //bottom right corner
    [popoverPath addLineToPoint:CGPointMake(xMax, yMax)];
    //bottom left corner
    [popoverPath addLineToPoint:CGPointMake(xMin, yMax)];
    
    //fill color
    [[UIColor darkGrayColor] setFill];
    [popoverPath fill];
    
    [popoverPath closePath];
    [popoverPath stroke];
}

#pragma mark - setter and getter
/**
 *  set PopArrowDirection
 *
 *  @param popArrowDirection
 */
- (void)setPopArrowDirection:(TBPopArrowDirection)popArrowDirection{
    _popArrowDirection = popArrowDirection;
}

- (void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
}

- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
}

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
}

-(CGRect)fetchViewFrame
{
    CGRect frame = CGRectZero;
    frame.size.height =  _titleArray.count * _cellHeight + SPACE + kArrowHeight;
    
    for (NSString *title in self.titleArray) {
        CGFloat width = 0.0;
        //      wipe deprecated method warning
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if (iOSVersion<=7.0) {
            width =  [title sizeWithFont:TITLE_FONT(_fontSize)
                       constrainedToSize:CGSizeMake(300, 100)
                           lineBreakMode:NSLineBreakByCharWrapping].width;
        }else{
            NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:DEFAULT_FONT_SIZE]};
            CGSize size = [title boundingRectWithSize:CGSizeMake(300, 100)
                                              options: NSStringDrawingTruncatesLastVisibleLine |
                           NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:attribute context:nil].size;
            width = size.width;
        }
#pragma clang diagnostic pop
        
        frame.size.width = MAX(width, frame.size.width);
    }
    frame.size.width = _popWidth;
    
    frame.origin.x = self.showPoint.x - frame.size.width/2;
    frame.origin.y = self.showPoint.y;
    
    //left gap  min 5x
    if (frame.origin.x < 5) {
        frame.origin.x = 5;
    }
    //right gap min 5x
    if ((frame.origin.x + frame.size.width) > ([UIScreen mainScreen].bounds.size.width - 5)) {
        frame.origin.x = ([UIScreen mainScreen].bounds.size.width - 5) - frame.size.width;
    }
    
    return frame;
}

-(UITableView *)tableView
{
    if (_tableView != nil) {
        return _tableView;
    }
    CGRect rect = self.frame;
    rect.origin.x = SPACE;
    rect.origin.y = kArrowHeight + SPACE;
    rect.size.width -= SPACE * 2;
    rect.size.height = CGRectGetHeight(rect)-(SPACE + kArrowHeight)-1;
    
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alwaysBounceHorizontal = NO;
    _tableView.alwaysBounceVertical = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = RGB(104,104,104);
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    return _tableView;
}

#pragma mark - Methods
/**
 *  show popView
 */
-(void)showWithAnimate:(BOOL)animate
{
    _handerView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_handerView setFrame:[UIScreen mainScreen].bounds];
    [_handerView setBackgroundColor:[UIColor clearColor]];
    [_handerView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_handerView addSubview:self];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:_handerView];
    
    CGPoint arrowPoint = [self convertPoint:self.showPoint fromView:_handerView];
    self.layer.anchorPoint = CGPointMake(arrowPoint.x / self.frame.size.width, arrowPoint.y / self.frame.size.height);
    self.frame = [self fetchViewFrame];
    
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    if (animate) {
        [UIView animateWithDuration:0.2f
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
                             self.alpha = 1.f;
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.08f
                                                   delay:0.f
                                                 options:UIViewAnimationOptionCurveEaseInOut
                                              animations:^{
                                                  self.transform = CGAffineTransformIdentity;
                                              } completion:nil];
                         }];
    }else{
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.alpha = 1.f;
        self.transform = CGAffineTransformIdentity;
    }
    
}
/**
 *  dismiss popView
 */
-(void)dismiss
{
    [self dismiss:YES];
}
/**
 *  dismiss popView with animate?
 *
 *  @param animate
 */
-(void)dismiss:(BOOL)animate
{
    if (!animate) {
        [_handerView removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_handerView removeFromSuperview];
    }];
    
}


#pragma mark - UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
    }
    
    cell.backgroundView = [[UIView alloc] init];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    
    if ([_imageArray count] == [_titleArray count]) {
        cell.imageView.image = [UIImage imageNamed:[_imageArray objectAtIndex:indexPath.row]];
    }
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:_fontSize];
    cell.textLabel.textColor = _fontColor;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    if (iOSVersion >= 7.0) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.selectRowAtIndex) {
        self.selectRowAtIndex(indexPath.row);
    }
    [self dismiss:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}






@end
