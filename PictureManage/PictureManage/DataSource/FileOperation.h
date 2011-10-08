//
//  FileOperation.h
//  PictureManage
//
//  Created by 中杰 卞 on 11-9-27.
//  Copyright 2011年 UZAI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileOperation : NSObject


- (void)removeFile:(NSString *)fileName withCategory:(NSString *)categoryName;
@end
