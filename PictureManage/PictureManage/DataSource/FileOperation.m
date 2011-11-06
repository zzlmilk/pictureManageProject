//
//  FileOperation.m
//  PictureManage
//
//  Created by 中杰 卞 on 11-9-27.
//  Copyright 2011年 UZAI. All rights reserved.
//

#import "FileOperation.h"

@implementation FileOperation

- (NSString *)filePath:(NSString *)fileName withCategory:(NSString *)categoryName {
    return [NSString stringWithFormat:@"%@/Documents/%@/%@", NSHomeDirectory(), categoryName, fileName];
}

- (NSString *)thumbnailPath:(NSString *)fileName withCategory:(NSString *)categoryName {
    return [NSString stringWithFormat:@"%@/Documents/%@/%@.thumbnail", NSHomeDirectory(), categoryName, fileName];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (void)removeFile:(NSString *)fileName withCategory:(NSString *)categoryName{
    [[NSFileManager defaultManager] removeItemAtPath:[self filePath:fileName withCategory:categoryName] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[self thumbnailPath:fileName withCategory:categoryName] error:nil];
    NSString *detailFilePath = [NSString stringWithFormat:@"%@/Documents/%@/Details.plist", NSHomeDirectory(), categoryName];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:detailFilePath];
    for (NSDictionary *dic in array) {
        if ([[dic valueForKey:@"name"] isEqualToString:[self filePath:fileName withCategory:categoryName]]) {
            [array removeObject:dic];
            break;
        }
    }
    [array writeToFile:detailFilePath atomically:YES];
}


@end
