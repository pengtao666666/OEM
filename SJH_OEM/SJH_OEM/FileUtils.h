//
//  FileUtils.h
//  SJH_OEM
//  Author PENGTAO
//  Created by me on 2018/8/3.
//  Copyright © 2018年 me. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Youai_LOG.h"
@interface FileUtils : NSObject

+ (FileUtils *)shareSDK;
-(BOOL)checkIsFile:(NSString *)file;
-(BOOL)checkIsDir:(NSString *)path;
-(NSArray *)getDirAndFile:(NSString *)path;
-(BOOL)createDirectoryAtPath:(NSString *)path;
-(BOOL)createfileAtpath:(NSString *)path andData:(NSData *)data;
-(BOOL)copyFileOrDir:(NSString *)oldpath andto:(NSString *)newpath;
-(BOOL)moveFileOrDir:(NSString *)oldpath andto:(NSString *)newpath;
-(BOOL)removeFileOrDir:(NSString *)path;
- (NSString *)checkfileName:(NSString *)filepath;
-(NSArray *)getAllDirOrFile:(NSString *)path;
-(NSDictionary *)getFileAttributes:(NSString *)file;

@end
