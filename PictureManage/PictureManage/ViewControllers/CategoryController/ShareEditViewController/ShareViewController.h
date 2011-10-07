//
//  ShareViewController.h
//  PictureManage
//
//  Created by uzai on 11-9-28.
//  Copyright 2011年 UZAI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ShareEditViewController.h"

@interface ShareViewController : UIViewController <MFMailComposeViewControllerDelegate> {
    
}

@property(nonatomic, retain)UIImage *image;

@end
