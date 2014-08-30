//
//  ViewController.m
//  SphereMenu
//
//  Created by Tu You on 14-8-24.
//  Copyright (c) 2014年 TU YOU. All rights reserved.
//

#import "ViewController.h"
#import "SphereMenu.h"

@interface ViewController () <SphereMenuDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:1 green:0.58 blue:0.27 alpha:1];
    
    UIImage *startImage = [UIImage imageNamed:@"start"];
    UIImage *image1 = [UIImage imageNamed:@"icon-twitter"];
    UIImage *image2 = [UIImage imageNamed:@"icon-email"];
    UIImage *image3 = [UIImage imageNamed:@"icon-facebook"];
    NSArray *images = @[image1, image2, image3];
    SphereMenu *sphereMenu = [[SphereMenu alloc] initWithStartPoint:CGPointMake(160, 320) startImage:startImage submenuImages:images];
    sphereMenu.delegate = self;
    [self.view addSubview:sphereMenu];
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

@end
