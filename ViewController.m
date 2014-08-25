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

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.49 green:0.76 blue:0.38 alpha:1];
    
    UIImage *startImage = [UIImage imageNamed:@"start"];
    NSArray *images = @[[UIImage imageNamed:@"share_email_button_normal"], [UIImage imageNamed:@"share_twitter_button_normal"], [UIImage imageNamed:@"share_facebook_button_normal"]];
    SphereMenu *sphereMenu = [[SphereMenu alloc] initWithStartPoint:CGPointMake(160, 200) startImage:startImage submenuImages:images];
    [self.view addSubview:sphereMenu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
