//
//  GarageViewController.m
//  HeartCMS
//
//  Created by Nguyen Thanh Hung on 9/22/14.
//  Copyright (c) 2014 NguyenHung. All rights reserved.
//

#import "GarageViewController.h"

#import "iCarousel.h"

#import "AppDelegate.h"

@interface GarageViewController ()

@property (assign, nonatomic) BOOL wrap;

@property (weak, nonatomic) IBOutlet iCarousel *carousel;


@end

@implementation GarageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.carousel.type = iCarouselTypeCoverFlow2;
    self.wrap = YES;
    
    [_carousel reloadData];
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
- (IBAction)cancel:(id)sender {
    if ([_gvDelegate respondsToSelector:@selector(garageViewControllerDidCancel:)]) {
        [_gvDelegate garageViewControllerDidCancel:self];
    }
}

#pragma mark Carousel

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return 5;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    UIImageView *mv = (UIImageView *)view;
    if (mv == nil) {
        
        mv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
        
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"bmw_%d", index + 1]];
        mv.image = image;
        mv.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    
    return mv;
}



- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 0;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    if (index >= 6) {
        return nil;
    }
    
    UIImageView *mv = (UIImageView *)view;
    if (mv == nil) {
        
        mv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
        
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"bmw_%d", index + 1]];
        mv.image = image;
        mv.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    
    return mv;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * self.carousel.itemWidth);
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return self.wrap;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

#pragma mark -

#pragma mark iCarousel taps

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if ([_gvDelegate respondsToSelector:@selector(garageViewController:didSelectedImage:)]) {
        AppDelegate * app = [[UIApplication sharedApplication] delegate];
        app.car_number = index;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"bmw_%d", index + 1]];
        [_gvDelegate garageViewController:self didSelectedImage:image];
    }
    
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    
}

#pragma mark -

@end
