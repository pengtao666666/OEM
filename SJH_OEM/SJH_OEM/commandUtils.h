//
//  commandUtils.h
//  SJH_OEM
//  Author PENGTAO
//  Created by me on 2018/8/13.
//  Copyright © 2018年 me. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "Youai_LOG.h"
@interface commandUtils : NSObject

+ (commandUtils *)shareSDK;
- (NSString *)executeCommand: (NSString *)cmd;
-(NSString *)getProfileUUID:(NSString *)profilePath;
-(NSString *)getProfileName:(NSString *)profilePath;
-(NSString *)getProfileAppIDName:(NSString *)profilePath;
-(NSString *)getProfileTeamName:(NSString *)profilePath;
-(NSString *)getProfileTeamIdentifier:(NSString *)profilePath;
-(NSString *)getProfileType:(NSString *)profilePath;
-(NSString *)buildIPA:(NSString *)projectPath andProject:(NSString *)project andTarget:(NSString *)target andMode:(NSString *)mode andIpaPath:(NSString *)ipapath andipaname:(NSString *)name andBundleid:(NSString *)bundle;
@end
