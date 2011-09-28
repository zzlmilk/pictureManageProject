//
//  ImageImporterController.m
//  almondz
//
//  Created by 卞中杰 on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ImageImporterController.h"
#import "CategoryViewController.h"
#import "CategoryDataSource.h"
#import "PathHelper.h"
#import "ImageSavingOperation.h"
#import "Hash.h"

#import "RotateUIImage.h"
#import "UIImage+Compress.h"
#import "UIImage+Resize.h"
@implementation ImageImporterController
@synthesize  selectedImages= _selectedImages ,isUsingCamera=_isUsingCamera,delegate;
-(id)initWithCamera:(BOOL)isUsingCamera
{
    self = [super init];
    if(self){
        _isUsingCamera =isUsingCamera;
        _selectedImages = [[NSMutableArray alloc]init];
        _imageNumber = 0;
        if (!_isUsingCamera) {
            UIToolbar *tool = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, 320, 44)];
            tool.barStyle = UIBarStyleBlackOpaque;
            [self.view addSubview:tool];
                        UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"导入" style:UIBarButtonSystemItemPlay target:self action:@selector(showDialogView)];
                        UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"清零" style:UIBarButtonItemStyleBordered target:self action:@selector(clearSelected)];
                        NSString *info = [NSString stringWithFormat:@"您选择了%d张照片", _imageNumber];
            _imageSelectedInfo = [[UIButton alloc] initWithFrame:CGRectMake(12, 7, 149, 31)];
            [_imageSelectedInfo setTitle:info forState:UIControlStateNormal];
            _imageSelectedInfo.userInteractionEnabled = NO;
            UIBarButtonItem *imageInfo = [[UIBarButtonItem alloc] initWithCustomView:_imageSelectedInfo];
            UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            [tool setItems:[NSArray arrayWithObjects:clearButton, flex, imageInfo, flex, okButton, nil] animated:YES];
            [tool release];
            [flex release];
            [imageInfo release];
            [okButton release];
            [clearButton release];
            
            
            //DialogView
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DialogView" owner:self options:nil];
            _dialogView = [array objectAtIndex:0];
            _dialogView.delegate = self;
            _dialogView.alpha = 0.f;
            CGPoint point = CGPointMake(160, 270);
            _dialogView.center = point;
            [self.view addSubview:_dialogView];
            
            UITextField *field = (UITextField *)[_dialogView viewWithTag:99];
            NSArray *_categorys = [CategoryDataSource categorys];
            if ([_categorys count]>0) {
                field.text = [_categorys objectAtIndex:0];
            }
            else{
                //提示需要添加分组
            }
        }

    }
    return self;
}


-(void)dealloc{
    delegate = nil;
    [_selectedImages release];
    [_imageSelectedInfo release];
    [super dealloc];
}

-(void)showDialogView{
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:.5f];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_dialogView cache:YES];
    _dialogView.alpha = 1.f;
    [UIView commitAnimations];
}

-(void)clearSelected{
    [_selectedImages removeAllObjects];
    [self updateToolBarInfo];
}

- (void)updateToolBarInfo {
    NSString *info = [NSString stringWithFormat:@"您选择了%d张照片", [_selectedImages count]];
    
    [_imageSelectedInfo setTitle:info forState:UIControlStateNormal];
}

#pragma mark-- DialogView Delegate
- (void)importImageswithCategory:(NSString *)categoryName detial:(NSString *)detail{
    if ([categoryName isEqualToString:@""]) {
        return;
    }
    NSString *path = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), categoryName];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        for (int i = 0; i < [_selectedImages count]; i++) {
            
        //对image 处理 1.转向 2.等比例的缩放 3.大小压缩
        
        UIImage *image =  [_selectedImages objectAtIndex:i];
         
            
        ////等比例的缩放
            NSLog(@"%d",image.imageOrientation);
           // image=[self scaleAndRotateImage:image :320 :480];
            if (image.imageOrientation==0 || image.imageOrientation ==1) {
                 image = [self scaleImage:image maxWidth:320 maxHeight:480];
            }
            else{
                NSLog(@"%d",image.imageOrientation);
                image = [self scaleImage:image maxWidth:480-44 maxHeight:320];
            }
           
            NSLog(@"w:%f h:%f",image.size.width,image.size.height);
                
        ////压缩
        NSData *imgData = UIImagePNGRepresentation(image);
            NSString *date = [NSString stringWithFormat:@"%@%d", [[NSDate date] description], i];
            NSString *name = [Hash md5:date];
            NSString *imgPath = [NSString stringWithFormat:@"%@/%@", path, name];
            [imgData writeToFile:imgPath atomically:YES];
            //生成缩略图 start
            CGSize newSize = CGSizeMake(80, 80);
            UIImage *imageThumbnail = [image resizeImageWithNewSize:newSize];
            imageThumbnail = [imageThumbnail compressedImage];
            NSString *imgThumbnailPath = [NSString stringWithFormat:@"%@/%@.thumbnail", path, name];
            NSData *imgThumbnailData = UIImagePNGRepresentation(imageThumbnail);
            [imgThumbnailData writeToFile:imgThumbnailPath atomically:YES];
            ////end
            
            
            NSString *detailFile = [NSString stringWithFormat:@"%@/Details.plist", path];
            NSMutableArray *detailArray;
            NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:detailFile];
            if ([array count])
                detailArray = [[NSMutableArray alloc] initWithArray:array copyItems:YES];
            else
                detailArray = [[NSMutableArray alloc] init];
            NSDictionary *detailDic = [NSDictionary dictionaryWithObjectsAndKeys:imgPath, @"name",imgThumbnailPath,@"nameThumbnail", [detail isEqualToString:@""] ? @"点击以修改详细信息" : detail, @"detail", categoryName, @"category", nil];
            [detailArray addObject:detailDic];
            [detailArray writeToFile:detailFile atomically:YES];
            
            
            
            
        }
    
    if([self.delegate respondsToSelector:@selector(ImageImporterFinsh:)]){
        [self.delegate ImageImporterFinsh:categoryName];
    }
    
    [self dismissModalViewControllerAnimated:YES]; 
    
}



- (UIImage *)scaleImage:(UIImage *) image maxWidth:(float) maxWidth maxHeight:(float) maxHeight   
{   
    CGImageRef imgRef = image.CGImage;   
    CGFloat width = CGImageGetWidth(imgRef);   
    CGFloat height = CGImageGetHeight(imgRef);   
    if (width <= maxWidth && height <= maxHeight)   
    {   
        return image;   
    }   
    CGAffineTransform transform = CGAffineTransformIdentity;   
    CGRect bounds = CGRectMake(0, 0, width, height);   
    if (width > maxWidth || height > maxHeight)   
    {   
        CGFloat ratio = width/height;   
        if (ratio > 1)   
        {   
            bounds.size.width = maxWidth;   
            bounds.size.height = bounds.size.width / ratio;   
        }   
        else   
        {   
            bounds.size.height = maxHeight;   
            bounds.size.width = bounds.size.height * ratio;   
        }   
    }   
    CGFloat scaleRatio = bounds.size.width / width;   
    UIGraphicsBeginImageContext(bounds.size);   
    CGContextRef context = UIGraphicsGetCurrentContext();   
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);   
    CGContextTranslateCTM(context, 0, -height);   
    CGContextConcatCTM(context, transform);   
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);   
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();   
    UIGraphicsEndImageContext();   
    return imageCopy;   
} 


-(UIImage*) scaleAndRotateImage:(UIImage*)photoimage:(CGFloat)bounds_width:(CGFloat)bounds_height   
{   
    //int kMaxResolution = 300;   
    CGImageRef imgRef =photoimage.CGImage;   
    CGFloat width = CGImageGetWidth(imgRef);   
    CGFloat height = CGImageGetHeight(imgRef);   
    CGAffineTransform transform = CGAffineTransformIdentity;   
    CGRect bounds = CGRectMake(0, 0, width, height);   
    /*if (width > kMaxResolution || height > kMaxResolution)   
     {   
     CGFloat ratio = width/height;   
     if (ratio > 1)   
     {   
     bounds.size.width = kMaxResolution;   
     boundsbounds.size.height = bounds.size.width / ratio;   
     }   
     else   
     {   
     bounds.size.height = kMaxResolution;   
     boundsbounds.size.width = bounds.size.height * ratio;   
     }   
     }*/   
    bounds.size.width = bounds_width;   
    bounds.size.height = bounds_height;   
    CGFloat scaleRatio = bounds.size.width / width;   
    CGFloat scaleRatioheight = bounds.size.height / height;   
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));   
    CGFloat boundHeight;   
    UIImageOrientation orient =photoimage.imageOrientation;   
    switch(orient)   
    {   
        case UIImageOrientationUp: //EXIF = 1   
            transform = CGAffineTransformIdentity;   
            break;   
        case UIImageOrientationUpMirrored: //EXIF = 2   
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);   
            transform = CGAffineTransformScale(transform, -1.0, 1.0);   
            break;   
        case UIImageOrientationDown: //EXIF = 3   
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);   
            transform = CGAffineTransformRotate(transform, M_PI);   
            break;   
        case UIImageOrientationDownMirrored: //EXIF = 4   
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);   
            transform = CGAffineTransformScale(transform, 1.0, -1.0);   
            break;   
        case UIImageOrientationLeftMirrored: //EXIF = 5   
            boundHeight = bounds.size.height;   
            bounds.size.height = bounds.size.width;   
            bounds.size.width = boundHeight;   
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);   
            transform = CGAffineTransformScale(transform, -1.0, 1.0);   
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);   
            break;   
        case UIImageOrientationLeft: //EXIF = 6   
            boundHeight = bounds.size.height;   
            bounds.size.height = bounds.size.width;   
            bounds.size.width = boundHeight;   
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);   
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);   
            break;   
        case UIImageOrientationRightMirrored: //EXIF = 7   
            boundHeight = bounds.size.height;   
            bounds.size.height = bounds.size.width;   
            bounds.size.width = boundHeight;   
            transform = CGAffineTransformMakeScale(-1.0, 1.0);   
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);   
            break;   
        case UIImageOrientationRight: //EXIF = 8   
            boundHeight = bounds.size.height;   
            bounds.size.height = bounds.size.width;   
            bounds.size.width = boundHeight;   
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);   
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);   
            break;   
        default:   
            [NSException raise:NSInternalInconsistencyException format:@"Invalid?image?orientation"];   
            break;   
    }   
    UIGraphicsBeginImageContext(bounds.size);   
    CGContextRef context = UIGraphicsGetCurrentContext();   
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)   
    {   
        CGContextScaleCTM(context, -scaleRatio, scaleRatioheight);   
        CGContextTranslateCTM(context, -height, 0);   
    }   
    else   
    {   
        CGContextScaleCTM(context, scaleRatio, -scaleRatioheight);   
        CGContextTranslateCTM(context, 0, -height);   
    }   
    CGContextConcatCTM(context, transform);   
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);   
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();   
    UIGraphicsEndImageContext();   
    return imageCopy;   
} 




@end
