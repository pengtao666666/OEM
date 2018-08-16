//
//  HttpUtils.h
//  Youai_OEM
//  Author PENGTAO
//  Created by me on 2018/7/24.
//  Copyright © 2018年 me. All rights reserved.
//
#import <Cocoa/Cocoa.h>
@interface HttpUtils:NSObject
+ (HttpUtils *)shareSDK;
@property (strong) NSMutableArray *dataDictionary;
- (NSString *)httpGetSyn:(NSString *) getUrl;
- (void)httpGetNoSyn:(NSString *) getUrl;
- (void)httpPostAsync:(NSString*)postUrl :(NSDictionary*)postDict;
-(BOOL)downLoadUtils:(NSString *)url;
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
