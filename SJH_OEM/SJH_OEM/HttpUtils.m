//
//  HttpUtils.m
//  Youai_OEM
//  Author PENGTAO
//  Created by me on 2018/7/24.
//  Copyright © 2018年 me. All rights reserved.
//
#import "HttpUtils.h"
#import "Youai_LOG.h"

@interface HttpUtils()

@end
static HttpUtils *http= nil;
@implementation HttpUtils

+ (HttpUtils *)shareSDK
{
    static dispatch_once_t dgonceToken;
    dispatch_once(&dgonceToken, ^{
        http = [[HttpUtils alloc] init];
        
    });
    
    return http;
}


- (NSString *)httpGetSyn:(NSString *) getUrl
{
//    NSLog(@"httpGetSyn...");
    [[Youai_LOG shareSDK]printLog:@"httpGetSyn..."];
    /*
     NSString *urlString =url;
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
     [request setURL:[NSURL URLWithString:urlString]];
     [request setHTTPMethod:@"GET"];
     NSHTTPURLResponse* urlResponse = nil;
     NSError *error = [[NSError alloc] init];
     NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
     NSMutableString *result = [[NSMutableString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
     NSLog(@"The result string is :%@",result);
     */
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:getUrl];
//    [[Youai_LOG shareSDK]printLog:url];
    
    //第二步，通过URL创建网络请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//     [[Youai_LOG shareSDK]printLog:request];
    //NSURLRequest初始化方法第一个参数：请求访问路径，第二个参数：缓存协议，第三个参数：网络请求超时时间（秒）
    /*
     其中缓存协议是个枚举类型包含：
     NSURLRequestUseProtocolCachePolicy（基础策略）
     NSURLRequestReloadIgnoringLocalCacheData（忽略本地缓存）
     NSURLRequestReturnCacheDataElseLoad（首先使用缓存，如果没有本地缓存，才从原地址下载）
     NSURLRequestReturnCacheDataDontLoad（使用本地缓存，从不下载，如果本地没有缓存，则请求失败，此策略多用于离线操作）
     NSURLRequestReloadIgnoringLocalAndRemoteCacheData（无视任何缓存策略，无论是本地的还是远程的，总是从原地址重新下载）
     NSURLRequestReloadRevalidatingCacheData（如果本地缓存是有效的则不下载，其他任何情况都从原地址重新下载）
     */
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//     [[Youai_LOG shareSDK]printLog:received];
    NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
//    NSLog(@"%@",str);
    [[Youai_LOG shareSDK] printLog:@"收到请求后数据：" andmsg:str];
    
    return str;
}

- (void)httpGetNoSyn:(NSString *) getUrl
{
    NSLog(@"httpGetNoSyn...");
    
    //第一步，创建url
    NSURL *url = [NSURL URLWithString:getUrl];
    
    //第二步，创建请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    //第三步，连接服务器
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
   
}
- (NSString *)dicToString:(NSDictionary *) dict
{
    //    NSMutableString *result = [NSMutableString alloc];
    NSMutableString *result = [NSMutableString stringWithString:@""];
    //    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"value1", @"key1", @"value2", @"key2", nil];
    for (NSString *key in dict) {
        NSLog(@"key: %@ value: %@", key, dict[key]);
        [result appendFormat:@"%@=%@&",key,dict[key]];
    }
    
    if(result.length > 4)
    {
        [result deleteCharactersInRange:NSMakeRange(result.length-1, 1)];
    }
    else
    {
        result = nil;
    }
    
    return result;
}
- (void)httpPostAsync:(NSString*)postUrl :(NSDictionary*)postDict
{
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:postUrl];
    
    //第二步，创建请求
    NSString *postStr = [self dicToString:postDict];
    NSData *postData = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    [request setHTTPBody:postData];//设置参数
    //第三步，连接服务器
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            NSLog(@"post Fail");
        }else{
            NSLog(@"post success");
        }
    }];
}

-(BOOL)downLoadUtils:(NSString *)url{
   
    
    /*
     
     
     {
     "description": "",
     "name": "iTools iOS",  需要
     "partnerCompanyId": 0,
     "client_type": "IOS",
     "sdkConfig": "",
     "simpleName": "itools",
     "currentVersion": "V3.0.3",
     "iconUri": "/static/img/default-s.png", 需要
     "writeToManifest": 0,
     "parameterFormat": "",
     "id": 72,   需要
     "sdkVersionList": [{ 需要
  
     
     
     */
     NSString *data=[self httpGetSyn:url];
    if (data!=nil&&data.length>0) {
        
        NSDictionary *dic=[self dictionaryWithJsonString:data];
        if (dic!=nil) {
            NSEnumerator * enumeratorValue = [dic objectEnumerator];
            _dataDictionary=[NSMutableArray array];
            for (NSObject *object in enumeratorValue) {
                
                
                NSString *name=[object valueForKey:@"name"];
                NSString *iconUri=[object valueForKey:@"iconUri"];
                NSString *sdkVersionList=[object valueForKey:@"sdkVersionList"];
//                NSString *description=[object valueForKey:@"description"];
//                NSInteger partnerCompanyId=[[object valueForKey:@"partnerCompanyId"]integerValue];
//                NSString *client_type=[object valueForKey:@"client_type"];
//                NSInteger ID=[[object valueForKey:@"id"]integerValue];
//                NSString *sdkConfig=[object valueForKey:@"sdkConfig"];
//                NSString *simpleName=[object valueForKey:@"simpleName"];
//                NSString *currentVersion=[object valueForKey:@"currentVersion"];
//                NSInteger writeToManifest=[[object valueForKey:@"writeToManifest"]integerValue];
//                 NSString *parameterFormat=[object valueForKey:@"parameterFormat"];
                NSDictionary *dataDic=@{@"name":name,@"iconUri":iconUri,@"sdkVersionList":sdkVersionList};
                [self.dataDictionary addObject:dataDic];
                
            }
            
            
            return YES;
        }
        return NO;
    }
    return NO;
}
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        
        [[Youai_LOG shareSDK]printLog:@"json解析失败：" andmsg:err];
        return nil;
    }
    return dic;
}
@end
