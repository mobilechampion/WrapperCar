//
//  MainViewController.h
//  HeartCMS
//
//  Created by Nguyen Thanh Hung on 9/22/14.
//  Copyright (c) 2014 NguyenHung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GalleryViewController.h"
#import "GarageTutorialViewController.h"
@interface MainViewController : BaseViewController<GalleryControllerDelegate,Tutorial_Cancel_Delegate >
-(void)updateIAPP;
@end
