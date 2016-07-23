//
//  PictureEditViewController.m
//  HeartCMS
//
//  Created by Nguyen Thanh Hung on 9/17/14.
//  Copyright (c) 2014 NguyenHung. All rights reserved.
//

#import "PictureEditViewController.h"
#import "UIImage+ImageResizing.h"

@interface PictureEditViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *hueSlider;
@property (weak, nonatomic) IBOutlet UISlider *saturationSlider;
@property (strong, nonatomic) UIImage *reSizedImage;

@end

@implementation PictureEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @autoreleasepool {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(buttonPressCancel:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(buttonPressDone:)];
        
        _reSizedImage = [_image imageWithSize:CGSizeMake(_imageView.bounds.size.width / 2.0f, _imageView.bounds.size.height / 2.0f) contentMode:UIViewContentModeScaleAspectFit];
        
        _imageView.image = _reSizedImage;
    }
}


- (void)dealloc{
    self.image = nil;
    self.reSizedImage = nil;
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

- (IBAction)buttonPressCancel:(id)sender {

    [self.picDelegate pictureEditViewControllerDidCancel:self];
}

- (IBAction)buttonPressDone:(id)sender {
    UIImage *image = [self image:[self imageHue:_image change:_hueSlider.value] desaturated:_saturationSlider.value];
    [self.picDelegate pictureEditViewControllerComplete:self newImage:image];
}

- (void)changePic{
    
    UIImage *image = [self image:[self imageHue:_reSizedImage change:_hueSlider.value] desaturated:_saturationSlider.value];
    _imageView.image = image;
    
}

- (IBAction)saturationValueChange:(id)sender {
    [self changePic];
}
- (IBAction)hueValueChange:(id)sender {
    [self changePic];
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

-(UIImage*)imageHue:(UIImage *)image change:(CGFloat)hue{
    
    
    @autoreleasepool {
        hue = hue * M_PI / 180;
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


@end
