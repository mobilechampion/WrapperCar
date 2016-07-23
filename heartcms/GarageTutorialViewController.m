//
//  GarageTutorialViewController.m
//  heartcms
//
//  Created by HaoYun Jin on 10/6/14.
//  Copyright (c) 2014 HaoYun Jin. All rights reserved.
//

#import "GarageTutorialViewController.h"

@interface GarageTutorialViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *tutorial_img;
@property (weak, nonatomic) IBOutlet UIButton *exit_btn;
@property (weak, nonatomic) IBOutlet UIButton *you_btn;

@end

@implementation GarageTutorialViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)viewWillAppear:(BOOL)animated{
     [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    if (self.isGra) {
       self. you_btn.hidden = YES;
        self.tutorial_img.image = [UIImage imageNamed:@"newscreentutorial.png"];
        
        [self.tutorial_img setFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
        
        [self.exit_btn setFrame:CGRectMake(0, 0, 320, 38)];
        
        [self.exit_btn setImage:[UIImage imageNamed:@"exitbutton_for_tut.png"] forState:UIControlStateNormal];
        
        
    }else{
        self.tutorial_img.image = [UIImage imageNamed:@"take_picture.png"];

        
        [self.tutorial_img setFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
        
        [self.exit_btn setFrame:CGRectMake(0, 0, 320, 38)];
        
        [self.exit_btn setImage:[UIImage imageNamed:@"exitbutton_for_tut.png"] forState:UIControlStateNormal];
             }
    
}
- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.isGra) {
            
        }else{
            
               [_gvDelegate Tutorial_Cancel:self didDissmissed:self.isSelectImageFromGallary];
            
        }
     
        
    }];
}
- (IBAction)orn_video:(id)sender {
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youtube.com/"]];
}

@end
