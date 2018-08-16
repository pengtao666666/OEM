//
//  Youai_LOG.m
//  Youai_OEM
//  Author PENGTAO
//  Created by me on 2018/7/23.
//  Copyright © 2018年 me. All rights reserved.
//
#import "FileUtils.h"
#import "Youai_LOG.h"
#define YOUAI_TAG1 @"PT_LOG: %@"
#define YOUAI_TAG2 @"PT_LOG: %@%@"
@interface Youai_LOG ()

@end
static Youai_LOG *ins= nil;

@implementation Youai_LOG
+ (Youai_LOG *)shareSDK
{
    static dispatch_once_t dgonceToken;
    dispatch_once(&dgonceToken, ^{
        ins = [[Youai_LOG alloc] init];
       
    });
    
    return ins;
}
- (void)printLog:(NSString *)msg {
    if (!(_LOG_TAG==nil||[_LOG_TAG isEqualToString:@""])&&[_LOG_TAG isEqualToString:@"YES"]) {
         NSLog(YOUAI_TAG1,msg);
    }
    if (self.SaveLog) {
          [self createLogFile:msg andTag:@""];
        
    }
}
-(void)printLog:(NSString *)tag andmsg:(NSString *)msg
{
    if (!(_LOG_TAG==nil||[_LOG_TAG isEqualToString:@""])&&[_LOG_TAG isEqualToString:@"YES"]) {
        NSLog(YOUAI_TAG2,tag,msg);
    }
    if (self.SaveLog) {
        [self createLogFile:msg andTag:tag];
    }
}
-(void)createLogFile:(NSString *)data andTag:(NSString *)tag{
     NSString *logDir=[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"poolsdk_file/LOG"];
  
    NSString *logFile=[NSString stringWithFormat:@"%@/%@/log_%@.txt",NSHomeDirectory(),@"poolsdk_file/LOG",[self getCurrentTimestamp]];
    if (![[FileUtils shareSDK]checkIsFile:logDir]) {
        [[FileUtils shareSDK]createDirectoryAtPath:logDir];
    }
    
    if (![[FileUtils shareSDK]checkIsFile:logFile]) {
        NSString *cont=[NSString stringWithFormat:@"PT_LOG:%@%@",tag,data];
        if (cont!=nil&&![cont isEqualToString:@""]) {
            [[FileUtils shareSDK]createfileAtpath:logFile andData:[cont dataUsingEncoding:NSUTF8StringEncoding]];
        }
       
    }else{
        NSString *cont=[NSString stringWithFormat:@"PT_LOG:%@%@",tag,data];
        if (cont!=nil&&![cont isEqualToString:@""]) {
            NSFileHandle  *outFile = [NSFileHandle fileHandleForWritingAtPath:logFile];
            [outFile seekToEndOfFile];
            [outFile writeData:[[NSString stringWithFormat:@"\n%@",cont] dataUsingEncoding:NSUTF8StringEncoding]];
            [outFile closeFile];

        }
    }
    
    
    
}

-(NSString*)getCurrentTimestamp{
    NSDate *date = [NSDate date];
    NSLog(@"当前时间%@",date);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH:mmss"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    NSLog(@"字符串表示1:%@",dateStr);
    
    NSArray *resultArr1 = [dateStr componentsSeparatedByString:@":"];
     NSLog(@"字符串表示1:%@",resultArr1[0]);
    return resultArr1[0];
}
@end
