//
//  ShareViewController.m
//  PictureManage
//
//  Created by uzai on 11-9-28.
//  Copyright 2011年 UZAI. All rights reserved.
//

#import "ShareViewController.h"


@implementation ShareViewController
@synthesize image;

- (void)dealloc
{
    [image release];
    [super dealloc];
}


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = @"分享";
    //背景图
    UIImageView *backGroundView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"about_bg.jpg"]];
    [backGroundView setFrame:CGRectMake(0, 0, 320, 480)];
    [self.view addSubview: backGroundView];

    
    UILabel *label = [[UILabel alloc]initWithFrame: CGRectMake(45, 200, 80, 30)];
    label.text = @"分享到 :";
    label.backgroundColor =[UIColor clearColor];
    [self.view addSubview:label];
    [label   release];
    
    
    UIButton *sinShare = [UIButton  buttonWithType:UIButtonTypeCustom];
    [sinShare setBackgroundImage:[UIImage imageNamed:@"share_btn_login_a_ThuSep22_141731_2011.png"] forState:UIControlStateNormal];
    [sinShare setTitle:@"新浪分享" forState:UIControlStateNormal];
    sinShare.frame = CGRectMake(45, 240, 230, 40 );
    [sinShare addTarget:self action:@selector(shareSinna) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sinShare];
    
    
    
    UIImageView *sinIcon  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_logo_sina_ThuSep22_141734_2011.png"]];
    sinIcon.frame =CGRectMake(30, 5, 30, 30);
    [sinShare addSubview:sinIcon];
    

    
    
}

-(void)shareSinna{
    ShareEditViewController *shareEditViewController = [[ShareEditViewController alloc]init];
    shareEditViewController.image = self.image;
    [self.navigationController pushViewController:shareEditViewController animated:YES];
    [shareEditViewController release];
}
@end
