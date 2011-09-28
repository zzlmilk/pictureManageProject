//
//  CategoryEditViewController.m
//  PictureManage
//
//  Created by uzai on 11-8-27.
//  Copyright 2011年 UZAI. All rights reserved.
//

#import "CategoryEditViewController.h"
#import "PathHelper.h"

@implementation CategoryEditViewController
@synthesize isRename;

- (void)dealloc
{
    [textField release];
    [super dealloc];
}
-(void)viewDidLoad{
    [super viewDidLoad];  
    
    //背景图
    UIImageView *backGroundView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"about_bg.jpg"]];
    [backGroundView setFrame:CGRectMake(0, 0, 320, 480)];
    [self.view addSubview: backGroundView];


    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 68, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"分类名 :";
    label.font = [UIFont systemFontOfSize:18.0f];
    [self.view addSubview:label];
    [label release];
    
    
    textField = [[UITextField alloc]initWithFrame:CGRectMake(100, 30, 200, 30)];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:16.0f];
    textField.borderStyle  =UITextBorderStyleRoundedRect;
    [self.view addSubview:textField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"btns_bg_ThuSep22_113202_2011.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doButton) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(100, 80, 70, 30)];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:button];

    
}
-(void)doButton{
    if([PathHelper createPathIfNecessary:textField.text]){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!self.isRename){
        self.navigationItem.title=@"添加新分类";
    }
    else{
        self.navigationItem.title =@"修改分类";
    }
    
    
    
}
@end
