//
//  DrawViewController.m
//  HeartCMS
//
//  Created by Nguyen Thanh Hung on 9/16/14.
//  Copyright (c) 2014 NguyenHung. All rights reserved.
//

#import "DrawViewController.h"
#import <MessageUI/MessageUI.h>
#import "ImageViewWithDraw.h"
#import "NEOColorPickerHSLViewController.h"
#import "PictureEditViewController.h"
#import "TableViewWithBlock.h"
#import "SelectionCell.h"
#import "AppDelegate.h"
@interface DrawViewController ()<NEOColorPickerViewControllerDelegate, UIActionSheetDelegate,  MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, PictureEditViewControllerDelegate>{
    BOOL isOpened;
    NSArray *na_category_key;
    NSArray *na_category_key_name;
}

@property (strong, nonatomic) ImageViewWithDraw *imageViewWithDraw;
@property (assign, nonatomic) CGFloat currentHue;
@property (assign, nonatomic) CGFloat currentSaturation;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (strong, nonatomic) UIColor *currentColor;
@property (assign, nonatomic) BOOL isNeedColor;
@property (weak, nonatomic) IBOutlet UISegmentedControl *controlSegmentedControl;
@property (weak, nonatomic) IBOutlet UISlider *hueSlider;
@property (weak, nonatomic) IBOutlet UISlider *saturationSlider;
@property (weak, nonatomic) IBOutlet UIView *hueSatEditView;

@property (weak, nonatomic) IBOutlet UIView *colour_select;


@property (weak, nonatomic) IBOutlet UIButton *openButtonOnly;
- (IBAction)txt_category_search_click:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txt_search_category_only;

@property (weak, nonatomic) IBOutlet TableViewWithBlock *tb_for_cat_search_only;

@property (weak, nonatomic) IBOutlet UIButton *wrap_btn;
@property (weak, nonatomic) IBOutlet UIButton *color_btn;

@property (weak, nonatomic) IBOutlet UIButton *setting_btn;
@property (weak, nonatomic) IBOutlet UIButton *clear_btn;

- (void)showChooseColor;

@end

@implementation DrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect imageViewRect = CGRectZero;
    imageViewRect.size = _image.size;
    _imageViewWithDraw = [[ImageViewWithDraw alloc] initWithFrame:imageViewRect];
    _imageViewWithDraw.image = _image;
    _imageViewWithDraw.userInteractionEnabled = YES;
    
    [_scrollView addSubview:_imageViewWithDraw];
    _scrollView.contentSize = imageViewRect.size;
    
    [_actionButton setImage:[DrawViewController createActionButtonImage:nil] forState:UIControlStateNormal];
    
    CGFloat scale = 0;
    if (_image.size.height > _image.size.width) {
        
        scale = CGRectGetHeight(self.view.bounds) / _image.size.height;
        
    } else {
        
        scale = CGRectGetWidth(self.view.bounds) / _image.size.width;
        
    }
    
    [_scrollView setMinimumZoomScale:scale];
    [_scrollView setZoomScale:scale];
    
    _currentHue = 0;
    _currentSaturation = 1;
    
    _hueSlider.value = 0;
    _saturationSlider.value = 1;
    isOpened=NO;
    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [_imageViewWithDraw clear];
        AppDelegate * app = [[UIApplication sharedApplication] delegate];
      //  int  k =[[na_category_key objectAtIndex:app.car_number] count];

        UIImage *image = [UIImage imageNamed:[[na_category_key_name objectAtIndex:app.car_number ]        objectAtIndex:      alertView.tag ]];
        _image = image;
        _imageViewWithDraw.image = _image;
        //        [self buttonClicked:self];
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSArray *arr1 = [NSArray arrayWithObjects:@"WHITE",@"RED",@"BLUE",@"GREEN", nil];
    NSArray *arr2 = [NSArray arrayWithObjects:@"MATT",@"PURPLE", nil];
    NSArray *arr3 = [NSArray arrayWithObjects:@"LIME GREEN",@"MATT BLUE",@"ORANGE", nil];
    NSArray *arr4 = [NSArray arrayWithObjects:@"LGIHT BLUE",@"MATTE BROWN",@"METALIC PURPLE",@"BLACK", nil];
    
    NSArray *arr5 = [NSArray arrayWithObjects:@"BLUE",@"MATTE BLUE", @"ORANGE",@"YELLOW", nil];
    NSArray *arr6 = [NSArray arrayWithObjects:@"BLACK",@"MATTE BROWN", @"ORANGE",@"YELLOW", nil];
    NSArray *arr7 = [NSArray arrayWithObjects:@"BLACK",@"MATTE GREY", @"RED",@"WHITE", nil];
    na_category_key = [NSArray arrayWithObjects:arr1,arr2,arr3,arr4,arr5,arr6,arr7, nil];
    NSArray *arr1_name = [NSArray arrayWithObjects:@"bmw_1",@"bmw_2",@"bmw_3",@"bmw_4", nil];
    NSArray *arr2_name = [NSArray arrayWithObjects:@"bmw_5",@"bmw_6", nil];
    NSArray *arr3_name = [NSArray arrayWithObjects:@"gtr-limegreen",@"gtr-matteblue",@"gtr-orange", nil];
    NSArray *arr4_name = [NSArray arrayWithObjects:@"ka-lightblue",@"ka-matte-brown",@"ka-metallic-purple",@"kablack", nil];
    NSArray *arr5_name = [NSArray arrayWithObjects:@"mini-cooper-blue",@"mini-cooper-matte-blue", @"mini-cooper-orange",@"mini-cooper-yellow", nil];
     NSArray *arr6_name = [NSArray arrayWithObjects:@"BMW-M4-Black",@"BMW-M4-matteBrown", @"BMW-M4-Orange",@"BMW-M4-Yellow", nil];
    NSArray *arr7_name = [NSArray arrayWithObjects:@"VWGolf",@"VWGolfMatteGrey", @"VWGolfRed",@"VWGolfwhite", nil];
    
    na_category_key_name = [NSArray arrayWithObjects:arr1_name,arr2_name,arr3_name,arr4_name,arr5_name,arr6_name,arr7_name, nil];
    
    [_tb_for_cat_search_only initTableViewDataSourceAndDelegate:^(UITableView *tableView, NSInteger section){
        
        AppDelegate * app = [[UIApplication sharedApplication] delegate];
        NSInteger  k =[[na_category_key objectAtIndex:app.car_number] count];
        
        
        return k;
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        AppDelegate * app = [[UIApplication sharedApplication] delegate];
        [cell.lb setText:[NSString stringWithFormat:@"%@",[[na_category_key objectAtIndex:app.car_number] objectAtIndex:indexPath.row]]];
        [cell.lb setTextColor:[UIColor whiteColor]];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        _txt_search_category_only.text=cell.lb.text;
        
        [_openButtonOnly sendActionsForControlEvents:UIControlEventTouchUpInside];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HeartCMS" message:@"Choosing colour will loss all changes"
													   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"OK",nil];
       // AppDelegate * app = [[UIApplication sharedApplication] delegate];
        alert.tag = indexPath.row;
        [alert show];
    }];
    
    AppDelegate * app = [[UIApplication sharedApplication] delegate];
    if (app.iS_Garage) {
        self.colour_select.hidden = NO;
        self.wrap_btn.hidden = YES;
        self.color_btn.hidden = YES;
       [self.setting_btn setTitle:@"COLOUR SETTINGS" forState:UIControlStateNormal];
        [self.clear_btn setTitle:@"START AGAIN" forState:UIControlStateNormal];
        
        [self.setting_btn setFrame:CGRectMake(110, 10, 150,  self.setting_btn.bounds.size.height)];

        
        [self.clear_btn setFrame:CGRectMake(5, 10, 100,  self.clear_btn.bounds.size.height)];
        
        
        AppDelegate * app = [[UIApplication sharedApplication] delegate];
         _txt_search_category_only.text=[[na_category_key objectAtIndex:app.car_number] objectAtIndex:0];
    
        
    }else{
        self.colour_select.hidden = YES;
    }
    
}
- (IBAction)txt_category_search_click:(id)sender {
    if (isOpened) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=_tb_for_cat_search_only.frame;
            frame.size.height=1;
            [_tb_for_cat_search_only setFrame:frame];
        } completion:^(BOOL finished){
            isOpened=NO;
        }];
        
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=_tb_for_cat_search_only.frame;
            if ([na_category_key count]==0) {
                frame.size.height=1;
            }else{
                frame.size.height=70;
            }
            
            [_tb_for_cat_search_only setFrame:frame];
        } completion:^(BOOL finished){
            isOpened=YES;
        }];
    }
    
}

- (void)dealloc{
    [_imageViewWithDraw removeFromSuperview];
    self.imageViewWithDraw = nil;
    
    self.image = nil;
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

#pragma mark UIScrollViewDelegate

- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageViewWithDraw.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageViewWithDraw.frame = contentsFrame;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageViewWithDraw;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    [self centerScrollViewContents];
}

#pragma mark 0

- (IBAction)setColor:(id)sender {
    
    [self showChooseColor];
}

- (IBAction)clear:(id)sender {
    [_imageViewWithDraw clear];
}

- (IBAction)save:(id)sender {
    [_imageViewWithDraw save];
}

- (IBAction)wrapAction:(id)sender {
    
    if (_currentColor == nil) {
        _isNeedColor = YES;
        
        [self showChooseColor];
        
    } else {
        [_imageViewWithDraw setColor:_currentColor];
        [_imageViewWithDraw wrapColor];
        
        self.image = _imageViewWithDraw.image;
    }
    
}

- (IBAction)actionTUI:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Continues edit" destructiveButtonTitle:@"Save image to gallery" otherButtonTitles:@"Send image via email", nil];
    [actionSheet showInView:self.view];
    
}




- (void)showChooseColor{
    NEOColorPickerHSLViewController *colorChoose = [[NEOColorPickerHSLViewController alloc] initWithNibName:@"NEOColorPickerHSLViewController" bundle:nil];
    colorChoose.delegate = self;
    colorChoose.selectedColor = _currentColor;
    colorChoose.title = @"Choose Colour";
    
    [self.navigationController pushViewController:colorChoose animated:YES];
    
    colorChoose = nil;
}

- (void)openCloseHueSaturationEdit:(BOOL)open{
    
    [UIView beginAnimations:@"" context:nil];
    
    CGRect frame = _hueSatEditView.frame;
    if (open) {
        frame.origin = CGPointZero;
    } else {
        frame.origin = CGPointMake(CGRectGetWidth(frame), 0);
    }
    
    _hueSatEditView.frame = frame;
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:.3f];
    [UIView commitAnimations];
    
}

- (IBAction)editPic:(id)sender {
    [self openCloseHueSaturationEdit:YES];
    _imageViewWithDraw.userInteractionEnabled = NO;
    [_imageViewWithDraw beginTestHueAndSaturation];
    
}

- (IBAction)controlAction:(id)sender {
    UISegmentedControl *sc = sender;
    
    if ([sc selectedSegmentIndex] == 0) {
        [_imageViewWithDraw undo];
    } else if ([sc selectedSegmentIndex] == 1) {
        [_imageViewWithDraw redo];
    } else {
        [_imageViewWithDraw del];
    }
    
}

- (IBAction)done:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark select color

- (void) colorPickerViewController:(NEOColorPickerBaseViewController *) controller didSelectColor:(UIColor *)color{
    
    self.currentColor = color;
    
    if (_isNeedColor) {
        
        [self wrapAction:nil];
    }
    
    _isNeedColor = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -


#pragma mark ActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        [self save:nil];
        
    } else if (buttonIndex == 1) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        [picker setSubject:@"Check out my car!"];
        picker.mailComposeDelegate = self;
        
        // Attach an image to the email
        UIImage *coolImage = _imageViewWithDraw.image;
        NSData *myData = UIImagePNGRepresentation(coolImage);
        [picker addAttachmentData:myData mimeType:@"image/png" fileName:@"my_car.png"];
        
        // Fill out the email body text
        NSString *emailBody = @"A picture of my car!";
        [picker setMessageBody:emailBody isHTML:NO];
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
}



#pragma mark -

#pragma mark PictureEdit

- (void)pictureEditViewControllerComplete:(PictureEditViewController *)pic newImage:(UIImage *)image{
    
    self.image = image;
    self.imageViewWithDraw.image = image;
    
    [pic.navigationController popViewControllerAnimated:YES];
}

- (void)pictureEditViewControllerDidCancel:(PictureEditViewController *)pic{
    [pic.navigationController popViewControllerAnimated:YES];
}

- (void)changeHueSaturation{
    
    CGFloat hue = _hueSlider.value;
    
    CGFloat saturation = _saturationSlider.value;
    [_imageViewWithDraw setChangeHue:hue saturation:saturation];
}

- (IBAction)hueChangedValue:(id)sender {
    
    [self changeHueSaturation];
    
}

- (IBAction)saturationValueChanged:(id)sender {
    
    [self changeHueSaturation];
    
}



- (IBAction)doneHueSatChange:(id)sender {
    [self openCloseHueSaturationEdit:NO];
    [_imageViewWithDraw endTestHueAndSaturation];
     _imageViewWithDraw.userInteractionEnabled = YES;
    [_imageViewWithDraw applyChangeHueSaturation];
}

- (IBAction)cancelHueSatChange:(id)sender {
    [self openCloseHueSaturationEdit:NO];
    _imageViewWithDraw.userInteractionEnabled = YES;
    [_imageViewWithDraw endTestHueAndSaturation];
}


#pragma mark -

#define MINIMAL_UI (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)

+ (UIImage *)createActionButtonImage:(NSDictionary *)attributes
{
    UIImage *actionButtonImage = nil;
    UIGraphicsBeginImageContextWithOptions((CGSize){19,30}, NO, [[UIScreen mainScreen] scale]);
    {
        //// Color Declarations
        UIColor* actionColor = [UIColor blackColor];
        
        //// ActionButton Drawing
        UIBezierPath* actionButtonPath = [UIBezierPath bezierPath];
        [actionButtonPath moveToPoint: CGPointMake(1, 9)];
        [actionButtonPath addLineToPoint: CGPointMake(1, 26.02)];
        [actionButtonPath addLineToPoint: CGPointMake(18, 26.02)];
        [actionButtonPath addLineToPoint: CGPointMake(18, 9)];
        [actionButtonPath addLineToPoint: CGPointMake(12, 9)];
        [actionButtonPath addLineToPoint: CGPointMake(12, 8)];
        [actionButtonPath addLineToPoint: CGPointMake(19, 8)];
        [actionButtonPath addLineToPoint: CGPointMake(19, 27)];
        [actionButtonPath addLineToPoint: CGPointMake(0, 27)];
        [actionButtonPath addLineToPoint: CGPointMake(0, 8)];
        [actionButtonPath addLineToPoint: CGPointMake(7, 8)];
        [actionButtonPath addLineToPoint: CGPointMake(7, 9)];
        [actionButtonPath addLineToPoint: CGPointMake(1, 9)];
        [actionButtonPath closePath];
        [actionButtonPath moveToPoint: CGPointMake(9, 0.98)];
        [actionButtonPath addLineToPoint: CGPointMake(10, 0.98)];
        [actionButtonPath addLineToPoint: CGPointMake(10, 17)];
        [actionButtonPath addLineToPoint: CGPointMake(9, 17)];
        [actionButtonPath addLineToPoint: CGPointMake(9, 0.98)];
        [actionButtonPath closePath];
        [actionButtonPath moveToPoint: CGPointMake(13.99, 4.62)];
        [actionButtonPath addLineToPoint: CGPointMake(13.58, 5.01)];
        [actionButtonPath addCurveToPoint: CGPointMake(13.25, 5.02) controlPoint1: CGPointMake(13.49, 5.1) controlPoint2: CGPointMake(13.34, 5.11)];
        [actionButtonPath addLineToPoint: CGPointMake(9.43, 1.27)];
        [actionButtonPath addCurveToPoint: CGPointMake(9.44, 0.94) controlPoint1: CGPointMake(9.34, 1.18) controlPoint2: CGPointMake(9.35, 1.04)];
        [actionButtonPath addLineToPoint: CGPointMake(9.85, 0.56)];
        [actionButtonPath addCurveToPoint: CGPointMake(10.18, 0.55) controlPoint1: CGPointMake(9.94, 0.46) controlPoint2: CGPointMake(10.09, 0.46)];
        [actionButtonPath addLineToPoint: CGPointMake(14, 4.29)];
        [actionButtonPath addCurveToPoint: CGPointMake(13.99, 4.62) controlPoint1: CGPointMake(14.09, 4.38) controlPoint2: CGPointMake(14.08, 4.53)];
        [actionButtonPath closePath];
        [actionButtonPath moveToPoint: CGPointMake(5.64, 4.95)];
        [actionButtonPath addLineToPoint: CGPointMake(5.27, 4.56)];
        [actionButtonPath addCurveToPoint: CGPointMake(5.26, 4.23) controlPoint1: CGPointMake(5.18, 4.47) controlPoint2: CGPointMake(5.17, 4.32)];
        [actionButtonPath addLineToPoint: CGPointMake(9.46, 0.07)];
        [actionButtonPath addCurveToPoint: CGPointMake(9.79, 0.07) controlPoint1: CGPointMake(9.55, -0.02) controlPoint2: CGPointMake(9.69, -0.02)];
        [actionButtonPath addLineToPoint: CGPointMake(10.16, 0.47)];
        [actionButtonPath addCurveToPoint: CGPointMake(10.17, 0.8) controlPoint1: CGPointMake(10.25, 0.56) controlPoint2: CGPointMake(10.26, 0.71)];
        [actionButtonPath addLineToPoint: CGPointMake(5.97, 4.96)];
        [actionButtonPath addCurveToPoint: CGPointMake(5.64, 4.95) controlPoint1: CGPointMake(5.88, 5.05) controlPoint2: CGPointMake(5.74, 5.05)];
        [actionButtonPath closePath];
        [actionColor setFill];
        [actionButtonPath fill];
        
        actionButtonImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return actionButtonImage;
}
- (IBAction)redo_click:(id)sender {
    [_imageViewWithDraw redo];
    
}

- (IBAction)undo_click:(id)sender {
    [_imageViewWithDraw undo];
    
}

- (IBAction)delete_clicl:(id)sender {
    [_imageViewWithDraw del];
}


@end
