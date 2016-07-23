//
//  GarageViewController.h
//  HeartCMS
//
//  Created by Nguyen Thanh Hung on 9/22/14.
//  Copyright (c) 2014 NguyenHung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol GarageViewControllerDelegate;

@interface GarageViewController : BaseViewController

@property (assign, nonatomic) IBOutlet id<GarageViewControllerDelegate>gvDelegate;

@end

@protocol GarageViewControllerDelegate <NSObject>

- (void)garageViewController:(GarageViewController *)gvc didSelectedImage:(UIImage *)image;
- (void)garageViewControllerDidCancel:(GarageViewController *)gvc;

@end
