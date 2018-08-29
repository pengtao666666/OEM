//
//  commandUtils.m
//  SJH_OEM
//  Author PENGTAO
//  Created by me on 2018/8/13.
//  Copyright © 2018年 me. All rights reserved.
//
#import "commandUtils.h"
#import "dbpzListview.h"
@interface commandUtils()

@end
static commandUtils *selectins= nil;
@implementation commandUtils
+ (commandUtils *)shareSDK
{
    static dispatch_once_t dgonceToken;
    dispatch_once(&dgonceToken, ^{
        selectins = [[commandUtils alloc] init];
        
    });
    
    return selectins;
}

- (NSString *)executeCommand: (NSString *)cmd
{
    NSString *output = [NSString string];
    FILE *pipe = popen([cmd cStringUsingEncoding: NSASCIIStringEncoding], "r+");
    if (!pipe)
        return @"";
    
    char buf[1024];
    while(fgets(buf, 1024, pipe)) {
        output = [output stringByAppendingFormat: @"%s", buf];
    }
    
    pclose(pipe);
    return output;
    
}
-(NSString *)buildApp:(NSString *)buildTarget andCertificateName:(NSString *)name andCertificateProfile:(NSString *)profile{
    
    
    return @"";
}
/*
 获取PROVISIONING_PROFILE -->UUID 例如：71193e5c-4714-41fd-9f00-0ce33150b1e0
 */
-(NSString *)getProfileUUID:(NSString *)profilePath{
    NSString *cmd=[NSString stringWithFormat:@"/usr/libexec/PlistBuddy -c \"Print UUID\" /dev/stdin <<< $(security cms -D -i %@)",profilePath];
    [[Youai_LOG shareSDK]printLog:@"profileCMD:" andmsg:cmd];
    [[Youai_LOG shareSDK]printLog:@"得到的结果:" andmsg:[self executeCommand:cmd]];
    return [self executeCommand:cmd];
}
/*
 
 CODE_SIGN_IDENTITY -->mobileprovision_teamname 例如：Zexia Li
 */
-(NSString *)getProfileTeamName:(NSString *)profilePath{
    NSString *cmd=[NSString stringWithFormat:@"/usr/libexec/PlistBuddy -c \"Print TeamName\" /dev/stdin <<< $(security cms -D -i %@)",profilePath];
    [[Youai_LOG shareSDK]printLog:@"profileCMD:" andmsg:cmd];
    [[Youai_LOG shareSDK]printLog:@"得到的结果:" andmsg:[self executeCommand:cmd]];
    return [self executeCommand:cmd];
}

/*
 PROVISIONING_PROFILE_SPECIFIER  yxsgziOS
 */
-(NSString *)getProfileAppIDName:(NSString *)profilePath{
    NSString *cmd=[NSString stringWithFormat:@"/usr/libexec/PlistBuddy -c \"Print AppIDName\" /dev/stdin <<< $(security cms -D -i %@)",profilePath];
    [[Youai_LOG shareSDK]printLog:@"profileCMD:" andmsg:cmd];
    [[Youai_LOG shareSDK]printLog:@"得到的结果:" andmsg:[self executeCommand:cmd]];
    return [self executeCommand:cmd];
}
/*
 获取描述文件名称
 */
-(NSString *)getProfileName:(NSString *)profilePath{
    NSString *cmd=[NSString stringWithFormat:@"/usr/libexec/PlistBuddy -c \"Print Name\" /dev/stdin <<< $(security cms -D -i %@)",profilePath];
    [[Youai_LOG shareSDK]printLog:@"profileCMD:" andmsg:cmd];
    [[Youai_LOG shareSDK]printLog:@"得到的结果:" andmsg:[self executeCommand:cmd]];
    return [self executeCommand:cmd];
}
/*
 DEVELOPMENT_TEAM 
 */
-(NSString *)getProfileTeamIdentifier:(NSString *)profilePath{
    NSString *cmd=[NSString stringWithFormat:@"/usr/libexec/PlistBuddy -c \"Print TeamIdentifier:0\" /dev/stdin <<< $(security cms -D -i %@)",profilePath];
    [[Youai_LOG shareSDK]printLog:@"profileCMD:" andmsg:cmd];
    [[Youai_LOG shareSDK]printLog:@"得到的结果:" andmsg:[self executeCommand:cmd]];
    return [self executeCommand:cmd];
}
-(NSString *)getProfileType:(NSString *)profilePath{//废弃
     NSString *cmd=[NSString stringWithFormat:@"/usr/libexec/PlistBuddy -c \"Print ProvisionedDevices\" /dev/stdin <<< $(security cms -D -i %@) | sed -e '/Array {/d' -e '/}/d' -e 's/^[ \t]*//'",profilePath];
    [[Youai_LOG shareSDK]printLog:@"profileCMD:" andmsg:cmd];
    [[Youai_LOG shareSDK]printLog:@"得到的结果:" andmsg:[self executeCommand:cmd]];
    return [self executeCommand:cmd];
}

/*
 projectPath 工程所在路径
 project 工程文件
 target 需要build的target
 mode 正式or测试 Release/Debug
 apppath 构建后的app路径
 ipapath 导出ipa的路径
 */
-(NSString *)buildIPA:(NSString *)projectPath andProject:(NSString *)project andTarget:(NSString *)target andMode:(NSString *)mode andIpaPath:(NSString *)ipapath andipaname:(NSString *)name andBundleid:(NSString *)bundle{
    ///Users/me/Library/Developer/Xcode/DerivedData/Demo_chuangyi_n-afdagkxsqvssmggzxzeiahlorlip/Build/Products/Debug-iphoneos
    NSString *apppa=[NSString stringWithFormat:@"%@/build/%@.xcarchive",projectPath,target];
   NSString *paths=[NSString stringWithFormat:@"%@/%@",ipapath,@"mode"];
//    NSString *cmd=[NSString stringWithFormat:@"cd %@\n rm -Rf build\n xcodebuild -project %@ -schemo %@ -configuration %@ -sdk iphoneos\n xcrun -sdk iphoneos packageapplication -v %@ -o %@",projectPath,project,target,mode,apppa,ipapath];
//     [[Youai_LOG shareSDK]printLog:@"得到的结果:" andmsg:[self executeCommand:cmd]];
    
    NSString *getTargetInfoCmd=[NSString stringWithFormat:@"cd %@\n xcodebuild archive -workspace %@/project.xcworkspace -list",projectPath,project];
     [[Youai_LOG shareSDK]printLog:getTargetInfoCmd];
    [[Youai_LOG shareSDK]printLog:[self executeCommand:getTargetInfoCmd]];
    NSString *copypath=[NSString stringWithFormat:@"%@/%@/%@",ipapath,bundle,@"ExportOptions.plist"];
    NSString *cmd=[NSString stringWithFormat:@"cd %@\n rm -Rf build\n xcodebuild archive -workspace %@/project.xcworkspace -scheme '%@' -configuration %@ -archivePath %@\n xcodebuild -exportArchive -archivePath %@ -exportPath %@ -exportOptionsPlist %@\n cd %@\n cp ./mode/Apps/%@.ipa ./%@.ipa\n rm -Rf ./mode",projectPath,project,target,mode,apppa,apppa,paths,copypath,ipapath,target,name];
    [[Youai_LOG shareSDK]printLog:cmd];
//    [[Youai_LOG shareSDK]printLog:[self executeCommand:cmd]];
    return [self executeCommand:cmd];
}


@end


