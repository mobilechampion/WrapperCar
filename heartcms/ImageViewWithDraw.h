//
//  ImageViewWithDraw.h
//  DemoSelectionApp
//
//  Created by Nguyen Thanh Hung on 9/14/14.
//  Copyright (c) 2014 NguyenHung. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NodeView : UIView

@property (assign, nonatomic) CGPoint point;

@end
@interface ImageViewWithDraw : UIImageView


- (void)setColor:(UIColor *)color;
- (void)clear;
- (void)save;
- (void)wrapColor;
- (void)undo;
- (void)redo;
- (void)del;
- (int) getPointArray;

- (void)beginTestHueAndSaturation;
- (void)setChangeHue:(CGFloat)hue saturation:(CGFloat)saturation;
- (void)applyChangeHueSaturation;
- (void)endTestHueAndSaturation;
@end
