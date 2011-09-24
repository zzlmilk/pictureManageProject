//
//  HomeViewController.m
//  PictureManage
//
//  Created by uzai on 11-8-24.
//  Copyright 2011年 UZAI. All rights reserved.
//

#import "HomeViewController.h"
#import "CategoryViewController.h"
#import "CategoryDataSource.h"

#import "pictureDetailViewController.h"
#import "HomeViewDataSource.h"
#import "CategoryEditViewController.h"
#import "PathHelper.h"
#import "ImageImporterController.h"
#import "UIImage+Compress.h"
#import "UIImage+Resize.h"



#define toolImageLeftMagn 19
#define toolImageTopMagn 18

@implementation HomeViewController


- (void)dealloc
{
    [segmentedControl release];
    [_tableView release];
    [_scrollView release];
    [pictures release];
    [toolImages release];
    [categorys release];
    [segmentedControl release];
    [picture release];
    
    [super dealloc];
    
}


#pragma mark - View lifecycle

-(void)viewDidLoad{
    [super viewDidLoad];
    pictures = [[NSMutableArray alloc]init];
    
    [self setPictures:nil];
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 52, 320, 305) style:UITableViewStylePlain];
    _tableView.dataSource =self;
    _tableView.delegate= self;
    _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor =[UIColor clearColor];
    UIImageView *backGroundView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"about_bg.jpg"]];
    [backGroundView setFrame:CGRectMake(0, 0, 320, 480)];
    [self.view addSubview: backGroundView];
    [self.view addSubview:_tableView];
      //openFlow
    afOpenFlowView = [[AFOpenFlowView alloc] initWithFrame:CGRectMake(0, 52, 320, 305)];
    afOpenFlowView.dataSource = self;
    afOpenFlowView.viewDelegate = self;    
    [self.view addSubview:afOpenFlowView];
 
    
    
    UIView *buttonPoolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 52)];
   UIImageView *buttonPoolBG= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"main_menu_bottom_bg_ThuSep22_141728_2011.png"]];
    [buttonPoolBG setFrame:CGRectMake(-20, 0, 400, 52)];
    [buttonPoolView addSubview:buttonPoolBG];
    [buttonPoolBG release]  ;
       
    UIButton *manageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [manageButton setBackgroundImage:[UIImage imageNamed:@"main_menu_bottom_btn1_a_ThuSep22_141728_2011.png"] forState:UIControlStateNormal];
    [manageButton setTitle:@"管理" forState:UIControlStateNormal];
    manageButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [manageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [manageButton setFrame:CGRectMake(10, 10, 63, 32)];
    [manageButton addTarget:self action:@selector(doManageButton) forControlEvents:UIControlEventTouchUpInside];
    [buttonPoolView addSubview:manageButton];
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoButton setBackgroundImage:[UIImage imageNamed:@"main_menu_bottom_btn1_a_ThuSep22_141728_2011.png"] forState:UIControlStateNormal];
        photoButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [photoButton setTitle:@"照片" forState:UIControlStateNormal];
    [photoButton setFrame:CGRectMake(83, 10, 63, 32)];
    [photoButton addTarget:self action:@selector(doPhotoButton) forControlEvents:UIControlEventTouchUpInside];
    [buttonPoolView addSubview:photoButton];
    
    UIButton *importButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [importButton setBackgroundImage:[UIImage imageNamed:@"main_menu_bottom_btn1_a_ThuSep22_141728_2011.png"] forState:UIControlStateNormal];
    importButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [importButton setTitle:@"导入" forState:UIControlStateNormal];
    [importButton setFrame:CGRectMake(156, 10, 63, 32)];
    [importButton addTarget:self action:@selector(doImportButton) forControlEvents:UIControlEventTouchUpInside];
    [buttonPoolView addSubview:importButton];
    

    NSArray* items = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"ProductFeature_seg0_normal.png"],[UIImage imageNamed:@"ProductFeature_seg1_normal.png"],nil];
        segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
        CGRect re = CGRectMake(240, 10, 60, 30);
        segmentedControl.frame= re; 
        [segmentedControl addTarget:self action:@selector(segmentAction) forControlEvents:UIControlEventValueChanged];
        [items release];
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        segmentedControl.selectedSegmentIndex = 0;
        [buttonPoolView addSubview:segmentedControl];
    
    [self.view addSubview:buttonPoolView];
    [buttonPoolView release];
    
    //提示没有分组照片
    tipButtonImportPicture = [UIButton buttonWithType:UIButtonTypeCustom];
    [tipButtonImportPicture setFrame:CGRectMake(10, 180, 300, 60)];
    [tipButtonImportPicture setBackgroundImage:[UIImage imageNamed:@"main_menu_bottom_bg_ThuSep22_141728_2011.png" ]forState:UIControlStateNormal];
    [tipButtonImportPicture setTitle:@"您的分组暂无图片点击导入图片" forState:UIControlStateNormal];
    tipButtonImportPicture.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [tipButtonImportPicture addTarget:self action:@selector(doImportButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tipButtonImportPicture];
    [tipButtonImportPicture setHidden:YES];
    

    
}

-(Picture *)getFirstPictureByCategory:(NSString *)categoryName{
    if(categoryName){
        NSArray *arr  = [NSArray array];
        picture = [[[Picture alloc]init] autorelease];

        arr  = [[HomeViewDataSource imagesInfoWithCategory:categoryName] retain];
        if([arr objectAtIndex:0] ==nil){
            picture.imageUrl = @"filter_grayscale_a_ThuSep22_141721_2011.png";
            picture.imageThumbnailUrl=@"filter_grayscale_a_ThuSep22_141721_2011.png";
            picture.belongCategory = @"notUser";
        }
        else{
        picture.imageUrl = [[arr objectAtIndex:0] objectForKey:@"name"];
        picture.imageThumbnailUrl=[[arr objectAtIndex:0] objectForKey:@"nameThumbnail"];
        picture.imageDescript = [NSString stringWithFormat:@"%i图片哦",0];
        picture.belongCategory = [[arr objectAtIndex:0] objectForKey:@"category"];
        }
    }
    return picture;
    
}

-(void)setPictures:(NSString *)categoryName{
     [pictures removeAllObjects];
    NSArray *arr  = [NSArray array];
    if ([[CategoryDataSource categorys] count] == 0) {
        [PathHelper createPathIfNecessary:@"default"];
        arr  = [[HomeViewDataSource imagesInfoWithCategory:@"default"] retain];
    }
    else{
        if(categoryName ==nil){
          categoryName= [PathHelper documentDirectory];
            
        }
         arr  = [[HomeViewDataSource imagesInfoWithCategory:categoryName] retain];
        if ([arr count] == 0) {
            //这个分组没有照片
            [tipButtonImportPicture setHidden:NO];
             
        }
        else{
            [tipButtonImportPicture setHidden:YES];
        }
    }
   
   

    for (int i =0; i<[arr count]; i++) {
        picture = [[Picture alloc]init];
        picture.imageUrl = [[arr objectAtIndex:i] objectForKey:@"name"];
        picture.imageThumbnailUrl=[[arr objectAtIndex:i] objectForKey:@"nameThumbnail"];
        picture.imageDescript = [NSString stringWithFormat:@"%i图片哦",i];
        picture.belongCategory = [[arr objectAtIndex:i] objectForKey:@"category"];
        [pictures addObject:picture];
        [picture release];
    }
    [_tableView reloadData];
    //[afOpenFlowView setNumberOfImages:[pictures count]];
    [afOpenFlowView updateAllImage];
    [afOpenFlowView setNumberOfImages:[pictures count]];
    
}

-(void)segmentAction{
    NSInteger segIndex= segmentedControl.selectedSegmentIndex;
    if (segIndex == 0) {
        [afOpenFlowView setHidden:YES];
        [_tableView setHidden:NO];
        
        [segmentedControl setImage:[UIImage imageNamed:@"ProductFeature_seg0_selected.png"] forSegmentAtIndex:0];
        [segmentedControl setImage:[UIImage imageNamed:@"ProductFeature_seg1_normal.png"] forSegmentAtIndex:1];
        
    }
    else if(segIndex ==1){
        [afOpenFlowView setNumberOfImages:[pictures count]];
        [afOpenFlowView defaultImage];
        [afOpenFlowView setHidden:NO];
        [_tableView setHidden:YES];
        [segmentedControl setImage:[UIImage imageNamed:@"ProductFeature_seg0_normal.png"] forSegmentAtIndex:0];
        [segmentedControl setImage:[UIImage imageNamed:@"ProductFeature_seg1_selected.png"] forSegmentAtIndex:1];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden= YES;
    if(_scrollView){
        [_scrollView removeFromSuperview];
        [_scrollView release];
    }
    [self performSelector:@selector(initScrollView)];
    [_tableView reloadData];
   }

-(void)doManageButton{
    CategoryViewController *categoryViewController = [[CategoryViewController alloc]init];
    
    [self.navigationController pushViewController:categoryViewController animated:YES];
    [categoryViewController release];
    
}

-(void)doPhotoButton{
    if ([ImageImporterController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        ImageImporterController *picker = [[ImageImporterController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController pushViewController:picker animated:YES];
        [picker release];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您的设备不支持照相机" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    }
}
-(void)doImportButton{
        
    ImageImporterController *importer = [[ImageImporterController alloc] initWithCamera:NO];
    importer.delegate = self;
    [self presentModalViewController:importer animated:YES];
    [importer release];
}

#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(ImageImporterController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    if([picker.selectedImages count]>19){
        [[PictureManageAppDelegate getAppDelegate] alert:@"提示" message:@"图片超过20了哦，有点过多请先导入"];
    }
    else{
    [picker.selectedImages addObject:image];
    if(!picker.isUsingCamera){
        [picker updateToolBarInfo];
    }
    }

}
-(void)ImageImporterFinsh:(NSString *)categateName{
    [pictures removeAllObjects];
    [self setPictures:categateName];
}

- (void)imagePickerControllerDidCancel:(ImageImporterController *)picker {
    
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)initScrollView{
    _scrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 305+52+15, 320, 89)];
    UIImageView *buttonPoolBG= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ad_bg_ThuSep22_113202_2011.png"]];
    [buttonPoolBG setFrame:CGRectMake(0, 0, 320, 98)];
    [_scrollView addSubview:buttonPoolBG];
    [self.view addSubview:_scrollView];

    _scrollView.pagingEnabled =YES;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate=self;
    
    categorys = [CategoryDataSource categorys];
    
    NSInteger categorysNum = [categorys count];
    NSInteger pageNum = categorysNum/4;
    if (categorysNum %4 !=0) {
        pageNum ++;
    }
    CGSize newSize = CGSizeMake(self.view.frame.size.width * pageNum, 89);
    [buttonPoolBG setFrame:CGRectMake(0, 0, self.view.frame.size.width * pageNum, 89)];
    [_scrollView addSubview:buttonPoolBG];
    [self.view addSubview:_scrollView];

    _scrollView.contentSize = newSize;

    for (int i = 0; i<categorysNum; i++) {
        
      Picture *fPict=  [self getFirstPictureByCategory:[categorys objectAtIndex:i]];
        ImageView *imageView ;
        if ([fPict belongCategory] ==@"notUser") {
            imageView  = [[ImageView alloc] initWithFrame:CGRectMake(toolImageLeftMagn+(i*toolImageLeftMagn)+i*60,toolImageTopMagn , 30, 30) imageURL:[fPict imageThumbnailUrl]];
        }
        else{
         imageView  = [[ImageView alloc] initWithFrame:CGRectMake(toolImageLeftMagn+(i*toolImageLeftMagn)+i*60,toolImageTopMagn , 40, 40) imageFileURL:[fPict imageThumbnailUrl]];
        }
        
        [_scrollView addSubview:imageView];
        imageView.imageObject = [categorys objectAtIndex:i];
                    imageView.imageViewDelegate =self;
        [imageView release];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(toolImageLeftMagn+(i*toolImageLeftMagn)+i*60, toolImageTopMagn+40, 53, 30)];
        label.text = [categorys objectAtIndex:i];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textAlignment= UITextAlignmentLeft;
        [_scrollView addSubview:label];
        
//        
//        NSString *_string = [NSString stringWithString:imageView.imageObject];
//        CGSize LabelSize = [_string sizeWithFont:label.font 
//                               constrainedToSize:label.frame.size
//                                   lineBreakMode:UILineBreakModeCharacterWrap];
        

        [label release];
    }
    
}



#pragma mark -  tableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger num =[pictures count]/3;
    if ([pictures count] %3 !=0) {
        num ++;
    }
    
    return num;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"imageCell";
    HomeViewImageCell *cell = (HomeViewImageCell *) [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell==nil){
        cell = [[[HomeViewImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
    }
    cell.imageCellDidSelectImage =self;
    cell.puctures = pictures;
    cell.indexPath = indexPath;
    [cell fillCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}



#pragma mark -
#pragma mark AFOpenFlowViewDataSource AFOpenFlowViewDelegate methods
- (void)openFlowView:(AFOpenFlowView *)openFlowView didSelectAtIndex:(int)index{    
    PictureDetailViewController *pictureDetailViewController =[[PictureDetailViewController alloc]init];
    pictureDetailViewController.pictures =pictures;
    pictureDetailViewController.index = index;
    [self.navigationController pushViewController:pictureDetailViewController animated:YES];
    [pictureDetailViewController release];
}


-(void)openFlowView:(AFOpenFlowView *)openFlowView requestImageForIndex:(int)index{    
    
    NSString *imageUrl = [[pictures objectAtIndex:index] imageUrl];
    UIImage *image = [UIImage imageWithContentsOfFile:imageUrl];
    UIImage *newImage = [image resizeImageWithNewSize:CGSizeMake(255, 255)]; //把图片大小设成255＊255

  //    UIImage *newImage = [image resizedImage:CGSizeMake(255, 255) interpolationQuality:2]; on device test !
    
    [openFlowView setImage: newImage forIndex:index];
    
}
- (UIImage *)defaultImage{
	return [UIImage imageNamed:@"0.jpg"];
}


- (void)onClickEvent:(ImageView*)aImageView imageObject:(id)aImageObject{
    //scroll 工具条
    [pictures removeAllObjects];
    [self setPictures:aImageObject];
}


#pragma mark-- ImageCell Delegate
-(void)imageDidSelectIndex:(NSInteger)index{
    PictureDetailViewController *pictureDetailViewController =[[PictureDetailViewController alloc]init];
    pictureDetailViewController.pictures =pictures;
    pictureDetailViewController.index = index;
    [self.navigationController pushViewController:pictureDetailViewController animated:YES];
    [pictureDetailViewController release];
}

@end
