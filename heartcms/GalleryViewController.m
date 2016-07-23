//
//  GalleryViewController.m
//  heartcms
//
//  Created by HaoYun Jin on 10/6/14.
//  Copyright (c) 2014 HaoYun Jin. All rights reserved.
//

#import "GalleryViewController.h"
#import "AppDelegate.h"
#import "GarageTutorialViewController.h"
#define CAR_COUNT 13
@interface GalleryViewController (){
    int current_page;
    BOOL icSHowed;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end

@implementation GalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)next_click:(id)sender {
    current_page ++;
    if (current_page == CAR_COUNT) {
        current_page = 0;
    }

    [self.scrollview setContentOffset:CGPointMake(current_page * self.scrollview.bounds.size.width, 0) animated:YES];

    
}
- (IBAction)back_click:(id)sender {
    current_page --;
    if (current_page < 0) {
        current_page = CAR_COUNT - 1;
    }
    [self.scrollview setContentOffset:CGPointMake(current_page * self.scrollview.bounds.size.width, 0) animated:YES];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    current_page = 0;
    int w = self.scrollview.bounds.size.width;
    int h = self.scrollview.bounds.size.height;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0,0,w * CAR_COUNT, h)];
    NSArray * arar = [NSArray arrayWithObjects:@"ka-lightblue",@"mini-cooper-blue",@"VWGlofGreen", @"BMW-M4-matteBrown",@"gtr-mattegreen",@"bmw_2",@"rangeroversport-mattblue",
         @"Aston-Martin-Virage-MattePink",
                   @"Audi-r8-matte-gold",
                      @"Bentley-Continental-GT-matte-red",@"Ferrari-458-matte-purple",
                      @"LaFerrari-gloss-green",@"LamborghiniAventador-gloss-yellow",
                      nil];
    
    
    
    
    NSArray * arar_name = [NSArray arrayWithObjects:@"Ford KA",@"Mini Cooper",@"VW Golf",@"BMW M4", @"Nissan GTR",@"Porsche 911",@"Range Rover Sport",
                           @"Aston Martin",
                           @"Audi R8",
                           @"Bentley Continental GT",
                            @"Ferrari 458",
                           @"LaFerrari",
                           @"L. Aventador",
                           
                           nil];
    
    
    [self.scrollview addSubview:view];
    for (int i = 0;  i < CAR_COUNT;  i ++) {
        UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(i*w,0, w, h)];
        [imv setContentMode:UIViewContentModeScaleAspectFit];
        [view addSubview:imv];
        imv.image = [UIImage imageNamed:[arar objectAtIndex:i]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
        [imv addGestureRecognizer:tap];
        imv.tag = i ;
         imv.userInteractionEnabled = YES;
        
        UILabel * ul = [[UILabel alloc] initWithFrame:CGRectMake(i*w, 230, w, 70)];
        ul.font=[UIFont fontWithName:@"Tekton pro" size:25];
        ul.textAlignment = NSTextAlignmentCenter;
            ul.text =[arar_name objectAtIndex:i];
    
        [view addSubview:ul];
        

        
        
    }
    
    
    // Do any additional setup after loading the view.
}
- (void)imageViewTapped:(UITapGestureRecognizer *)sender;
{
       NSUInteger index = [[sender view] tag];
        if ([_gvDelegate respondsToSelector:@selector(gallerviewcontroller:didSelectedImage:)]) {
        AppDelegate * app = [[UIApplication sharedApplication] delegate];
        app.car_number = index;
            NSArray * arar = [NSArray arrayWithObjects:@"ka-lightblue",@"mini-cooper-blue",@"VWGlofGreen", @"BMW-M4-matteBrown",@"gtr-mattegreen",@"bmw_2",@"rangeroversport-mattblue",
                              @"Aston-Martin-Virage-MattePink",
                              @"Audi-r8-matte-gold",
                              @"Bentley-Continental-GT-matte-red",@"Ferrari-458-matte-purple",
                              @"LaFerrari-gloss-green",@"LamborghiniAventador-gloss-yellow",
                              nil];
            UIImage *image = [UIImage imageNamed:[arar objectAtIndex:index]];
        [_gvDelegate gallerviewcontroller:self didSelectedImage:image];
    }
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

-(void) viewDidAppear:(BOOL)animated{
    
    if (!icSHowed) {
        GarageTutorialViewController *gvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GarageTutorialViewController"];
        gvc.isGra = YES;
        [self presentViewController:gvc animated:YES completion:nil];
        icSHowed = YES;
    }
    
}

@end
