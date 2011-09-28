//
//  PictureDetailViewController.h
//  PictureManage
//
//  Created by uzai on 11-8-28.
//  Copyright 2011年 UZAI. All rights reserved.
//
//  Modified by Agas on 11-9-25

#import <UIKit/UIKit.h>
#import "Picture.h"
#import "ToolView.h"

@interface PictureDetailViewController : UIViewController<UIScrollViewDelegate, ToolViewDelegate, UIAlertViewDelegate> {
    UIScrollView * scrollView;
    NSInteger currentPage;
    NSInteger prePage;
    NSInteger nextPage;
    
    UIImageView *preImageView;
    UIImageView *currentImageView;
    UIImageView *nextImageView;
    
    ToolView *_toolView;
}

@property(nonatomic,retain)NSMutableArray * pictures;
@property(nonatomic,assign)NSInteger index;
@property (nonatomic, retain) ToolView *toolView;

-(void)createThreeImage;

-(void)setThreeImage:(NSInteger)index;

@end
