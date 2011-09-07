//
//  PictureDetailViewController.m
//  PictureManage
//
//  Created by uzai on 11-8-28.
//  Copyright 2011年 UZAI. All rights reserved.
//

#import "PictureDetailViewController.h"
#import "Picture.h"
#import "ShareEditViewController.h"

@implementation PictureDetailViewController



@synthesize pictures,index;
-(void)dealloc{
    [pictures release];
    
    [preImageView release];
    [currentImageView release];
    [nextImageView release];
    
    [super dealloc];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    currentPage = self.index;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStyleBordered target:self action:@selector(doShare)];
    self.navigationItem.rightBarButtonItem=rightBarButton;
    [rightBarButton release];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 480-44)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled =YES;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate= self;    
    NSInteger pageCount = [self.pictures count];

    CGSize newSize  = CGSizeMake(pageCount*320, 480 -44);
    scrollView.contentSize = newSize;
    
    //fill image
//    for (int i=0; i<pageCount; i++) {
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*320, 0, 320, 480-44)];
//        imageView.image  = [UIImage imageWithContentsOfFile:[[self.pictures objectAtIndex:i] imageUrl]];
//        [scrollView addSubview:imageView];
//        [imageView release];
//    } 
    
    [self.view addSubview:scrollView];
    [self  createThreeImage];    
    
 
    
}

-(void)caultePage:(NSInteger)aPage {
    currentPage=aPage;
    prePage = currentPage-1<0? [self.pictures count]-1:currentPage-1;
    nextPage = currentPage+1==[self.pictures count]?0:currentPage+1;
}

//每次set pre current nex 3张图片
-(void)createThreeImage{
    
    [self caultePage:self.index];
    
    preImageView = [[UIImageView alloc]initWithFrame:CGRectMake(prePage*320, 0, 320, 480-44)];
    preImageView.image  = [UIImage imageWithContentsOfFile:[[self.pictures objectAtIndex:prePage] imageUrl]];
    [scrollView addSubview:preImageView];
    
    currentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(currentPage*320, 0, 320, 480-44)];
    currentImageView.image  = [UIImage imageWithContentsOfFile:[[self.pictures objectAtIndex:currentPage] imageUrl]];
    [scrollView addSubview:currentImageView];
    
    nextImageView = [[UIImageView alloc]initWithFrame:CGRectMake(nextPage*320, 0, 320, 480-44)];
    nextImageView.image  = [UIImage imageWithContentsOfFile:[[self.pictures objectAtIndex:nextPage] imageUrl]];
    [scrollView addSubview:nextImageView];
    
    [scrollView setContentOffset:CGPointMake(currentPage *320, 0) animated:NO];
}


-(void)setThreeImage:(NSInteger)aPage{


}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;    
    
}

-(void)doShare{
    ShareEditViewController *shareEditViewController = [[ShareEditViewController alloc]init];
    shareEditViewController.image =  [UIImage imageWithContentsOfFile:[[self.pictures objectAtIndex:currentPage] imageUrl]];
    [self.navigationController pushViewController:shareEditViewController animated:YES];
    [shareEditViewController release];
}


#pragma mark --ScrollerView Delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
        
}


-(void)scrollViewDidEndDragging:(UIScrollView *)aScrollView willDecelerate:(BOOL)decelerate{
    if(aScrollView.contentOffset.x/320>currentPage){
        //forword right
        nextPage++;
        if(nextPage <[self.pictures count]){
        UIImageView  *newImageView =[ [UIImageView alloc]initWithFrame:CGRectMake(nextPage*320, 0, 320, 480-44)];
        newImageView.image=[UIImage imageWithContentsOfFile:[[self.pictures objectAtIndex:nextPage] imageUrl]];
        [aScrollView  addSubview:newImageView];
        [newImageView release];
        }
    }
    else{
        prePage++;
        if(prePage >=0){
        UIImageView  *newImageView =[ [UIImageView alloc]initWithFrame:CGRectMake(prePage*320, 0, 320, 480-44)];
        newImageView.image=[UIImage imageWithContentsOfFile:[[self.pictures objectAtIndex:prePage] imageUrl]];
        [aScrollView  addSubview:newImageView];
        [newImageView release];
        }

    }
    
}




@end
