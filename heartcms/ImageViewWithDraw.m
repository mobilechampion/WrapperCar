//
//  ImageViewWithDraw.m
//  DemoSelectionApp
//
//  Created by Nguyen Thanh Hung on 9/14/14.
//  Copyright (c) 2014 NguyenHung. All rights reserved.
//

#import "ImageViewWithDraw.h"
#import <QuartzCore/QuartzCore.h>

#import "UIColor+Util.h"

#define kHideDraw       @"kHideDraw"

#define LineColor       [UIColor colorWithRed: 0.114 green: 0.114 blue: 1 alpha: 1];

static CGFloat const DEFAULT_CONTROL_POINT_SIZE = 50;

CGRect SquareCGRectAtCenter(CGFloat centerX, CGFloat centerY, CGFloat size) {
    CGFloat x = centerX - DEFAULT_CONTROL_POINT_SIZE / 2;
    CGFloat y = centerY - DEFAULT_CONTROL_POINT_SIZE / 2;
    return CGRectMake(x, y, size, size);
}

double DistanceTwoPoint(CGPoint p1, CGPoint p2){
    double distance = sqrt ( pow((p1.x - p2.x), 2) + pow((p1.y - p2.y), 2) );
    
    return distance;
}



@interface DrawPath : NSObject

@property (strong, nonatomic) NSMutableArray *nodes;
@property (strong, nonatomic) UIBezierPath *bezierPath;
@property (strong, nonatomic) UIColor *lineColor;
@property (strong, nonatomic) UIColor *fillColor;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) BOOL isSelected;
@property (assign, nonatomic) BOOL isClosed;
@property (assign, nonatomic) CGFloat hueValue;
@property (assign, nonatomic) CGFloat saturationValue;

- (void)addNode:(NodeView *)node;
- (void)endAddNode;
- (void)remove;
- (void)hideLine:(BOOL)hide;

@end

@implementation DrawPath

- (instancetype)init
{
    self = [super init];
    if (self) {
        _nodes = [NSMutableArray array];
        _bezierPath = [UIBezierPath bezierPath];
        [_bezierPath setLineWidth:1.0f];
        [_bezierPath setLineJoinStyle:kCGLineJoinRound];
        _lineColor = LineColor;
        _fillColor = [UIColor clearColor];
    }
    return self;
}

- (UIBezierPath *)bezierPath{
    
    [_bezierPath removeAllPoints];
    if ([_nodes count] > 1) {
        
        NodeView *nv = _nodes[0];
        
        [_bezierPath moveToPoint:nv.point];
        
        for (int i = 1; i < [_nodes count]; i++) {
            
            nv = _nodes[i];
            [_bezierPath addLineToPoint:nv.point];
            
        }
        
        if (_isClosed) {
            [_bezierPath closePath];
        }
        
    }
    
    return _bezierPath;
}

- (void)addNode:(NodeView *)node{
    [_nodes addObject:node];
}
- (void)endAddNode{
    
    _isClosed = YES;
}

- (void)remove{
    for (NodeView *nv in _nodes) {
        [nv removeFromSuperview];
    }
    [_bezierPath removeAllPoints];
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    for (NodeView *nv in _nodes) {
        [nv setHidden:!isSelected];
    }
    
}

- (void)hideLine:(BOOL)hide{
    
    [self setIsSelected:!hide];
    if (hide) {
        self.lineColor = [UIColor clearColor];
    } else {
        self.lineColor = LineColor;
    }
    
}

@end

@protocol DrawViewDelegate <NSObject>

- (UIImage *)needCropImageWithPath:(UIBezierPath *)path;

@end

@interface DrawView : UIView

@property (strong, nonatomic) UITapGestureRecognizer *tapPressGestureReconizer;
@property (strong, nonatomic) NSMutableArray *pointArr;
@property (strong, nonatomic) UIColor *changeToColor;
@property (strong, nonatomic) NodeView *currentSelectNode;
@property (strong, nonatomic) UIColor *lineColor;
@property (strong, nonatomic) NSMutableArray *redoArray;

@property (strong, nonatomic) DrawPath *currentDrawPath;
@property (assign, nonatomic) CGFloat hueValue;
@property (assign, nonatomic) CGFloat saturationValue;
@property (assign, nonatomic) BOOL isTestingHueAndSaturation;
@property (assign, nonatomic) id<DrawViewDelegate> delegate;

- (void)tapPressGestureReconizerHandler:(UITapGestureRecognizer *)gesture;

- (void)setColor:(UIColor *)color;
- (void)clear;
- (void)undo;
- (void)redo;
- (void)del;

@end

@implementation DrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.pointArr = [NSMutableArray array];
        _changeToColor = [UIColor clearColor];
        
        self.userInteractionEnabled = YES;
        
        self.tapPressGestureReconizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressGestureReconizerHandler:)];
        [self addGestureRecognizer:_tapPressGestureReconizer];
        
        self.redoArray = [NSMutableArray array];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    @autoreleasepool {
        
        
        
        if (_currentDrawPath != nil || [_pointArr count] > 0) {
            
            UIBezierPath* bezierPath = nil;
            
            UIColor *oldColor = nil;
            
            
            for (DrawPath *dp in _pointArr) {
                
                bezierPath = dp.bezierPath;
                [dp.lineColor setStroke];
                [bezierPath stroke];
                
                
                oldColor = dp.fillColor;
                
                if (_isTestingHueAndSaturation && _currentDrawPath == nil) {
                    
                    dp.hueValue = _hueValue;
                    dp.saturationValue = _saturationValue;
                    
                    UIImage *colorImage = nil;
                    
                    if ([dp.fillColor isEqual:[UIColor clearColor]]) {
                        
                        if (dp.image == nil) {
                            dp.image = [self.delegate needCropImageWithPath:bezierPath];
                        }
                        
                        colorImage = dp.image;
                        
                    } else {
                        colorImage = [DrawView imageWithColor:oldColor andSize:CGSizeMake(10, 10)];
                    }
                    
                    colorImage = [self imageHue:colorImage change:_hueValue];
                    colorImage = [self image:colorImage desaturated:_saturationValue];
                    
                    oldColor = [UIColor colorWithPatternImage:colorImage];
                    
                    [oldColor setFill];
                    
                } else {
                    
                    if (dp.image != nil) {
                        oldColor = [UIColor colorWithPatternImage:dp.image];
                    }
                    
                    [oldColor setFill];
                    
                    
                }
                
                
                
                [bezierPath fill];
                
            }
            
            if (_currentDrawPath) {
                bezierPath = _currentDrawPath.bezierPath;
                [_currentDrawPath.lineColor setStroke];
                [bezierPath stroke];
                
                oldColor = _currentDrawPath.fillColor;
                
                if (_isTestingHueAndSaturation) {
                    UIImage *colorImage = nil;
                    
                    if ([_currentDrawPath.fillColor isEqual:[UIColor clearColor]]) {
                        
                        if (_currentDrawPath.image == nil) {
                            _currentDrawPath.image = [self.delegate needCropImageWithPath:bezierPath];
                        }
                        
                        colorImage = _currentDrawPath.image;
                        
                    } else {
                        colorImage = [DrawView imageWithColor:oldColor andSize:CGSizeMake(10, 10)];
                    }
                    
                    _currentDrawPath.hueValue = _hueValue;
                    _currentDrawPath.saturationValue = _saturationValue;
                    
                    colorImage = [self imageHue:colorImage change:_hueValue];
                    colorImage = [self image:colorImage desaturated:_saturationValue];
                    
                    oldColor = [UIColor colorWithPatternImage:colorImage];
                    
                } else {
                    
                    if (_currentDrawPath.image != nil) {
                        oldColor = [UIColor colorWithPatternImage:_currentDrawPath.image];
                    }
                }
                
                
                [oldColor setFill];
                
                [bezierPath fill];
            }
            
            
        }
    }
    
}



+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

-(UIImage*)imageHue:(UIImage *)image change:(CGFloat)hue{
    
    
    @autoreleasepool {
        
        hue = hue * M_PI / 180.0f;
        NSLog(@"Hue: %.2f", hue);
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *ciimage = [CIImage imageWithCGImage:image.CGImage];
        CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust"];
        [filter setValue:ciimage forKey:kCIInputImageKey];
        [filter setValue:@(hue) forKey:@"inputAngle"];
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
        image = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        return image;
    }
}

-(UIImage*)image:(UIImage *)image desaturated:(CGFloat)deSaturated{
    
    
    @autoreleasepool {
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *ciimage = [CIImage imageWithCGImage:image.CGImage];
        CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
        [filter setValue:ciimage forKey:kCIInputImageKey];
        [filter setValue:@(deSaturated) forKey:kCIInputSaturationKey];
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
        image = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        return image;
    }
}

- (void)applyColor{
    
    UIColor *oldColor = nil;
    BOOL isNeddUpdateImage = NO;
    for (DrawPath *dp in _pointArr) {
        
        oldColor = dp.fillColor;
        
        
        
        UIImage *colorImage = nil;
        
        if (dp.image != nil) {
            colorImage = dp.image;
            isNeddUpdateImage = YES;
        } else {
            isNeddUpdateImage = NO;
            colorImage = [DrawView imageWithColor:oldColor andSize:CGSizeMake(10, 10)];
        }
        
        colorImage = [self imageHue:colorImage change:dp.hueValue];
        colorImage = [self image:colorImage desaturated:dp.saturationValue];
        
        dp.hueValue = 0;
        dp.saturationValue = 1;
        
        if (isNeddUpdateImage) {
            dp.image = colorImage;
        } else {
            oldColor = [UIColor colorWithPatternImage:colorImage];
            dp.fillColor = oldColor;
        }
        
        
        
        
        
    }
    
    isNeddUpdateImage = NO;
    if ([_pointArr containsObject:_currentDrawPath] == NO) {
        
        UIImage *colorImage = nil;
        
        
        
        if ([_currentDrawPath.fillColor isEqual:[UIColor clearColor]]) {
            
            if (_currentDrawPath.image == nil) {
                _currentDrawPath.image = [self.delegate needCropImageWithPath:_currentDrawPath.bezierPath];
            }
            
            colorImage = _currentDrawPath.image;
            
            isNeddUpdateImage = YES;
            
        } else {
            oldColor = _currentDrawPath.fillColor;
            colorImage = [DrawView imageWithColor:oldColor andSize:CGSizeMake(10, 10)];
        }
        
        colorImage = [self imageHue:colorImage change:_currentDrawPath.hueValue];
        colorImage = [self image:colorImage desaturated:_currentDrawPath.saturationValue];
        
        _currentDrawPath.hueValue = 0;
        _currentDrawPath.saturationValue = 1;
        
        oldColor = [UIColor colorWithPatternImage:colorImage];
        
        
        
        
        if (isNeddUpdateImage) {
            _currentDrawPath.image = colorImage;
        } else {
            _currentDrawPath.fillColor = oldColor;
        }
        
    }
    
    [self setNeedsDisplay];
    
    
}

- (void)setColor:(UIColor *)color{
    if (_currentDrawPath == nil) {
        return;
    }
    [_currentDrawPath setFillColor:color];
    [self setNeedsDisplay];
    
}
- (void)clear{
    _changeToColor = [UIColor clearColor];
    _lineColor = nil;
    
    for (DrawPath *dp in _pointArr) {
        [dp remove];
    }
    [_pointArr removeAllObjects];
    
    if (_currentDrawPath) {
        [_currentDrawPath remove];
        _currentDrawPath = nil;
    }
    
    [self setNeedsDisplay];
    [_redoArray removeAllObjects];
}

- (void)hideNode:(BOOL)hide{
    
    for (DrawPath *dp in _pointArr) {
        [dp hideLine:hide];
        [dp setIsSelected:NO];
    }
    
    if (_currentDrawPath) {
        [_currentDrawPath hideLine:hide];
        if (!hide) {
            [_currentDrawPath setIsSelected:YES];
        }
    }
    
    [self setNeedsDisplay];
    
}




- (void)tapPressGestureReconizerHandler:(UITapGestureRecognizer *)gesture{
    //    if (gesture.state == UIGestureRecognizerStateBegan) {
    @autoreleasepool {
        
        if (_lineColor == nil) {
            _lineColor = LineColor;
        }
        
        CGPoint touchPoint = [gesture locationInView:self];
        
        NodeView *nv = (id)[self hitTest:touchPoint withEvent:nil];
        
        if ([nv isKindOfClass:[NodeView class]] && !nv.isHidden) {
            
            if (!_currentDrawPath.isClosed && [_currentDrawPath.nodes count] > 2 && [[_currentDrawPath.nodes objectAtIndex:0] isEqual:nv]) {
                
                [_currentDrawPath endAddNode];
                
                [self setNeedsDisplay];
                
                return;
                
            } else if (DistanceTwoPoint(nv.center, touchPoint) < 5) {
                return;
            }
            
            
        }
        
        DrawPath *dp = nil;
        for (int i = [_pointArr count] - 1; i >= 0; i--) {
            
            dp = _pointArr[i];
            if ([dp.bezierPath containsPoint:touchPoint]) {
                
                
                if (!_currentDrawPath || _currentDrawPath.isClosed) {
                    
                    
                    _currentDrawPath.isSelected = NO;
                    
                    if (_currentDrawPath) {
                        [_pointArr addObject:_currentDrawPath];
                    }
                    
                    _currentDrawPath = dp;
                    _currentDrawPath.isSelected = YES;
                    
                    [_redoArray removeAllObjects];
                    
                    [self setNeedsDisplay];
                    
                    return;
                }
                
                
            }
            
        }
        
        if (_currentDrawPath.isClosed) {
            
            _currentDrawPath.isSelected = NO;
            [_pointArr addObject:_currentDrawPath];
            
            _currentDrawPath = nil;
            
            return;
            
        }
        
        nv = [[NodeView alloc] initWithFrame:SquareCGRectAtCenter(touchPoint.x, touchPoint.y, DEFAULT_CONTROL_POINT_SIZE)];
        nv.point = touchPoint;
        [self addSubview:nv];
        
        if (_currentDrawPath == nil) {
            
            _currentDrawPath = [[DrawPath alloc] init];
        }
        
        [_currentDrawPath addNode:nv];
        
        
        nv.userInteractionEnabled = YES;
        nv = nil;
        
        [self setNeedsDisplay];
        
        [_redoArray removeAllObjects];
    }
    //    }
}

#define GROW_FACTOR 3
#define SHRINK_FACTOR 1.1f

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    UITouch *touch = [touches anyObject];
    NodeView *nv = (NodeView *)[touch view];
    
    if ([nv isKindOfClass:[NodeView class]] == NO) {
        
        //        CGPoint touchPoint = [touch locationInView:self];
        //        nv = [[NodeView alloc] initWithFrame:SquareCGRectAtCenter(touchPoint.x, touchPoint.y, DEFAULT_CONTROL_POINT_SIZE)];
        //        nv.point = touchPoint;
        //        [self addSubview:nv];
        //        [_pointArr addObject:nv];
        //        nv.userInteractionEnabled = YES;
        //        nv = nil;
        //
        //        [self setNeedsDisplay];
        
        return;
    }
    
    
    [(UIScrollView *)self.superview.superview setScrollEnabled:NO];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3f];
    CGAffineTransform transform = CGAffineTransformMakeScale(GROW_FACTOR, GROW_FACTOR);
    nv.transform = transform;
    [UIView commitAnimations];
    
    self.currentSelectNode = nv;
    
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    @autoreleasepool {
        
        UITouch *touch = [touches anyObject];
        
        if ([touch view] == _currentSelectNode) {
            CGPoint location = [touch locationInView:self];
            self.currentSelectNode.center = location;
            self.currentSelectNode.point = location;
            
            if (_isTestingHueAndSaturation) {
                UIImage *nImage = [_delegate needCropImageWithPath:_currentDrawPath.bezierPath];
                _currentDrawPath.image = nImage;
            }
            
            [self setNeedsDisplay];
            return;
        }
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [(UIScrollView *)self.superview.superview setScrollEnabled:YES];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3f];
    CGAffineTransform transform = CGAffineTransformMakeScale(1, 1);
    self.currentSelectNode.transform = transform;
    [UIView commitAnimations];
    
    
    
    self.currentSelectNode = nil;
    
    [self setNeedsDisplay];
    
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [(UIScrollView *)self.superview.superview setScrollEnabled:YES];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3f];
    CGAffineTransform transform = CGAffineTransformMakeScale(1, 1);
    self.currentSelectNode.transform = transform;
    [UIView commitAnimations];
    
    self.currentSelectNode = nil;
}

- (void)undo{
    if (_currentDrawPath && _currentDrawPath.isClosed == NO) {
        NodeView *nv = _currentDrawPath.nodes[_currentDrawPath.nodes.count - 1];
        [nv removeFromSuperview];
        [_currentDrawPath.nodes removeObject:nv];
        [_redoArray addObject:nv];
        
        [self setNeedsDisplay];
    }
}
- (void)redo{
    if ([_redoArray count] > 0) {
        
        if (_currentDrawPath && _currentDrawPath.isClosed == NO) {
            NodeView *nv = _redoArray[_redoArray.count - 1];
            [self addSubview:nv];
            [_redoArray removeObject:nv];
            [_currentDrawPath.nodes addObject:nv];
            
            [self setNeedsDisplay];
        }
    }
}

- (void)del{
    if (_currentDrawPath) {
        [_currentDrawPath remove];
        if ([_pointArr containsObject:_currentDrawPath]) {
            [_pointArr removeObject:_currentDrawPath];
        }
        
        _currentDrawPath = nil;
    }
    
    [self setNeedsDisplay];
}
- (int) PointArray{
    
    return [_currentDrawPath.nodes count];
}
@end

@interface ImageViewWithDraw ()<UIGestureRecognizerDelegate, DrawViewDelegate>

@property (strong, nonatomic) DrawView *drawView;
@property (strong, nonatomic) CAShapeLayer *maskLayer;
@property (strong, nonatomic) UIImageView *imageView;


@end

@implementation ImageViewWithDraw

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _drawView = [[DrawView alloc] initWithFrame:frame];
        _drawView.delegate = self;
        [self addSubview:_drawView];
        
        
    }
    return self;
}

- (CAShapeLayer *)maskLayer
{
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.fillRule = kCAFillRuleEvenOdd;
        _maskLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _maskLayer;
}

- (UIImage *)captureView {
    
    //hide controls if needed
    CGRect rect = [self bounds];
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
    
}

#pragma mark Crop image

- (UIImage *)imageMaskedWithPath:(UIBezierPath *)path
{
    UIGraphicsBeginImageContextWithOptions(self.image.size, NO, self.image.scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    [path addClip];
    [self.image drawAtPoint:CGPointMake(0, 0)];
    CGContextRestoreGState(ctx);
    
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}

- (UIImage *)needCropImageWithPath:(UIBezierPath *)path{
    UIImage *image = nil;
    
    [_drawView hideNode:YES];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    [self.layer setMask:layer];
    
    image = [self imageMaskedWithPath:path];
    
    [self.layer setMask:nil];
    [_drawView hideNode:NO];
    _imageView.image = image;
    return image;
}

#pragma mark -

- (void)save{
    
    [_drawView hideNode:YES];
    
    UIImageWriteToSavedPhotosAlbum([self captureView],
                                   self,
                                   @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:),
                                   NULL);
    
    [_drawView hideNode:NO];
}

- (void)setColor:(UIColor *)color{
    [_drawView setColor:color];
}

- (void)clear{
    [_drawView clear];
}

- (void)wrapColor{
    
    //    _drawView.lineColor = [UIColor clearColor];
    //    [_drawView setNeedsDisplay];
    //
    //    [_drawView hideNode:YES];
    //
    //    UIImage *nImage = [self captureView];
    //    self.image = nImage;
    //    [self clear];
    
}

- (void)undo{
    [_drawView undo];
}
- (void)redo{
    [_drawView redo];
}

- (void)del{
    [_drawView del];
}
- (int) getPointArray{
    
    return  [_drawView PointArray];;
}
- (void)   savedPhotoImage:(UIImage *)image
  didFinishSavingWithError:(NSError *)error
               contextInfo:(void *)contextInfo
{
    NSString *message = @"This image has been saved to your Photos album";
    if (error) {
        message = [error localizedDescription];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)beginTestHueAndSaturation{
    _drawView.isTestingHueAndSaturation = YES;
}
- (void)setChangeHue:(CGFloat)hue saturation:(CGFloat)saturation{
    
    _drawView.hueValue = hue;
    _drawView.saturationValue = saturation;
    [_drawView setNeedsDisplay];
    
}

- (void)endTestHueAndSaturation{
    _drawView.isTestingHueAndSaturation = NO;
    [_drawView setNeedsDisplay];
}

- (void)applyChangeHueSaturation{
    [_drawView applyColor];
}




@end


#define OvalSize        40
@implementation NodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        self.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3f];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    UIBezierPath* ovalPath = nil;
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    
    //// Oval Drawing
    CGRect ovalRect;
    ovalRect = CGRectMake((CGRectGetWidth(rect) - OvalSize) / 2.0f, (CGRectGetHeight(rect) - OvalSize) / 2.0f, OvalSize, OvalSize);
    ovalPath = [UIBezierPath bezierPathWithOvalInRect: ovalRect];
    
    [fillColor setFill];
    [ovalPath fill];
    
    ovalPath.lineWidth = 1.5;
    UIColor *strokeColor = LineColor;
    [strokeColor setStroke];
    [ovalPath stroke];
}

@end

