//
//  FileUtils.m
//  SJH_OEM
//  Author PENGTAO
//  Created by me on 2018/8/3.
//  Copyright © 2018年 me. All rights reserved.
//
#import <CommonCrypto/CommonCrypto.h>
#import <Foundation/Foundation.h>
#import "FileUtils.h"
@interface FileUtils()

@end
static FileUtils *selectins= nil;
@implementation FileUtils
+ (FileUtils *)shareSDK
{
    static dispatch_once_t dgonceToken;
    dispatch_once(&dgonceToken, ^{
        selectins = [[FileUtils alloc] init];
        
    });
    
    return selectins;
}

-(BOOL)checkIsFile:(NSString *)file{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath: file];
}
-(BOOL)checkIsDir:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    [fileManager fileExistsAtPath:path isDirectory:&isDir];
    return isDir;
}
-(NSArray *)getDirAndFile:(NSString *)path{
     NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *subPath=[fileManager contentsOfDirectoryAtPath: path  error: nil];
    return subPath;
}

-(BOOL)createDirectoryAtPath:(NSString *)path{
     NSFileManager *fileManager = [NSFileManager defaultManager];
   
    return  [fileManager createDirectoryAtPath: path
                   withIntermediateDirectories: YES   attributes:nil   error: nil];
}
-(BOOL)createfileAtpath:(NSString *)path andData:(NSData *)data{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([self checkIsFile:path]) {
        [self removeFileOrDir:path];
    }
    return [fileManager createFileAtPath:path contents:data attributes:nil];
}
-(BOOL)copyFileOrDir:(NSString *)oldpath andto:(NSString *)newpath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager copyItemAtPath:oldpath toPath:newpath  error: nil];
}
-(BOOL)moveFileOrDir:(NSString *)oldpath andto:(NSString *)newpath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager moveItemAtPath:oldpath toPath:newpath error:nil];
}
-(BOOL)removeFileOrDir:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:path  error:nil ];
}
-(NSArray *)getAllDirOrFile:(NSString *)path{
    NSFileManager *fm=[NSFileManager defaultManager];
    NSArray *subPaths=[fm subpathsAtPath: path];
    return subPaths;
}
-(NSDictionary *)getFileAttributes:(NSString *)file{
     NSFileManager *fm=[NSFileManager defaultManager];
    NSDictionary  *dict=[fm attributesOfItemAtPath: file  error: nil];
    return dict;
}
//把字符串转化成 MD5字符串 去掉特殊的标记
- (NSString *)getMD5String:(NSString *)string
{
    // 转成 C 语言的字符串
    const char *mdData = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(mdData, (CC_LONG)strlen(mdData), result);
    
    // 化成 OC 可变 字符串
    NSMutableString *mdString  = [NSMutableString new];
    for (int i =0 ; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [mdString appendFormat:@"%02X",result[i]];
    }
    return mdString;
}
//确定存储文件名称  用下载地址 MD5 转化之后的字符串  加上自己的后缀 作为文件名
- (NSString *)checkfileName:(NSString *)filepath
{
    NSString *urls=[filepath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    NSArray *prefix_Suffix = [urls componentsSeparatedByString:@"."];
    NSString *fileName = [[self getMD5String:urls] stringByAppendingFormat:@".%@",[prefix_Suffix lastObject]];
    
    return fileName;
}



@end
