//
//  GarageTutorialViewController.h
//  heartcms
//
//  Created by HaoYun Jin on 10/6/14.
//  Copyright (c) 2014 HaoYun Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol Tutorial_Cancel_Delegate;
@interface GarageTutorialViewController : UIViewController

    @property (readwrite, nonatomic) BOOL isGra;
    @property (readwrite, nonatomic) BOOL isSelectImageFromGallary;

    @property (assign, nonatomic) IBOutlet id<Tutorial_Cancel_Delegate>gvDelegate;

@end
@protocol Tutorial_Cancel_Delegate <NSObject>

- (void)Tutorial_Cancel:(GarageTutorialViewController *)gvc didDissmissed:(BOOL)isSelect;
//- (void)garageViewControllerDidCancel:(GalleryViewController *)gvc;

@end

