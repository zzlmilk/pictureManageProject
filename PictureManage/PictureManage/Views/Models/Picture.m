//
//  Picture.m
//  PictureManage
//
//  Created by uzai on 11-8-27.
//  Copyright 2011年 UZAI. All rights reserved.
//

#import "Picture.h"


@implementation Picture
@synthesize imageUrl,imageDescript,belongCategory,imageThumbnailUrl;
-(void)dealloc{
    [imageUrl release];
    [imageThumbnailUrl release];
    [imageDescript release];
    [belongCategory  release];
    [super dealloc];
}

@end
