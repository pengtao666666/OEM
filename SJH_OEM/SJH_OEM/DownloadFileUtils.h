//
//  DownloadFileUtils.h
//  SJH_OEM
//  Author PENGTAO
//  Created by me on 2018/8/3.
//  Copyright © 2018年 me. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "Youai_LOG.h"
#import <Foundation/Foundation.h>

typedef void(^StartLoadBlock)(NSString *filePath, NSInteger hasLoadLength, NSInteger totalLength);
typedef void(^ProgressBlock)(NSInteger hasLoadLength, NSInteger totalLength);
typedef void(^CompleteBlock)(NSError *error);


@class DownloadFileUtils;

@protocol DownloadFileUtilsDelegate <NSObject>

// 开始下载
- (void)pp_DownLoad:(DownloadFileUtils *)pp_DownLoad
      startFilePath:(NSString *)filePath
      hasLoadLength:(NSInteger)hasLoadLength
        totalLength:(NSInteger)totalLength;

// 获取下载进度
- (void)pp_DownLoad:(DownloadFileUtils *)pp_DownLoad
    progressCurrent:(NSInteger)currentLength
        totalLength:(NSInteger)totalLength;
// 下载完成
- (void)pp_DownLoad:(DownloadFileUtils *)pp_DownLoad didCompleteWithError:(NSError *)error;
@end


@interface DownloadFileUtils : NSObject

@property (nonatomic, weak) id<DownloadFileUtilsDelegate> delegate;
@property (nonatomic, copy) StartLoadBlock startBlock ; // 开始下载回调
@property (nonatomic, copy) ProgressBlock progressBlock ; // 更新数据回调
@property (nonatomic, copy) CompleteBlock competeBlock ;// 下载完成回调
@property (nonatomic, strong) NSString *filesdkpath; // 下载后的文件路径

// 单例构造方法
+ (instancetype)shareSDK;
-(void)setPath:(NSString *)channle and:(NSString *)version;
-(void)clearTask;
// 开始下载
- (void)startDownLoad:(NSString *)downLoadUrl;

// 开始下载包含 Block 的回调
- (void)startDownLoad:(NSString *)downLoadUrl
       WithStartBlock:(StartLoadBlock)startBlock
        progressBlock:(ProgressBlock)progressBlock
     didCompleteBlock:(CompleteBlock)competeBlock;


// 暂停下载
- (void)stopDownLoad;

@end
