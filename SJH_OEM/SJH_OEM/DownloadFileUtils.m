//
//  DownloadFileUtils.m
//  SJH_OEM
//  Author PENGTAO
//  Created by me on 2018/8/3.
//  Copyright © 2018年 me. All rights reserved.
//
#import <CommonCrypto/CommonCrypto.h>
#import "DownloadFileUtils.h"
@interface DownloadFileUtils()<NSURLSessionDataDelegate>
@property(nonatomic,strong)NSOutputStream *stream;// 输出流(对应写入文件)
@property(nonatomic,assign)NSInteger totalLength;// 文件总大小
@property(nonatomic,assign)NSInteger currentLength;// 已经下载大小
@property(nonatomic,strong)NSURLSession *session;
@property(nonatomic,strong)NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSString *fileName; // 文件保存名字
@property (nonatomic, strong) NSString *urlString; // 下载路径
@property (nonatomic, strong) NSString *fileLengthName; // 存储文件长度的名字
@property (nonatomic, strong) NSString *channle; // 下载路径
@property (nonatomic, strong) NSString *sdkversion; // 存储文件长度的名字

@end
static DownloadFileUtils *selectins= nil;
@implementation DownloadFileUtils
+ (DownloadFileUtils *)shareSDK
{
    static dispatch_once_t dgonceToken;
    dispatch_once(&dgonceToken, ^{
        selectins = [[ DownloadFileUtils alloc] init];
        
    });
    
    return selectins;
}

//根据URL创建 任务
-(NSURLSessionDataTask *)dataTaskWithUrlStr:(NSString *)urlString
{
    /*
     * 先去看看已经下载了多少，然后设置从已经下载之后的开始下载！
     */
    if (_dataTask == nil) {
       NSString *urls=[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
//        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
        self.urlString = urls;
        self.currentLength = [self getCurrent];
        NSURL *url =[NSURL URLWithString:urls];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSString *range =[NSString stringWithFormat:@"bytes=%zd-",self.currentLength];// %zd表示 size_t类型进行输出
        [request setValue:range forHTTPHeaderField:@"Range"];
        self.dataTask = [self.session dataTaskWithRequest:request];
        
    }
    return self.dataTask;
}
//计算对应下载的文件大小
-(NSInteger )getCurrent
{
    
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *caches=@"/Users/apple/Desktop/YAHJUPBLIC/";
    NSString *filePath = [caches stringByAppendingPathComponent:self.fileName];
    _filesdkpath=filePath;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDictionary *dict = [manager attributesOfItemAtPath:filePath error:nil];
    return [dict[@"NSFileSize"] integerValue];
}
//确定存储文件名称  用下载地址 MD5 转化之后的字符串  加上自己的后缀 作为文件名
- (NSString *)fileName
{
    NSArray *prefix_Suffix = [_urlString componentsSeparatedByString:@"."];
    _fileName = [[self getMD5String:_urlString] stringByAppendingFormat:@".%@",[prefix_Suffix lastObject]];
    
    return _fileName;
}
- (NSString *)fileLengthName
{
    return [NSString stringWithFormat:@"%@.txt",self.fileName];
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

//设置代理
-(NSURLSession *)session
{
    if (_session == nil) {
        // 使用代理方法请求
        /**
         参数一：配置信息
         参数二：代理
         参数三：控制代理方法在那个队列中调用
         遵守代理:NSURLSessionDataDelegate
         */
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}
//设置文件总数
-(void)saveTotal:(NSInteger )length
{
    
      [[Youai_LOG shareSDK]printLog:@"开始存储文件大小"];
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [caches stringByAppendingPathComponent:self.fileLengthName];
    // 把下载文件的总大小  存在沙盒的缓存里面
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(length) forKey:self.fileLengthName];
    [dict writeToFile:filePath atomically:YES];
}

//接收到服务器响应的时候调用

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    // 拿到文件总大小 获得的是当次请求的数据大小，当我们关闭程序以后重新运行，开下载请求的数据是不同的 ,所以要加上之前已经下载过的内容
   
     [[Youai_LOG shareSDK]printLog:@"接收到服务器响应"];
    self.totalLength = response.expectedContentLength + self.currentLength;
    
    // 把文件总大小保存的沙盒 没有必要每次都存储一次,只有当第一次接收到响应，self.currentLength为零时，存储文件总大小就可以了
    if (self.currentLength == 0) {
        [self saveTotal:self.totalLength];
    }
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [caches stringByAppendingPathComponent:self.fileName];
    NSLog(@"%@",filePath);
    
    // 创建输出流 如果没有文件会创建文件，YES：会往后面进行追加
    NSOutputStream *stream = [[NSOutputStream alloc] initToFileAtPath:filePath append:YES];
    [stream open];
    self.stream = stream;
    //NSLog(@"didReceiveResponse 接受到服务器响应");
    completionHandler(NSURLSessionResponseAllow);
    
    // 调用自己定义下载类的代理方法  供外界获取下载情况（这儿用了代理和 Block 两个方法一样的目的，就是练练手省的生疏了）
    [self.delegate pp_DownLoad:self startFilePath:self.fileName hasLoadLength:self.currentLength totalLength:self.totalLength];
    self.startBlock(self.fileName,self.currentLength,self.totalLength);
}
//接收到服务器返回数据时调用，会调用多次
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    self.currentLength += data.length;
    // 输出流 写数据
    [self.stream write:data.bytes maxLength:data.length];
    //NSLog(@"下载了百分比---->%f %%",1.0 * self.currentLength / self.totalLength * 100);
    
     [[Youai_LOG shareSDK]printLog:@"didReceiveData 接受到服务器返回数据"];
    // 回调代理方法
    [self.delegate pp_DownLoad:self progressCurrent:self.currentLength totalLength:self.totalLength];
    self.progressBlock(self.currentLength,self.totalLength);
}
//当请求完成之后调用，如果请求失败error有值
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    // 关闭stream
    [self.stream close];
    self.stream = nil;
    [[Youai_LOG shareSDK]printLog:@"didCompleteWithError 请求完成"];
   
    // 下载完成回调
    [self.delegate pp_DownLoad:self didCompleteWithError:error];
    self.competeBlock(error);
}



- (void)startDownLoad:(NSString *)downLoadUrl
{
    [[self dataTaskWithUrlStr:downLoadUrl] resume];
}

- (void)startDownLoad:(NSString *)downLoadUrl
       WithStartBlock:(StartLoadBlock)startBlock
        progressBlock:(ProgressBlock)progressBlock
     didCompleteBlock:(CompleteBlock)competeBlock
{
    [[self dataTaskWithUrlStr:downLoadUrl] resume];
    self.startBlock = startBlock;
    self.progressBlock = progressBlock;
    self.competeBlock = competeBlock;
}

- (void)stopDownLoad
{
    [self.dataTask suspend];
}
-(void)clearTask{
    _dataTask=nil;
}
-(void)setPath:(NSString *)channle and:(NSString *)version{
    _channle=channle;
    _sdkversion=version;
}
@end
