//
//  MainViewController.m
//  HeartCMS
//
//  Created by Nguyen Thanh Hung on 9/22/14.
//  Copyright (c) 2014 NguyenHung. All rights reserved.
//

#import "MainViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+fixOrientation.h"

#import "DrawViewControllerPhoto.h"
#import "DrawViewControllerGarage.h"
#import "AppDelegate.h"
#import "MKStore/MKStoreManager.h"
#import "GalleryViewController.h"
#import "GarageTutorialViewController.h"
@interface MainViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    BOOL icSHowedTake;
    BOOL icSHowedGall;

    
}

@property (strong, nonatomic) UIImagePickerController *picker;
@property (weak, nonatomic) IBOutlet UIButton *takePictureButton;
@property (weak, nonatomic) IBOutlet UIButton *selectGalleryButton;
@property (weak, nonatomic) IBOutlet UIImageView *img_takephoto_mark;
@property (weak, nonatomic) IBOutlet UIImageView *img_take_photo_gallery_mark;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [self setButtonStatusWithIAPStatus:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


-(void)viewWillAppear:(BOOL)animated{
     [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    BOOL maxScore = [[NSUserDefaults standardUserDefaults] integerForKey: @"ISPURCHASED"];
    
    //[[MKStoreManager sharedManager] buyFeature:alertView.tag];
    if (maxScore) {
        self.img_take_photo_gallery_mark.hidden = YES;
        self.img_takephoto_mark.hidden = YES;
    }else{
        self.img_take_photo_gallery_mark.hidden = NO;
        self.img_takephoto_mark.hidden = NO;
    }
      self.navigationController.navigationBarHidden = YES;
}
- (void)setDrawWithImage:(UIImage *)image{
  //  if (isCamera) {
//    
    if (image.size.width > 1000) {
        CGSize size = CGSizeMake(image.size.width /5, image.size.height /5);
        image =  [self imageWithImage:image scaledToSize:size];
        NSLog(@"%f,%f",image.size.width,image.size.height);
    }
          //  }
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSString *tmpFile = [tmpDirectory stringByAppendingPathComponent:@"capture.jpg"];
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    if ([data writeToFile:tmpFile atomically:YES]) {
        image = [UIImage imageWithContentsOfFile:tmpFile];
    }
    AppDelegate * app = [[UIApplication sharedApplication   ] delegate];
    if (app.iS_Garage) {
        //UINavigationController *nvDraw = [self.storyboard instantiateViewControllerWithIdentifier:@"nvDraw"];
        
        
        DrawViewControllerGarage *dc = [self.storyboard instantiateViewControllerWithIdentifier:@"DrawViewControllerGarage"];
        if (dc) {
            dc.image = image;
            
            [self presentViewController:dc animated:YES completion:nil];
        }

    }else{
        //UINavigationController *nvDraw =
     //   UINavigationController *nvDraw = [self.storyboard instantiateViewControllerWithIdentifier:@"nvDraw"];
    //    DrawViewControllerPhoto *dc = [[nvDraw viewControllers] objectAtIndex:0];
        
       DrawViewControllerPhoto *dc = [self.storyboard instantiateViewControllerWithIdentifier:@"DrawViewControllerPhoto"];
        if (dc) {
            dc.image = image;
            
           // [self presentViewController:dc animated:YES completion:nil];
            
            [self.navigationController pushViewController:dc animated:YES];
            
        
        }

    }
    }

- (IBAction)selectFromGarage:(id)sender {
   // isCamera = NO;
    AppDelegate * app = [[UIApplication sharedApplication   ] delegate];
    app.iS_Garage = YES;
//    GarageViewController *gvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GarageViewController"];
//    if (gvc) {
//        gvc.gvDelegate = self;
//        [self presentViewController:gvc animated:YES completion:nil];
//    }
    
        GalleryViewController *gvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryViewController"];
       if (gvc) {
          gvc.gvDelegate = self;
          [self presentViewController:gvc animated:YES completion:nil];
       }
    
    
}

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)selectImageFromGallary:(BOOL)gallary{
    if (_picker == nil) {
        _picker = [[UIImagePickerController alloc] init];
    }
    
    if (!gallary) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
    } else {
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    _picker.delegate = self;
    _picker.mediaTypes = @[(__bridge NSString *)kUTTypeImage];
    
    
    [self presentViewController:_picker animated:YES completion:NULL];
}

- (IBAction)takeImage:(id)sender {
    
    if (!icSHowedTake) {
        GarageTutorialViewController *gvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GarageTutorialViewController"];
        gvc.isGra = NO;
        gvc.isSelectImageFromGallary = NO;
        gvc.gvDelegate = self;
        [self presentViewController:gvc animated:YES completion:nil];
        icSHowedTake = YES;
    }else{
        AppDelegate * app = [[UIApplication sharedApplication   ] delegate];
        app.iS_Garage = NO;
        BOOL maxScore = [[NSUserDefaults standardUserDefaults] integerForKey: @"ISPURCHASED"];
        
        if (maxScore) {
            [self selectImageFromGallary:NO];
            //  isCamera = YES;
        }else{
            [[MKStoreManager sharedManager] buyFeature:1];
        }
    }

  
    
}
- (IBAction)takeFromGallary:(id)sender {
    
    if (!icSHowedGall) {
        GarageTutorialViewController *gvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GarageTutorialViewController"];
        gvc.isGra = NO;
        gvc.isSelectImageFromGallary = YES;
         gvc.gvDelegate = self;
        [self presentViewController:gvc animated:YES completion:nil];
        icSHowedGall = YES;
    }else{
        AppDelegate * app = [[UIApplication sharedApplication   ] delegate];
        app.iS_Garage = NO;
        BOOL maxScore = [[NSUserDefaults standardUserDefaults] integerForKey: @"ISPURCHASED"];
        
        if (maxScore) {
            //   isCamera = NO;
            [self selectImageFromGallary:YES];
        }else{
            [[MKStoreManager sharedManager] buyFeature:1];
        }
    }
 
}

- (IBAction)openWebsite:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.heartcms.com"]];
    
}

- (IBAction)requestEmailAction:(id)sender {
    
    UINavigationController *navc = [self.storyboard instantiateViewControllerWithIdentifier:@"emailNavigation"];
    
    [self presentViewController:navc animated:YES completion:nil];
    
}

//- (void)garageViewControllerDidCancel:(GarageViewController *)gvc{
//    [gvc dismissViewControllerAnimated:YES completion:nil];
//}

- (void)gallerviewcontroller:(GalleryViewController *)gvc didSelectedImage:(UIImage *)image{
    [gvc dismissViewControllerAnimated:YES completion:^{
        [self setDrawWithImage:image];
    }];
}

- (void)Tutorial_Cancel:(GarageTutorialViewController *)gvc didDissmissed:(BOOL)isSelect{
    
    AppDelegate * app = [[UIApplication sharedApplication   ] delegate];
    app.iS_Garage = NO;
    BOOL maxScore = [[NSUserDefaults standardUserDefaults] integerForKey: @"ISPURCHASED"];
    
    if (maxScore) {
        //   isCamera = NO;
        [self selectImageFromGallary:isSelect];
    }else{
        [[MKStoreManager sharedManager] buyFeature:1];
    }
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    @autoreleasepool {
        [picker dismissViewControllerAnimated:YES completion:^{
            UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
            
            if (image) {
                
                image = [image fixOrientation];
                
                [self setDrawWithImage:image];
                
                
                
            } else {
                [self presentViewController:picker animated:YES completion:NULL];
            }
        }];
        
        
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark Check iAP

-(void)updateIAPP{
    BOOL maxScore = [[NSUserDefaults standardUserDefaults] integerForKey: @"ISPURCHASED"];
    
    //[[MKStoreManager sharedManager] buyFeature:alertView.tag];
    if (maxScore) {
        self.img_take_photo_gallery_mark.hidden = YES;
        self.img_takephoto_mark.hidden = YES;
    }else{
        self.img_take_photo_gallery_mark.hidden = NO;
        self.img_takephoto_mark.hidden = NO;
    }

}

- (void)setButtonStatusWithIAPStatus:(BOOL)isAlreadyBuy{
    
//    if (isAlreadyBuy == NO) {
//        
//        UIImage *lockImage = [UIImage imageNamed:@"icon_lock"];
//        
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:lockImage];
//        CGRect buttonFrame = CGRectZero;
//        CGRect imageViewFrame = imageView.frame;
//        buttonFrame = _takePictureButton.bounds;
//        
//        imageViewFrame.origin.x = 30;
//        imageViewFrame.origin.y = (buttonFrame.size.height - imageViewFrame.size.height) / 2.0f;
//        imageView.frame = imageViewFrame;
//        [_takePictureButton addSubview:imageView];
//        
//        
//        imageView = [[UIImageView alloc] initWithImage:lockImage];
//        imageViewFrame = imageView.frame;
//        buttonFrame = _selectGalleryButton.bounds;
//        
//        imageViewFrame.origin.x = buttonFrame.size.width - imageViewFrame.size.width - 20;
//        imageViewFrame.origin.y = (buttonFrame.size.height - imageViewFrame.size.height) / 2.0f;
//        imageView.frame = imageViewFrame;
//        
//        [_selectGalleryButton addSubview:imageView];
//        
//        
//    } else {
//        
//        
//        
//    }
//    
}

#pragma mark -


@end
