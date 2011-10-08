//
//  ShareEditViewController.h
//  PictureManage
//
//  Created by uzai on 11-9-2.
//  Copyright 2011年 UZAI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthController.h"
#import "WeiboClient.h"
#import "draft.h"
#import "Renren.h"

typedef enum{
    sinaType,
    renrenType,
    
} ShareType;


   @class OAuthEngine;
@interface ShareEditViewController : UIViewController<OAuthControllerDelegate,UITextViewDelegate,RRSessionDelegate,RRDialogDelegate> {
    UITextView* textview;
    UIImageView *imageView;
    ShareType sType;
    OAuthEngine				*_engine;
	WeiboClient *weiboClient;
    Draft *draft;
    
     Renren* _renren;
}


@property(nonatomic, retain)UIImage *image;
@property(nonatomic,assign)ShareType sType;
-(void)postNewStatus;
- (void)cancel;
@end
