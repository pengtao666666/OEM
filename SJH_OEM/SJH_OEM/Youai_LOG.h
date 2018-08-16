//
//  Youai_LOG.h
//  Youai_OEM
//  Author PENGTAO
//  Created by me on 2018/7/23.
//  Copyright © 2018年 me. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface Youai_LOG:NSObject
@property (nonatomic, copy) NSString *LOG_TAG;
@property BOOL SaveLog;
+ (Youai_LOG *)shareSDK;
- (void)printLog:(NSString *)msg;
-(NSString*)getCurrentTimestamp;
-(void)printLog:(NSString *)tag andmsg:(NSString *)msg;
@end
