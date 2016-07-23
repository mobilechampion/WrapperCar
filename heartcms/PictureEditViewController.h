//
//  PictureEditViewController.h
//  HeartCMS
//
//  Created by Nguyen Thanh Hung on 9/17/14.
//  Copyright (c) 2014 NguyenHung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PictureEditViewControllerDelegate;
@interface PictureEditViewController : UIViewController

@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) id<PictureEditViewControllerDelegate>picDelegate;

@end

@protocol PictureEditViewControllerDelegate <NSObject>

- (void)pictureEditViewControllerComplete:(PictureEditViewController *)pic newImage:(UIImage *)image;
- (void)pictureEditViewControllerDidCancel:(PictureEditViewController *)pic;

@end
