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
    
    self.navigationItem.title = @"分享照片";
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
    
    UIButton *renShare = [UIButton  buttonWithType:UIButtonTypeCustom];
    [renShare setBackgroundImage:[UIImage imageNamed:@"share_btn_login_ren_b_ThuSep22_141731_2011.png"] forState:UIControlStateNormal];
    [renShare setTitle:@"人人分享" forState:UIControlStateNormal];
    renShare.frame = CGRectMake(45, 290, 230, 40 );
    [renShare addTarget:self action:@selector(shareRenren) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:renShare];
    
    
    UIButton *emailShare = [UIButton  buttonWithType:UIButtonTypeCustom];
    [emailShare setBackgroundImage:[UIImage imageNamed:@"share_btn_login_a_ThuSep22_141731_2011.png"] forState:UIControlStateNormal];
    [emailShare setTitle:@"通过电子邮件分享" forState:UIControlStateNormal];
    emailShare.frame = CGRectMake(45, 300, 230, 40 );
    [emailShare addTarget:self action:@selector(shareWithEmail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:emailShare];
    
    UIButton *renrenShare = [UIButton  buttonWithType:UIButtonTypeCustom];
    [renrenShare setBackgroundImage:[UIImage imageNamed:@"share_btn_login_a_ThuSep22_141731_2011.png"] forState:UIControlStateNormal];
    [renrenShare setTitle:@"分享到人人" forState:UIControlStateNormal];
    renrenShare.frame = CGRectMake(45, 360, 230, 40 );
    [renrenShare addTarget:self action:@selector(shareWithRenren) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:renrenShare];
    
    
    UIImageView *sinIcon  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_logo_sina_ThuSep22_141734_2011.png"]];
    sinIcon.frame =CGRectMake(30, 5, 30, 30);
    [sinShare addSubview:sinIcon];
    
    UIImageView *renIcon  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_logo_ren_ThuSep22_141733_2011.png"]];
    renIcon.frame =CGRectMake(30, 5, 30, 30);
    [renShare addSubview:renIcon];
    
    
}

-(void)shareSinna{
    ShareEditViewController *shareEditViewController = [[ShareEditViewController alloc]init];
    shareEditViewController.image = self.image;
    shareEditViewController.sType = sinaType;
    [self.navigationController pushViewController:shareEditViewController animated:YES];
    [shareEditViewController release];
}

-(void)shareRenren{
    ShareEditViewController *shareEditViewController = [[ShareEditViewController alloc]init];
    shareEditViewController.image = self.image;
    shareEditViewController.sType = renrenType;
    [self.navigationController pushViewController:shareEditViewController animated:YES];
    [shareEditViewController release];

}


#pragma mark - Mail Delegate
- (void)shareWithEmail {
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.navigationBar.barStyle = UIBarStyleBlackOpaque;
    picker.mailComposeDelegate = self;
    [picker setSubject:[NSString stringWithFormat:@"分享照片"]];
    
    [picker setMessageBody:@"I share you this nice image from iFashion." isHTML:NO];
    
    
    [picker addAttachmentData:UIImagePNGRepresentation([self image]) mimeType:@"image/png" fileName:@"SharePicture.png"];
    picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:picker animated:YES];
    [picker release];
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
    
	[self dismissModalViewControllerAnimated:YES];
}

- (void)shareWithSMS {
    
}

- (void)shareWithRenren {

}
@end
