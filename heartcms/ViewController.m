//
//  ViewController.m
//  HeartCMS
//
//  Created by Nguyen Thanh Hung on 9/16/14.
//  Copyright (c) 2014 NguyenHung. All rights reserved.
//

#import "ViewController.h"
#import "NEOColorPickerHSLViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "DrawViewController.h"
#import "UIImage+fixOrientation.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (void)dealloc{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takeAction:(id)sender {
    
    UISegmentedControl *segmented = sender;
    
    if (_selectedImage) {
        
        [_segmentedControl setTitle:NSLocalizedString(@"Take Photo", @"") forSegmentAtIndex:0];
        [_segmentedControl setTitle:NSLocalizedString(@"Gallery", @"") forSegmentAtIndex:1];
        
        if (segmented.selectedSegmentIndex == 0) {
            
            self.selectedImage = nil;
            [self presentViewController:_picker animated:YES completion:NULL];
            
        } else {
            DrawViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DrawViewController"];
            if (dvc) {
                dvc.image = _selectedImage;
                [self.navigationController pushViewController:dvc animated:YES];
                _imageView.image = nil;
                self.selectedImage = nil;
            }
        }
    } else {
        if (_picker == nil) {
            _picker = [[UIImagePickerController alloc] init];
        }
        
        if (segmented.selectedSegmentIndex == 0) {
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
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    @autoreleasepool {
        [picker dismissViewControllerAnimated:YES completion:NULL];
        
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        
        if (image) {
            
            self.selectedImage = [image fixOrientation];
            self.imageView.image = _selectedImage;
            [_segmentedControl setTitle:@"Take Again" forSegmentAtIndex:0];
            [_segmentedControl setTitle:@"Wrap Your Car" forSegmentAtIndex:1];
            
        } else {
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
@end
