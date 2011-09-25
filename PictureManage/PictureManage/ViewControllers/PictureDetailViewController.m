//
//  PictureDetailViewController.m
//  PictureManage
//
//  Created by uzai on 11-8-28.
//  Copyright 2011年 UZAI. All rights reserved.
//
//  Modified by Agas on 11-9-25

#import "PictureDetailViewController.h"
#import "Picture.h"
#import "ShareEditViewController.h"

@implementation PictureDetailViewController


@synthesize toolView = _toolView;
@synthesize pictures,index;

- (void)hideAndShowToolView {

    if (_toolView.alpha == 0.f) {
        _toolView.alpha = 1.f;
        //self.navigationController.navigationBarHidden = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    else {
        _toolView.alpha = 0.f;
        //self.navigationController.navigationBarHidden = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
    }
}

-(void)dealloc{
    [pictures release];
    
    [preImageView release];
    [currentImageView release];
    [nextImageView release];
        
    [super dealloc];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];

    
    currentPage = self.index;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStyleBordered target:self action:@selector(doShare)];
    self.navigationItem.rightBarButtonItem=rightBarButton;
    [rightBarButton release];
    
    
    //scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 480-44)];
    CGFloat width = [[[[UIApplication sharedApplication] keyWindow] screen] bounds].size.width;
    CGFloat height = [[[[UIApplication sharedApplication] keyWindow] screen] bounds].size.height;
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, 480)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled =YES;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate= self;    
    NSInteger pageCount = [self.pictures count];

    CGSize newSize  = CGSizeMake(pageCount*320, 480);
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
    
    _toolView = [[[NSBundle mainBundle] loadNibNamed:@"ToolView" owner:self options:nil] objectAtIndex:0];
    _toolView.delegate = self;
    _toolView.center = CGPointMake(160, 360);
    _toolView.delegate = self;
    [self.view addSubview:_toolView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAndShowToolView)];
    [scrollView addGestureRecognizer:tap];
    [tap release];
}

-(void)caultePage:(NSInteger)aPage {
    currentPage=aPage;
    prePage = currentPage-1<0? [self.pictures count]-1:currentPage-1;
    nextPage = currentPage+1==[self.pictures count]?0:currentPage+1;
}

//每次set pre current nex 3张图片
-(void)createThreeImage{
    
    CGFloat width = 320;
    CGFloat height = 480;
    
    [self caultePage:self.index];
    
    preImageView = [[UIImageView alloc]initWithFrame:CGRectMake(prePage*width, 0, width, height)];
    preImageView.image  = [UIImage imageWithContentsOfFile:[[self.pictures objectAtIndex:prePage] imageUrl]];
    [scrollView addSubview:preImageView];
    
    currentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(currentPage*width, 0, width, height)];
    currentImageView.image  = [UIImage imageWithContentsOfFile:[[self.pictures objectAtIndex:currentPage] imageUrl]];
    [scrollView addSubview:currentImageView];
    
    nextImageView = [[UIImageView alloc]initWithFrame:CGRectMake(nextPage*width, 0, width, height)];
    nextImageView.image  = [UIImage imageWithContentsOfFile:[[self.pictures objectAtIndex:nextPage] imageUrl]];
    [scrollView addSubview:nextImageView];
    
    [scrollView setContentOffset:CGPointMake(currentPage *width, 0) animated:NO];
}





-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    
}

-(void)doShare{
    ShareEditViewController *shareEditViewController = [[ShareEditViewController alloc]init];
    shareEditViewController.image =  [UIImage imageWithContentsOfFile:[[self.pictures objectAtIndex:currentPage] imageUrl]];
    [self.navigationController pushViewController:shareEditViewController animated:YES];
    [shareEditViewController release];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
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
            currentPage ++;
        }
    }
    else{
        prePage--;
        if(prePage >=0){
        UIImageView  *newImageView =[ [UIImageView alloc]initWithFrame:CGRectMake(prePage*320, 0, 320, 480-44)];
        newImageView.image=[UIImage imageWithContentsOfFile:[[self.pictures objectAtIndex:prePage] imageUrl]];
        [aScrollView  addSubview:newImageView];
        [newImageView release];
            currentPage --;
        }
        
    }

    
}

#pragma mark - ToolView Delegate
- (void)beginEditing {

}

- (void)endEditingWithString:(NSString *)string {

}

- (void)sharePicture {

}

- (void)deletePicture {

}

@end
