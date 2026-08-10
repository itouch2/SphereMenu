//
//  ViewController.m
//  SphereMenu
//
//  Created by Tu You on 14-8-24.
//  Copyright (c) 2014年 TU YOU. All rights reserved.
//

#import "ViewController.h"
#import "SphereMenu.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:1 green:0.58 blue:0.27 alpha:1];
    
//    UIImage *startImage = [UIImage imageNamed:@"start"];
//    UIImage *image1 = [UIImage imageNamed:@"icon-twitter"];
//    UIImage *image2 = [UIImage imageNamed:@"icon-email"];
//    UIImage *image3 = [UIImage imageNamed:@"icon-facebook"];
//    NSArray *images = @[image1, image2, image3];
//    SphereMenu *sphereMenu = [[SphereMenu alloc] initWithStartPoint:CGPointMake(CGRectGetWidth(self.view.frame) / 2, 320)
//                                                         startImage:startImage
//                                                      submenuImages:images];
//    sphereMenu.sphereDamping = 0.3;
//    sphereMenu.sphereLength = 85;
//    sphereMenu.delegate = self;
//    [self.view addSubview:sphereMenu];
}

- (void)sphereDidSelected:(int)index
{
    NSLog(@"sphere %d selected", index);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)startBtnAction:(id)sender
{
    [SphereMenu showSphereMenuWithAnchorView:self.btn
                                 anchorImage:[UIImage imageNamed:@"picked"]
                                 sphereMenus:^NSArray *{
                                     
                                     UIImage *image1 = [UIImage imageNamed:@"icon-twitter"];
                                     UIImage *image2 = [UIImage imageNamed:@"icon-email"];
                                     UIImage *image3 = [UIImage imageNamed:@"icon-facebook"];
                                     
                                     UIImage *image4 = [UIImage imageNamed:@"icon-twitter"];
                                     UIImage *image5 = [UIImage imageNamed:@"icon-email"];
                                     UIImage *image6 = [UIImage imageNamed:@"icon-facebook"];
                                     
                                     NSArray *images = @[@{key_sphere_menu_image:image1, key_sphere_menu_title:@"我想买"},
                                                         @{key_sphere_menu_image:image2, key_sphere_menu_title:@"大规模有"},
                                                         @{key_sphere_menu_image:image3, key_sphere_menu_title:@"暗黑破神"},
                                                         @{key_sphere_menu_image:image4, key_sphere_menu_title:@"大规木有"},
                                                         @{key_sphere_menu_image:image5, key_sphere_menu_title:@"大规木有"},
                                                         @{key_sphere_menu_image:image6, key_sphere_menu_title:@"模有木有"}];
                                     
                                     return images;
                                 }
                                  pickedMenu:^(NSInteger index, UIView *menu) {
                                      
                                      NSLog(@"picked index = %ld", index);
                                  }];
    
    
    
}

@end
