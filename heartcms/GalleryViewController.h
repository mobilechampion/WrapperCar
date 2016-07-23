//
//  GalleryViewController.h
//  heartcms
//
//  Created by HaoYun Jin on 10/6/14.
//  Copyright (c) 2014 HaoYun Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GalleryControllerDelegate;
@interface GalleryViewController : UIViewController

@property (assign, nonatomic) IBOutlet id<GalleryControllerDelegate>gvDelegate;
@end
@protocol GalleryControllerDelegate <NSObject>

- (void)gallerviewcontroller:(GalleryViewController *)gvc didSelectedImage:(UIImage *)image;
//- (void)garageViewControllerDidCancel:(GalleryViewController *)gvc;

@end
