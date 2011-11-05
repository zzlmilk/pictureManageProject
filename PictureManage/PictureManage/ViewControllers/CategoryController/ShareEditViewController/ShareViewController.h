//
//  ShareViewController.h
//  PictureManage
//
//  Created by uzai on 11-9-28.
//  Copyright 2011年 UZAI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareEditViewController.h"
#import "Renren.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface ShareViewController : UIViewController <MFMailComposeViewControllerDelegate> {

    
}

@property(nonatomic, retain)UIImage *image;

@end
