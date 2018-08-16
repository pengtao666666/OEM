//
//  dbpzListview.m
//  SJH_OEM
//  Author PENGTAO
//  Created by me on 2018/8/7.
//  Copyright © 2018年 me. All rights reserved.
//
#import "dbpzListview.h"
#import "ViewUtils.h"
#import "FileUtils.h"
#import "commandUtils.h"
@interface dbpzListview()
@property NSTableView *taview;

@property  NSTextField *ComputerUserName;
@property  NSTextField *ipaDir;
@property  NSTextField *ComputerUserPassword;
@property  NSTextField *ipaPackages;
@property  NSTextField *certificate;
@property  NSTextField *certificatePassword;
@property  NSTextField *gamePyPath;
@property  NSTextField *MotherEngineeringPath;
@property NSButton *save;
@property NSButton *editing;
@property  NSDictionary *dic;
@property  NSData *data;
@property NSString *path;
@property  NSInteger selectrow;
@property NSString *paramsFilePath;
@property NSString *MotherEngineeringDirPath;
@property NSWindow *dbpzWindow;
@property  NSString *poolsdkPath;
@property  NSString *pool_setingPath;
@property NSButton *selectCertificatePath;
@property NSButton *selectIpaDirPath;
@property  NSButton *selectGamePyPath;
@property  NSButton *selectMotherEngineeringPath;
@property NSString *chanelName;
@property NSString *UUID;
@property NSString *profilename;
@property NSString *profilTeam;
@property BOOL isSave;
@property BOOL onDB;
@property BOOL onAutoDB;
@property NSTextField *projectTarget;
@property NSBox *dbpzBox;
@property  NSButton *ManualPacking;
@property  NSButton *AutoPacking;
@property NSButton *StratPacking;

@property NSButton *Release;
@property NSButton *Debug;

@property NSButton *typeApp_store;
@property  NSButton *typeAd_hoc;
@property  NSButton *typeEnterprise;
@property  NSButton *typeDevelopment;
@property NSString *typeMode;
@property NSString *signingCertificate;
@property NSTextField *bundleID;

@property NSButton *moreAutoPacking;
@property NSProgressIndicator *progress;
@property  NSTextField *showContens;

@property NSMutableArray *autoPackingParamArry;
@property NSDictionary *dataDic;

@end
static dbpzListview *selectins= nil;
@implementation dbpzListview
+ (dbpzListview *)shareSDK
{
    static dispatch_once_t dgonceToken;
    dispatch_once(&dgonceToken, ^{
        selectins = [[dbpzListview alloc] init];
        
    });
    
    return selectins;
}

-(void)initMoreAutoPackingView:(NSButton *)button{

    _moreAutoPacking=button;
    [_moreAutoPacking setAction:@selector(moreAutoPacking:)];
    [_moreAutoPacking setTarget:self];
}
-(void)showAlert:(NSString *)smg{
    NSAlert *alert = [NSAlert new];
    [alert addButtonWithTitle:@"确定"];
   
    [alert setMessageText:@"温馨提示:"];
    [alert setInformativeText:smg];
    [alert setAlertStyle:NSAlertStyleWarning];
    [alert beginSheetModalForWindow:_dbpzWindow completionHandler:^(NSModalResponse returnCode) {
        if(returnCode == NSAlertFirstButtonReturn){
            NSLog(@"确定");
            
        }
    }];
}
-(void)selectCertificatePath:(id)sender{
     [[Youai_LOG shareSDK]printLog:@"进来了selectCertificatePath"];
    NSOpenPanel *panel = [NSOpenPanel openPanel];
//    [panel setDirectory:NSHomeDirectory()];
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
//    [panel setAllowedFileTypes:@[@"onecodego"]];
    [panel setAllowsOtherFileTypes:YES];
    if ([panel runModal] == NSModalResponseOK) {
        NSString *path = [panel.URLs.firstObject path];
        [[Youai_LOG shareSDK]printLog:path];
        _certificatePassword.stringValue=path;
//        [[commandUtils shareSDK] getProfileType:_certificatePassword.stringValue];
        _certificate.stringValue=[[commandUtils shareSDK]getProfileTeamName:_certificatePassword.stringValue];
       
    }
}
-(void)selectIpaDirPath:(id)sender{
    [[Youai_LOG shareSDK]printLog:@"进来了selectIpaDirPath"];
    NSOpenPanel *panel = [NSOpenPanel openPanel];
   
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
    [panel setCanCreateDirectories:YES];
//    [panel setAllowsOtherFileTypes:YES];
    if ([panel runModal] == NSModalResponseOK) {
        NSString *path = [panel.URLs.firstObject path];
        [[Youai_LOG shareSDK]printLog:path];
        _ipaDir.stringValue=path;
    }
    
}
-(void)selectGamePyPath:(id)sender{
    [[Youai_LOG shareSDK]printLog:@"进来了selectGamePyPath"];
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    //    [panel setDirectory:NSHomeDirectory()];
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    //    [panel setAllowedFileTypes:@[@"onecodego"]];
    [panel setAllowsOtherFileTypes:YES];
    if ([panel runModal] == NSModalResponseOK) {
        NSString *path = [panel.URLs.firstObject path];
        [[Youai_LOG shareSDK]printLog:path];
        _gamePyPath.stringValue=path;
    }
}

-(void)selectMotherEngineeringPath:(id)sender{
     [[Youai_LOG shareSDK]printLog:@"进来了selectMotherEngineeringPath"];
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    //    [panel setDirectory:NSHomeDirectory()];
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setAllowedFileTypes:@[@"xcodeproj"]];
    [panel setAllowsOtherFileTypes:NO];
    if ([panel runModal] == NSModalResponseOK) {
        NSString *path = [panel.URLs.firstObject path];
        
        [[Youai_LOG shareSDK]printLog:path];
       
       
   
        _MotherEngineeringPath.stringValue=path;
        
    }
}
-(BOOL)copyPyfileOrPoolsdk:(NSString *)MotherEngineeringPath andPoolsdkPath:(NSString *)sdkpath andPoolstingPath:(NSString *)path{
     [[Youai_LOG shareSDK]printLog:MotherEngineeringPath];
     _MotherEngineeringDirPath=MotherEngineeringPath;
    NSString *configFile=[self getFilePath:@"config.py"];
    NSString *packageProjFile=[self getFilePath:@"packageProj.py"];
    NSString *mod_pbxprojProjFile=[self getFilePath:@"mod_pbxproj.py"];
    if ([[FileUtils shareSDK]checkIsFile:[NSString stringWithFormat:@"%@/%@",MotherEngineeringPath,@"config.py"]]) {
        [[FileUtils shareSDK]removeFileOrDir:[NSString stringWithFormat:@"%@/%@",MotherEngineeringPath,@"config.py"]];
    }
    if ([[FileUtils shareSDK]checkIsFile:[NSString stringWithFormat:@"%@/%@",MotherEngineeringPath,@"packageProj.py"]]) {
        [[FileUtils shareSDK]removeFileOrDir:[NSString stringWithFormat:@"%@/%@",MotherEngineeringPath,@"packageProj.py"]];
    }
    if ([[FileUtils shareSDK]checkIsFile:[NSString stringWithFormat:@"%@/%@",MotherEngineeringPath,@"mod_pbxproj.py"]]) {
        [[FileUtils shareSDK]removeFileOrDir:[NSString stringWithFormat:@"%@/%@",MotherEngineeringPath,@"mod_pbxproj.py"]];
    }
    [[FileUtils shareSDK]copyFileOrDir:configFile andto:[NSString stringWithFormat:@"%@/%@",MotherEngineeringPath,@"config.py"]];
    [[FileUtils shareSDK]copyFileOrDir:packageProjFile andto:[NSString stringWithFormat:@"%@/%@",MotherEngineeringPath,@"packageProj.py"]];
    [[FileUtils shareSDK]copyFileOrDir:mod_pbxprojProjFile andto:[NSString stringWithFormat:@"%@/%@",MotherEngineeringPath,@"mod_pbxproj.py"]];
    
    return [self copyChannlePyFile:sdkpath andMotherEngineeringDirPath:MotherEngineeringPath andPoolstingPath:path];
}

-(BOOL)copyChannlePyFile:(NSString *)path andMotherEngineeringDirPath:(NSString *)motherEngineeringDirPath andPoolstingPath:(NSString *)poolpath{
     [[Youai_LOG shareSDK]printLog:path];
    NSArray *all=[[FileUtils shareSDK]getAllDirOrFile:path];
    if (all==nil) {
         [self showAlert:@"请先下载poolsdk!"];
        return NO;
    }
    
     [[Youai_LOG shareSDK]printLog:all];
    for (int i=0; i<all.count; i++) {
        NSString *file=[NSString stringWithFormat:@"%@/%@",path,all[i]];
        if ([[FileUtils shareSDK]checkIsFile:file]) {
            if ([[file pathExtension] isEqualToString:@"py"]) {
                if ([[FileUtils shareSDK]checkIsFile:[NSString stringWithFormat:@"%@/%@",motherEngineeringDirPath,[file lastPathComponent]]]) {
                    [[FileUtils shareSDK]removeFileOrDir:[NSString stringWithFormat:@"%@/%@",motherEngineeringDirPath,[file lastPathComponent]]];
                }
                _chanelName=[[file lastPathComponent] stringByDeletingPathExtension];
                 [[Youai_LOG shareSDK]printLog:_chanelName];
                BOOL ok=[[FileUtils shareSDK]copyFileOrDir:file andto:[NSString stringWithFormat:@"%@/%@",motherEngineeringDirPath,[file lastPathComponent]]];
                if (!ok) {
                    [self showAlert:[NSString stringWithFormat:@"脚本文件%@%@拷贝失败,请检查路径!",_chanelName,@".py"]];
                    return NO;
                }
            }
           
        }
        
         [[Youai_LOG shareSDK]printLog:@"开始拷贝poolsdk"];
         [[Youai_LOG shareSDK]printLog:[file pathExtension]];
        
        if ([[file lastPathComponent] isEqualToString:@"SDK"]) {
            NSString *paratPath=[file stringByDeletingLastPathComponent];
            
            
            if ([[FileUtils shareSDK]checkIsDir:paratPath]) {
                
                
                
                [[Youai_LOG shareSDK]printLog:@"开始拷贝poolsdk"];
                NSArray *all=[[FileUtils shareSDK]getAllDirOrFile:motherEngineeringDirPath];
                [[Youai_LOG shareSDK]printLog:all];
                for (int i=0; i<all.count; i++) {
                    NSString *dir=[NSString stringWithFormat:@"%@/%@",motherEngineeringDirPath,all[i]];
                    //                [[Youai_LOG shareSDK]printLog:@"找到路径了"];
                    NSString *pool=[all[i] lastPathComponent];
                    [[Youai_LOG shareSDK]printLog:pool];
                    if ([pool isEqualToString:@"poolsdk_file"]) {
                        
                        [[Youai_LOG shareSDK]printLog:@"找到路径了"];
                        [[Youai_LOG shareSDK]printLog:dir];
                        if ([[FileUtils shareSDK]checkIsFile:[NSString stringWithFormat:@"%@/%@",dir,[paratPath lastPathComponent]]]) {
                            [[FileUtils shareSDK]removeFileOrDir:[NSString stringWithFormat:@"%@/%@",dir,[paratPath lastPathComponent]]];
                        }
                        BOOL ok=[[FileUtils shareSDK]copyFileOrDir:paratPath andto:[NSString stringWithFormat:@"%@/%@",dir,[paratPath lastPathComponent]]];
                        if (!ok) {
                            [self showAlert:@"poolsdk拷贝失败，请检查路径!"];
                            return NO;
                        }else{
                            
                            //拷贝pool_seting
                            if ([[FileUtils shareSDK]checkIsFile:[NSString stringWithFormat:@"%@/%@/SDK/pool_setting",dir,[paratPath lastPathComponent]]]) {
                                [[FileUtils shareSDK]removeFileOrDir:[NSString stringWithFormat:@"%@/%@/SDK/pool_setting",dir,[paratPath lastPathComponent]]];
                            }
                            BOOL ok=[[FileUtils shareSDK]copyFileOrDir:[NSString stringWithFormat:@"%@/%@",poolpath,@"pool_setting"] andto:[NSString stringWithFormat:@"%@/%@/SDK/pool_setting",dir,[paratPath lastPathComponent]]];
                            if (!ok) {
                                [self showAlert:@"pool_setting拷贝失败，请检查路径!"];
                                return NO;
                            }
                            
                        }
                        
                        
                    }
                }
                
            }
        }
        
        
    }
   
    return YES;
}
-(NSString *)getFilePath:(NSString *)file{
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    // 获取 main bundle 路径
    NSString *mainPath = [mainBundle resourcePath];
    NSLog(@"mainPath 路径： %@", mainPath);
    return [NSString stringWithFormat:@"%@/%@",mainPath,file];
}
-(void)typeApp_store:(id)sender{
    if (_typeApp_store.state) {
        _typeAd_hoc.state=0;
         _typeEnterprise.state=0;
        _typeDevelopment.state=0;
        _typeMode=@"app-store";
    }else{
       
    }
}
-(void)typeAd_hoc:(id)sender{
    if (_typeAd_hoc.state) {
        _typeApp_store.state=0;
        _typeEnterprise.state=0;
        _typeDevelopment.state=0;
        _typeMode=@"ad-hoc";
    }else{
       
    }
}
-(void)typeEnterprise:(id)sender{
    if (_typeEnterprise.state) {
        _typeApp_store.state=0;
        _typeDevelopment.state=0;
         _typeAd_hoc.state=0;
         _typeMode=@"enterprise";
    }else{
       
    }
}
-(void)typeDevelopment:(id)sender{
    if (_typeDevelopment.state) {
        _typeApp_store.state=0;
         _typeAd_hoc.state=0;
        _typeEnterprise.state=0;
        _typeMode=@"development";
    }else{
       
    }
}
-(void)initTypeSelectView:(NSButton *)app_store and:(NSButton *)ad_hoc and:(NSButton *)enterprise and:(NSButton *)development{
    _typeApp_store=app_store;
    _typeAd_hoc=ad_hoc;
    _typeEnterprise=enterprise;
    _typeDevelopment=development;
    
    [_typeApp_store setAction:@selector(typeApp_store:)];
    [_typeApp_store setTarget:self];
    
    [_typeAd_hoc setAction:@selector(typeAd_hoc:)];
    [_typeAd_hoc setTarget:self];
    
    [_typeEnterprise setAction:@selector(typeEnterprise:)];
    [_typeEnterprise setTarget:self];
    
    [_typeDevelopment setAction:@selector(typeDevelopment:)];
    [_typeDevelopment setTarget:self];
}
-(void)initButtonView:(NSButton *)selectCertificatePath and:(NSButton *)selectIpaDirPath and:(NSButton *)selectGamePyPath and:(NSButton *)selectMotherEngineeringPath and:(NSButton *)ManualPacking and:(NSButton *)AutoPacking  and:(NSButton *)StratPacking and:(NSButton *)debug and:(NSButton *)release{
    _selectCertificatePath=selectCertificatePath;
    _selectIpaDirPath=selectIpaDirPath;
    _selectGamePyPath=selectGamePyPath;
    _selectMotherEngineeringPath=selectMotherEngineeringPath;
    
    _ManualPacking=ManualPacking;
    _AutoPacking=AutoPacking;
    _StratPacking=StratPacking;
    _Debug=debug;
    _Release=release;
    
    [_selectCertificatePath setAction:@selector(selectCertificatePath:)];
    [_selectCertificatePath setTarget:self];
    
    [_selectIpaDirPath setAction:@selector(selectIpaDirPath:)];
    [_selectIpaDirPath setTarget:self];
    
    [_selectGamePyPath setAction:@selector(selectGamePyPath:)];
    [_selectGamePyPath setTarget:self];
    
    
    
    [_selectMotherEngineeringPath setAction:@selector(selectMotherEngineeringPath:)];
    [_selectMotherEngineeringPath setTarget:self];
  
    [_ManualPacking setAction:@selector(ManualPacking:)];
    [_ManualPacking setTarget:self];
    
    [_AutoPacking setAction:@selector(AutoPacking:)];
    [_AutoPacking setTarget:self];
    
    [_StratPacking setAction:@selector(StratPacking:)];
    [_StratPacking setTarget:self];
    
    [_Debug setAction:@selector(DebugClick:)];
    [_Debug setTarget:self];
    [_Release setAction:@selector(ReleaseClick:)];
    [_Release setTarget:self];
    
}
-(void)DebugClick:(id)sender{
    if (_Debug.state) {
        _Release.state=0;
        _signingCertificate=@"iPhone Developer";
    }else{
        _Release.state=1;
    }
}
-(void)ReleaseClick:(id)sender{
    if (_Release.state) {
        _Debug.state=0;
         _signingCertificate=@"iPhone Distribution";
    }else{
        _Debug.state=1;
    }
}
-(void)ManualPacking:(id)sender{
    if (_ManualPacking.state) {
        _AutoPacking.state=0;
    }else{
         _AutoPacking.state=1;
    }
}
-(void)AutoPacking:(id)sender{
    if (_AutoPacking.state) {
        _ManualPacking.state=0;
    }else{
         _ManualPacking.state=1;
    }
}

-(BOOL)revisionExportOptionsPlist:(NSString *)method and:(NSString *)bundleid and:(NSString *)profileName and:(NSString *)team and:(NSString *)signingCertificate{
    NSString *plistPath=[[NSBundle mainBundle]pathForResource:@"ExportOptions" ofType:@"plist"];
    [[Youai_LOG shareSDK]printLog:plistPath];
    NSString *copypath=[NSString stringWithFormat:@"%@/%@/%@",_ipaDir.stringValue,bundleid,@"ExportOptions.plist"];
    [[Youai_LOG shareSDK]printLog:copypath];
    [[FileUtils shareSDK]createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",_ipaDir.stringValue,bundleid]];
    if (![[FileUtils shareSDK]checkIsFile:copypath]) {
        if (![[FileUtils shareSDK]copyFileOrDir:plistPath andto:copypath]) {
            return NO;
        }
        
    }
    
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:copypath];
//    NSArray *dataArry=[NSArray arrayWithArray:[data objectForKey:@"province"]];
     [[Youai_LOG shareSDK]printLog:data];
    [data setValue:method forKey:@"method"];
    [data setValue:[team stringByReplacingOccurrencesOfString:@"\n" withString:@""] forKey:@"teamID"];
    [data setValue:signingCertificate forKey:@"signingCertificate"];
    
    [data setValue:nil forKey:@"provisioningProfiles"];
    NSString *key=[NSString stringWithFormat:@"%@",bundleid];
    NSString *name=[profileName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [data setValue:@{key:name} forKey:@"provisioningProfiles"];
    
     [[Youai_LOG shareSDK]printLog:data];
    
    
    return [data writeToFile:copypath atomically:YES];
}

-(void)moreAutoPacking:(id)sender{
    if (_autoPackingParamArry.count<=1) {
        [self showAlert:@"渠道数必须两个或以上!"];
        return;
    }
    
    if (_onAutoDB) {
        [self showAlert:@"正在打包请稍后!"];
        return;
    }
    _onAutoDB=true;
    [Youai_LOG shareSDK].SaveLog=true;
    NSString *logFile=[NSString stringWithFormat:@"%@/%@/log_%@.txt",NSHomeDirectory(),@"poolsdk_file/LOG",[[Youai_LOG shareSDK] getCurrentTimestamp]];
    if ([[FileUtils shareSDK]checkIsFile:logFile]) {
        [[FileUtils shareSDK]removeFileOrDir:logFile];
    }
    NSString *ipaPt;
    for (int i=0; i<_autoPackingParamArry.count; i++) {

        /*
 _dic=@{@"computerUserName":_ComputerUserName.stringValue,@"ipaDir":_ipaDir.stringValue,@"computerUserPassword":_ComputerUserPassword.stringValue,@"ipaPackages":_ipaPackages.stringValue,@"certificate":_certificate.stringValue,@"certificatePassword":_certificatePassword.stringValue,@"gamePyPath":_gamePyPath.stringValue,@"motherEngineeringPath":_MotherEngineeringPath.stringValue,@"uuid":_UUID,@"profilename":_profilename,@"projectTarget":_projectTarget.stringValue,@"typeMode":_typeMode,@"bundleid":_bundleID.stringValue,@"signingCertificate":_signingCertificate,@"paramsPath":_path};
         */
        NSString *parasPath=[NSString stringWithFormat:@"%@/poolsdk_file/DBPZFILE/%@/%@/params",NSHomeDirectory(),[_autoPackingParamArry[i] objectForKey:@"sdkName"],[_autoPackingParamArry[i] objectForKey:@"sdkVersionName"]];
         [[Youai_LOG shareSDK]printLog:parasPath];
        if ([[FileUtils shareSDK]checkIsFile:parasPath]) {
            NSString *content = [NSString stringWithContentsOfFile:parasPath encoding:NSUTF8StringEncoding error:nil];
            
//            [[Youai_LOG shareSDK]printLog:@"取到的数据是：" andmsg:content];
            NSDictionary *dic=[self dictionaryWithJsonString:content];
            
            if (dic==nil) {
                 _onAutoDB=false;
                [self showAlert:@"打包失败！"];
                return;
            }
            
            [[Youai_LOG shareSDK]printLog:dic];
//            _ComputerUserName.stringValue=[dic objectForKey:@"computerUserName"];
//            _ipaDir.stringValue=[dic objectForKey:@"ipaDir"];
//            _ComputerUserPassword.stringValue=[dic objectForKey:@"computerUserPassword"];
//            _ipaPackages.stringValue=[dic objectForKey:@"ipaPackages"];
//            _certificate.stringValue=[dic objectForKey:@"certificate"];
//            _certificatePassword.stringValue=[dic objectForKey:@"certificatePassword"];
//            _gamePyPath.stringValue=[dic objectForKey:@"gamePyPath"];
//            _MotherEngineeringPath.stringValue=[dic objectForKey:@"motherEngineeringPath"];
//            _UUID=[dic objectForKey:@"uuid"];
//            _projectTarget.stringValue=[dic objectForKey:@"projectTarget"];
//            _typeMode=[dic objectForKey:@"typeMode"];
//            _bundleID.stringValue=[dic objectForKey:@"bundleid"];
//            _signingCertificate=[dic objectForKey:@"signingCertificate"];
            ipaPt=[dic objectForKey:@"ipaDir"];
            if ([parasPath isEqualToString:[dic objectForKey:@"paramsPath"]]) {
                [[Youai_LOG shareSDK]printLog:@"参数拿对了！"];
                NSString *motherEngineeringPath=[dic objectForKey:@"motherEngineeringPath"];
                //执行游戏脚本
                if ([[FileUtils shareSDK]checkIsFile:[dic objectForKey:@"gamePyPath"]]) {
                    NSString *cmd=[NSString stringWithFormat:@"python %@ %@ %@",[dic objectForKey:@"gamePyPath"],[motherEngineeringPath stringByDeletingLastPathComponent],motherEngineeringPath];
                    [[Youai_LOG shareSDK]printLog:@"开始执行游戏脚本=============="];
                    [[Youai_LOG shareSDK]printLog:cmd];
                    NSString *result=[[commandUtils shareSDK]executeCommand:cmd];
                    [[Youai_LOG shareSDK]printLog:result];
                    [[Youai_LOG shareSDK]printLog:@"游戏脚本执行结束=============="];
                }
                //拷贝脚本
                NSString *poolsdkPath=[NSString stringWithFormat:@"%@/%@/%@/%@",NSHomeDirectory(),@"poolsdk_file",[_autoPackingParamArry[i] objectForKey:@"sdkName"],[_autoPackingParamArry[i] objectForKey:@"sdkVersionName"]];
                NSString *setingPath=[NSString stringWithFormat:@"%@/%@/%@/%@",NSHomeDirectory(),@"poolsdk_file/pool_sting",[_autoPackingParamArry[i] objectForKey:@"sdkName"],[_autoPackingParamArry[i] objectForKey:@"sdkVersionName"]];
                if([self copyPyfileOrPoolsdk:[motherEngineeringPath stringByDeletingLastPathComponent]andPoolsdkPath:poolsdkPath andPoolstingPath:setingPath]){
                     [[Youai_LOG shareSDK]printLog:@"拷贝成功"];
                    if ([self revisionsConfig:[motherEngineeringPath stringByDeletingLastPathComponent] and:[motherEngineeringPath lastPathComponent]]) {
                         [[Youai_LOG shareSDK]printLog:@"修改config.py成功"];
                        
                        NSString *cmd=[NSString stringWithFormat:@"cd %@\n python %@.py",[motherEngineeringPath stringByDeletingLastPathComponent],_chanelName];
                        NSString *result=[[commandUtils shareSDK]executeCommand:cmd];
                        [[Youai_LOG shareSDK]printLog:result];
                        if (![[FileUtils shareSDK]checkIsFile:[NSString stringWithFormat:@"%@/poolsdk_file/poolsdk_%@/info.plist",[motherEngineeringPath stringByDeletingLastPathComponent],_chanelName]]) {
                            [self showAlert:[NSString stringWithFormat:@"执行%@.py脚本失败，请检查逻辑!",_chanelName]];
                            _onAutoDB=false;
                            system([[@"open " stringByAppendingString:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"poolsdk_file/LOG"]] UTF8String]);
                            return;
                        }
                        if (result!=nil&&![result isEqualToString:@""]) {
                            
                            NSString *name=[[motherEngineeringPath lastPathComponent] stringByDeletingPathExtension];
                            NSString *file=[NSString stringWithFormat:@"%@/%@_%@.xcodeproj",[motherEngineeringPath stringByDeletingLastPathComponent],name,_chanelName];
                            [[Youai_LOG shareSDK]printLog:file];
                            if ([[FileUtils shareSDK]checkIsFile:file]) {
                              NSString *profilename= [[commandUtils shareSDK]getProfileName:[dic objectForKey:@"certificatePassword"]];
                               NSString *profilTeam=[[commandUtils shareSDK]getProfileTeamIdentifier:[dic objectForKey:@"certificatePassword"]];
                                NSString *params=[NSString stringWithFormat:@"\"%@,%@,%@,%@,%@\"",[dic objectForKey:@"certificate"],[dic objectForKey:@"uuid"],profilename,profilTeam,[dic objectForKey:@"bundleid"]];
                                NSString *cmd=[NSString stringWithFormat:@"python %@ %@ %@",[self getFilePath:@"EdictProjectConfig.py"],file,params];
                                [[Youai_LOG shareSDK]printLog:[[commandUtils shareSDK]executeCommand:cmd]];
                                NSString *ipafile=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ipaDir"]];
                                [[Youai_LOG shareSDK]printLog:ipafile];
//                                if (_ManualPacking.state) {
//                                    // 打开目录
//                                    system([[@"open " stringByAppendingString:_MotherEngineeringDirPath] UTF8String]);
//                                    return;
//                                }
                                if (![self revisionExportOptionsPlist:[dic objectForKey:@"typeMode"] and:[dic objectForKey:@"bundleid"] and:profilename and:profilTeam and:[dic objectForKey:@"signingCertificate"]]) {
                                    system([[@"open " stringByAppendingString:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"poolsdk_file/LOG"]] UTF8String]);
                                    [self showAlert:@"修改打包配置文件失败！"];
                                     _onAutoDB=false;
                                    return;
                                }
                                
                                
                                if ([[dic objectForKey:@"debug"]isEqualToString:@"1"]) {
                                    //TODU
                                    
                                    [[Youai_LOG shareSDK]printLog:[[commandUtils shareSDK]buildIPA:[motherEngineeringPath stringByDeletingLastPathComponent] andProject:file andTarget:[dic objectForKey:@"projectTarget"] andMode:@"Debug" andIpaPath:ipafile andipaname:[dic objectForKey:@"ipaPackages"] andBundleid:[dic objectForKey:@"bundleid"]]];
                                }else{
                                    
                                    [[Youai_LOG shareSDK]printLog:[[commandUtils shareSDK]buildIPA:[motherEngineeringPath stringByDeletingLastPathComponent] andProject:file andTarget:[dic objectForKey:@"projectTarget"] andMode:@"Release" andIpaPath:ipafile andipaname:[dic objectForKey:@"ipaPackages"] andBundleid:[dic objectForKey:@"bundleid"]]];
                                }
                                
                                if ([[FileUtils shareSDK]checkIsFile:[NSString stringWithFormat:@"%@/%@.ipa",ipafile,[dic objectForKey:@"ipaPackages"]]]) {
                                    
//                                    system([[@"open " stringByAppendingString:ipafile] UTF8String]);
//                                    [self showAlert:@"打包成功！"];
                                     [[Youai_LOG shareSDK]printLog:[NSString stringWithFormat:@"%@.ipa 打包成功!",[dic objectForKey:@"ipaPackages"]]];
                                }else{
                                    [self showAlert:@"打包失败！"];
                                    system([[@"open " stringByAppendingString:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"poolsdk_file/LOG"]] UTF8String]);
                                     _onAutoDB=false;
                                    return;
                                }
                                _onAutoDB=false;
                                
                            }
                        }
                        
                    }else{
                        [self showAlert:@"修改config.py失败！"];
                        _onAutoDB=false;
                        system([[@"open " stringByAppendingString:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"poolsdk_file/LOG"]] UTF8String]);
                        return;
                    }
                }else{
                    [self showAlert:@"拷贝资源失败，请检查路径"];
                    _onAutoDB=false;
                    system([[@"open " stringByAppendingString:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"poolsdk_file/LOG"]] UTF8String]);
                    return;
                }
                //
            }
        }
    }
   system([[@"open " stringByAppendingString:ipaPt] UTF8String]);
     _onAutoDB=false;
}
-(void)StratPacking:(id)sender{
   
    if (!_isSave) {
        [self showAlert:@"请先保存!"];
         _onDB=false;
        return;
    }
    if (_onDB) {
        [self showAlert:@"正在打包请稍后!"];
        return;
    }
    _onDB=true;
    [Youai_LOG shareSDK].SaveLog=true;
     NSString *logFile=[NSString stringWithFormat:@"%@/%@/log_%@.txt",NSHomeDirectory(),@"poolsdk_file/LOG",[[Youai_LOG shareSDK] getCurrentTimestamp]];
    if ([[FileUtils shareSDK]checkIsFile:logFile]) {
        [[FileUtils shareSDK]removeFileOrDir:logFile];
    }
    if ([[FileUtils shareSDK]checkIsFile:_gamePyPath.stringValue]) {
        NSString *cmd=[NSString stringWithFormat:@"python %@ %@ %@",_gamePyPath.stringValue,_MotherEngineeringDirPath,_MotherEngineeringPath.stringValue];
         [[Youai_LOG shareSDK]printLog:@"开始执行游戏脚本=============="];
         [[Youai_LOG shareSDK]printLog:cmd];
        NSString *result=[[commandUtils shareSDK]executeCommand:cmd];
        [[Youai_LOG shareSDK]printLog:result];
         [[Youai_LOG shareSDK]printLog:@"游戏脚本执行结束=============="];
    }
    
    
    if ([self copyPyfileOrPoolsdk:[_MotherEngineeringPath.stringValue stringByDeletingLastPathComponent]andPoolsdkPath:_poolsdkPath andPoolstingPath:_pool_setingPath]) {
        //TODO
        [[Youai_LOG shareSDK]printLog:@"拷贝成功"];
        if ([self revisionsConfig:[_MotherEngineeringPath.stringValue stringByDeletingLastPathComponent] and:[_MotherEngineeringPath.stringValue lastPathComponent]]) {
             [[Youai_LOG shareSDK]printLog:@"修改config.py成功"];
            NSString *cmd=[NSString stringWithFormat:@"cd %@\n python %@.py",[_MotherEngineeringPath.stringValue stringByDeletingLastPathComponent],_chanelName];
            NSString *result=[[commandUtils shareSDK]executeCommand:cmd];
             [[Youai_LOG shareSDK]printLog:result];
            if (![[FileUtils shareSDK]checkIsFile:[NSString stringWithFormat:@"%@/poolsdk_file/poolsdk_%@/info.plist",[_MotherEngineeringPath.stringValue stringByDeletingLastPathComponent],_chanelName]]) {
                [self showAlert:[NSString stringWithFormat:@"执行%@.py脚本失败，请检查逻辑!",_chanelName]];
                 _onDB=false;
                 system([[@"open " stringByAppendingString:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"poolsdk_file/LOG"]] UTF8String]);
                return;
            }
            if (result!=nil&&![result isEqualToString:@""]) {
                
                NSString *name=[[_MotherEngineeringPath.stringValue lastPathComponent] stringByDeletingPathExtension];
                NSString *file=[NSString stringWithFormat:@"%@/%@_%@.xcodeproj",_MotherEngineeringDirPath,name,_chanelName];
                [[Youai_LOG shareSDK]printLog:file];
                if ([[FileUtils shareSDK]checkIsFile:file]) {
                    NSString *params=[NSString stringWithFormat:@"\"%@,%@,%@,%@,%@\"",_certificate.stringValue,_UUID,_profilename,_profilTeam,_bundleID.stringValue];
                    NSString *cmd=[NSString stringWithFormat:@"python %@ %@ %@",[self getFilePath:@"EdictProjectConfig.py"],file,params];
                     [[Youai_LOG shareSDK]printLog:[[commandUtils shareSDK]executeCommand:cmd]];
                    NSString *ipafile=[NSString stringWithFormat:@"%@",_ipaDir.stringValue];
                     [[Youai_LOG shareSDK]printLog:ipafile];
                    if (_ManualPacking.state) {
                        // 打开目录
                        system([[@"open " stringByAppendingString:_MotherEngineeringDirPath] UTF8String]);
                        return;
                    }
                    if (![self revisionExportOptionsPlist:_typeMode and:_bundleID.stringValue and:_profilename and:_profilTeam and:_signingCertificate]) {
                         system([[@"open " stringByAppendingString:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"poolsdk_file/LOG"]] UTF8String]);
                        return;
                    }
                    
                   
                    if (_Debug.state) {
                         //TODU
                       
                         [[Youai_LOG shareSDK]printLog:[[commandUtils shareSDK]buildIPA:_MotherEngineeringDirPath andProject:file andTarget:_projectTarget.stringValue andMode:@"Debug" andIpaPath:ipafile andipaname:_ipaPackages.stringValue andBundleid:_bundleID.stringValue]];
                    }else{
                        
                         [[Youai_LOG shareSDK]printLog:[[commandUtils shareSDK]buildIPA:_MotherEngineeringDirPath andProject:file andTarget:_projectTarget.stringValue andMode:@"Release" andIpaPath:ipafile andipaname:_ipaPackages.stringValue andBundleid:_bundleID.stringValue]];
                    }
                    
                    if ([[FileUtils shareSDK]checkIsFile:[NSString stringWithFormat:@"%@/%@.ipa",ipafile,_ipaPackages.stringValue]]) {
                        
                         system([[@"open " stringByAppendingString:ipafile] UTF8String]);
                         [self showAlert:@"打包成功！"];
                    }else{
                        [self showAlert:@"打包失败！"];
                         system([[@"open " stringByAppendingString:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"poolsdk_file/LOG"]] UTF8String]);
                    }
                    _onDB=false;
                   
                }
            }
            

        }else{
            [self showAlert:@"修改config.py失败！"];
             _onDB=false;
             system([[@"open " stringByAppendingString:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"poolsdk_file/LOG"]] UTF8String]);
        }
    }else{
//         [self showAlert:@"拷贝资源失败，请检查路径"];
         _onDB=false;
         system([[@"open " stringByAppendingString:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"poolsdk_file/LOG"]] UTF8String]);
    }
 
}

-(BOOL)revisionsConfig:(NSString *)MotherEngineeringDirPath and:(NSString *)MotherEngineeringPath{//修改config.py文件
    NSString *configPath=[NSString stringWithFormat:@"%@/%@",MotherEngineeringDirPath,@"config.py"];
    NSString *gameName= [MotherEngineeringPath stringByDeletingPathExtension];
     [[Youai_LOG shareSDK]printLog:@"config.py路径："];
    [[Youai_LOG shareSDK]printLog:configPath];
     [[Youai_LOG shareSDK]printLog:gameName];
    NSArray *all=[[FileUtils shareSDK]getAllDirOrFile:MotherEngineeringDirPath];
    
//    [[Youai_LOG shareSDK]printLog:all];
    for (int i=0; i<all.count; i++) {
        if ([[all[i] lastPathComponent]isEqualToString:@"poolsdk_file"]) {
             [[Youai_LOG shareSDK]printLog:all[i]];
            
            return [self startRevision:gameName andPath:all[i] andconfigpath:configPath];
        }
    }
    
    return NO;
}
-(BOOL)startRevision:(NSString *)gameName andPath:(NSString *)path andconfigpath:(NSString *)configpath{
    
//     NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *content=[NSString stringWithFormat:@"channelRootPath = \"%@\"\ngameProjName = \"%@\"",path,gameName];
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    if ([[FileUtils shareSDK]checkIsFile:configpath]) {
        [[FileUtils shareSDK]removeFileOrDir:configpath];
    }
    BOOL ok=[[FileUtils shareSDK]createfileAtpath:configpath andData:jsonData];
     [[Youai_LOG shareSDK]printLog:content];
    
    return ok;
}
-(void)clearAllpz{
    NSString *path=[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"poolsdk_file/DBPZFILE"];
    if (path!=nil) {
        if ([[FileUtils shareSDK] checkIsFile:path]) {
            [self clearAllparams];
            [[FileUtils shareSDK] removeFileOrDir:path];
        }
    }
}
-(void)onEditing:(NSButton *)view{
    _editing=view;
    [self isEditable];
    view.hidden=YES;
    if (_save!=nil) {
        _save.title=@"保存配置";
    }
}
-(void)onSaveClick:(NSButton *)view{
    
    if (_typeMode==nil||[_typeMode isEqualToString:@""]) {
        [self showAlert:@"请选择勾选描述文件类型!"];
        return;
    }
    if (_signingCertificate==nil||[_signingCertificate isEqualToString:@""]) {
        [self showAlert:@"请选择勾选打包类型"];
        return;
    }
    
    if ([_ComputerUserName.stringValue isEqualToString:@""]||[_ipaDir.stringValue isEqualToString:@""]||[_ComputerUserPassword.stringValue isEqualToString:@""]||[_ipaPackages.stringValue isEqualToString:@""]||
        [_certificate.stringValue isEqualToString:@""]||[_certificatePassword.stringValue isEqualToString:@""]||[_MotherEngineeringPath.stringValue isEqualToString:@""]||
        [_projectTarget.stringValue isEqualToString:@""]||[_bundleID.stringValue isEqualToString:@""]) {
        [self showAlert:@"参数配置不能为空!"];
        return;
    }
    
//    [_taview reloadData];
    _save=view;
     [[Youai_LOG shareSDK]printLog:@"进来了"];
    if (_UUID==nil) {
        _UUID=@"";
    }
    if (_profilTeam==nil) {
        _profilTeam=@"";
    }
    if (_profilename==nil) {
        _profilename=@"";
    }
    
    
    _UUID=[[commandUtils shareSDK]getProfileUUID:_certificatePassword.stringValue];
//    _certificate.stringValue=[[commandUtils shareSDK]getProfileTeamName:_certificatePassword.stringValue];
    //         [[commandUtils shareSDK]getProfileAppIDName:_certificatePassword.stringValue];
    _profilename= [[commandUtils shareSDK]getProfileName:_certificatePassword.stringValue];
    _profilTeam=[[commandUtils shareSDK]getProfileTeamIdentifier:_certificatePassword.stringValue];
    
    _path=[NSString stringWithFormat:@"%@/%@",_paramsFilePath,@"params"];
    NSString *debugMode;
    if (_Debug.state) {
        debugMode=@"1";
    }else{
        debugMode=@"0";
    }
    
_dic=@{@"computerUserName":_ComputerUserName.stringValue,@"ipaDir":_ipaDir.stringValue,@"computerUserPassword":_ComputerUserPassword.stringValue,@"ipaPackages":_ipaPackages.stringValue,@"certificate":_certificate.stringValue,@"certificatePassword":_certificatePassword.stringValue,@"gamePyPath":_gamePyPath.stringValue,@"motherEngineeringPath":_MotherEngineeringPath.stringValue,@"uuid":_UUID,@"profilename":_profilename,@"projectTarget":_projectTarget.stringValue,@"typeMode":_typeMode,@"bundleid":_bundleID.stringValue,@"signingCertificate":_signingCertificate,@"paramsPath":_path,@"debug":debugMode};
    _data=[NSJSONSerialization dataWithJSONObject:_dic options:NSJSONWritingPrettyPrinted error:nil];
    
    [[Youai_LOG shareSDK]printLog:_path];
    if (![[FileUtils shareSDK]checkIsFile:_paramsFilePath]) {
        [[FileUtils shareSDK]createDirectoryAtPath:_paramsFilePath];
    }
    if ([[FileUtils shareSDK]checkIsFile:_path]) {
        [[FileUtils shareSDK]removeFileOrDir:_path];
    }
    BOOL ok=[[FileUtils shareSDK]createfileAtpath:_path andData:_data];
    if (ok) {
        [[Youai_LOG shareSDK]printLog:@"新建成功"];
        [self isNotEditable];
        _save.title=@"已保存";
        if (_editing!=nil) {
            _editing.hidden=NO;
        }
 
    }

}
-(void)clearparams{
    
   
   
    _ipaPackages.stringValue=@"";
    _certificate.stringValue=@"";
    _certificatePassword.stringValue=@"";
   _bundleID.stringValue=@"";
}
-(void)clearAllparams{
    _ComputerUserName.stringValue=@"";
    _ipaDir.stringValue=@"";
    _ComputerUserPassword.stringValue=@"";
    _ipaPackages.stringValue=@"";
    _certificate.stringValue=@"";
    _certificatePassword.stringValue=@"";
    _gamePyPath.stringValue=@"";
    _MotherEngineeringPath.stringValue=@"";
    _projectTarget.stringValue=@"";
    _bundleID.stringValue=@"";
}
-(void)isEditable{
    _isSave=NO;
    _ComputerUserName.editable=YES;
    _ipaDir.editable=YES;
    _ComputerUserPassword.editable=YES;
    _ipaPackages.editable=YES;
    _certificate.editable=YES;
    _certificatePassword.editable=YES;
    _bundleID.editable=YES;
    _gamePyPath.editable=YES;
      _projectTarget.editable=YES;
    _MotherEngineeringPath.editable=YES;
    _selectGamePyPath.hidden=NO;
    _selectCertificatePath.hidden=NO;
    _selectIpaDirPath.hidden=NO;
    _selectMotherEngineeringPath.hidden=NO;
    
    if (_save!=nil) {
        _save.title=@"保存配置";
    }
}

-(void)isNotEditable{
    _isSave=YES;
    _ComputerUserName.editable=NO;
    _ipaDir.editable=NO;
    _ComputerUserPassword.editable=NO;
    _ipaPackages.editable=NO;
    _certificate.editable=NO;
    _certificatePassword.editable=NO;
    _gamePyPath.editable=NO;
    _bundleID.editable=NO;
    _MotherEngineeringPath.editable=NO;
    _projectTarget.editable=NO;
    _selectGamePyPath.hidden=YES;
    _selectCertificatePath.hidden=YES;
    _selectIpaDirPath.hidden=YES;
    _selectMotherEngineeringPath.hidden=YES;
    
}
-(void)initview:(NSTextField *)ComputerUserName and:(NSTextField *)ipaDir and:(NSTextField *)ComputerUserPassword and:(NSTextField *)ipaPackages and:(NSTextField *)certificate and:(NSTextField *)certificatePassword and:(NSTextField *)gamePyPath and:(NSTextField *)MotherEngineeringPath andProjectTarget:(NSTextField *)target andDundleID:(NSTextField *)bundleid{
    _ComputerUserName=ComputerUserName;
    _ipaDir=ipaDir;
    _ComputerUserPassword=ComputerUserPassword;
    _ipaPackages=ipaPackages;
    _certificate=certificate;
    _certificatePassword=certificatePassword;
    _gamePyPath=gamePyPath;
    _MotherEngineeringPath=MotherEngineeringPath;
    _projectTarget=target;
    _bundleID=bundleid;
     [self hiddenview];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
   
    return [ViewUtils shareSDK].Array.count;
    
}

//这个方法虽然不返回什么东西，但是必须实现，不实现可能会出问题－比如行视图显示不出来等。（10.11貌似不实现也可以，可是10.10及以下还是不行的）
- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    return nil;
    
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    
    return 60;
    
}


- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    
 
    NSString *strIdt=[tableColumn identifier];
    NSTableCellView *aView = [tableView makeViewWithIdentifier:strIdt owner:self];
    if (!aView)
        aView = [[NSTableCellView alloc]initWithFrame:CGRectMake(0, 0, tableColumn.width, 60)];
    else
        for (NSView *view in aView.subviews)[view removeFromSuperview];
    NSTextField *name= [[NSTextField alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    [[ViewUtils shareSDK]textFieldUtils:[[ViewUtils shareSDK].Array[row] objectForKey:@"sdkName"] andTextFiled:name];
    [aView addSubview:name];
    
    
    NSTextField *version= [[NSTextField alloc]initWithFrame:CGRectMake(120, 10, 100, 30)];
    [[ViewUtils shareSDK]textFieldUtils:[[ViewUtils shareSDK].Array[row] objectForKey:@"sdkVersionName"] andTextFiled:version];
    [aView addSubview:version];
    NSDictionary *dataDic=@{@"sdkName":[[ViewUtils shareSDK].Array[row] objectForKey:@"sdkName"],@"sdkVersionName":[[ViewUtils shareSDK].Array[row] objectForKey:@"sdkVersionName"]};
    [ _autoPackingParamArry addObject:dataDic];
    return aView;
    
}
-(void)clearData{
    [_autoPackingParamArry removeAllObjects];
    [_taview removeFromSuperview];
}
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    
    [[Youai_LOG shareSDK]printLog:@"选中了row"];
    _selectrow=row;
//    if (_save!=nil) {
//         _save.title=@"保存配置";
//    }
//
    return YES;
    
    
}
-(void)hiddenview{
    _ComputerUserName.hidden=YES;
    _ipaDir.hidden=YES;
    _ComputerUserPassword.hidden=YES;
    _ipaPackages.hidden=YES;
    _certificate.hidden=YES;
    _certificatePassword.hidden=YES;
    _gamePyPath.hidden=YES;
    _MotherEngineeringPath.hidden=YES;
    _projectTarget.hidden=YES;
    _bundleID.hidden=YES;
}

-(void)showview{
    _ComputerUserName.hidden=NO;
    _ipaDir.hidden=NO;
    _ComputerUserPassword.hidden=NO;
    _ipaPackages.hidden=NO;
    _certificate.hidden=NO;
    _certificatePassword.hidden=NO;
    _gamePyPath.hidden=NO;
    _MotherEngineeringPath.hidden=NO;
     _projectTarget.hidden=NO;
    _bundleID.hidden=NO;
}
- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn{
    
     [[Youai_LOG shareSDK]printLog:@"点击了行"];
    
    
}
-(void)getviewVaule{
    NSString *path=[NSString stringWithFormat:@"%@/%@",_paramsFilePath,@"params"];
    
    if ([[FileUtils shareSDK] checkIsFile:path] ) {
         [[Youai_LOG shareSDK]printLog:path];
         NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

        [[Youai_LOG shareSDK]printLog:@"取到的数据是：" andmsg:content];
        NSDictionary *dic=[self dictionaryWithJsonString:content];
        
        if (dic==nil) {
            return;
        }

         [[Youai_LOG shareSDK]printLog:dic];
        _ComputerUserName.stringValue=[dic objectForKey:@"computerUserName"];
        _ipaDir.stringValue=[dic objectForKey:@"ipaDir"];
         _ComputerUserPassword.stringValue=[dic objectForKey:@"computerUserPassword"];
         _ipaPackages.stringValue=[dic objectForKey:@"ipaPackages"];
        _certificate.stringValue=[dic objectForKey:@"certificate"];
         _certificatePassword.stringValue=[dic objectForKey:@"certificatePassword"];
         _gamePyPath.stringValue=[dic objectForKey:@"gamePyPath"];
        _MotherEngineeringPath.stringValue=[dic objectForKey:@"motherEngineeringPath"];
        _UUID=[dic objectForKey:@"uuid"];
        _projectTarget.stringValue=[dic objectForKey:@"projectTarget"];
        _typeMode=[dic objectForKey:@"typeMode"];
        _bundleID.stringValue=[dic objectForKey:@"bundleid"];
        _signingCertificate=[dic objectForKey:@"signingCertificate"];
    }
  
}
// 选中的响应
-(void)tableViewSelectionDidChange:(nonnull NSNotification* )notification{
    
   
    _paramsFilePath=[NSString stringWithFormat:@"%@/%@/%@/%@",NSHomeDirectory(),@"poolsdk_file/DBPZFILE",[[ViewUtils shareSDK].Array[_selectrow] objectForKey:@"sdkName"],[[ViewUtils shareSDK].Array[_selectrow]
                                                                                                                                                                           objectForKey:@"sdkVersionName"]];
    _poolsdkPath=[NSString stringWithFormat:@"%@/%@/%@/%@",NSHomeDirectory(),@"poolsdk_file",[[ViewUtils shareSDK].Array[_selectrow] objectForKey:@"sdkName"],[[ViewUtils shareSDK].Array[_selectrow]objectForKey:@"sdkVersionName"]];
    _pool_setingPath=[NSString stringWithFormat:@"%@/%@/%@/%@",NSHomeDirectory(),@"poolsdk_file/pool_sting",[[ViewUtils shareSDK].Array[_selectrow] objectForKey:@"sdkName"],[[ViewUtils shareSDK].Array[_selectrow]objectForKey:@"sdkVersionName"]];
    if (![[FileUtils shareSDK]checkIsFile:_paramsFilePath]) {
        [[FileUtils shareSDK]createDirectoryAtPath:_paramsFilePath];
    }
    [self clearparams];
     [self getviewVaule];
    [self showview];
    if (_typeMode==nil||[_typeMode isEqualToString:@""]) {
        _typeAd_hoc.state=0;
        _typeApp_store.state=0;
        _typeEnterprise.state=0;
        _typeDevelopment.state=0;
        
    }else if([_typeMode isEqualToString:@"app-store"]){
        _typeAd_hoc.state=0;
        _typeApp_store.state=1;
        _typeEnterprise.state=0;
        _typeDevelopment.state=0;
    }else if ([_typeMode isEqualToString:@"ad-hoc"]){
        _typeAd_hoc.state=1;
        _typeApp_store.state=0;
        _typeEnterprise.state=0;
        _typeDevelopment.state=0;
    }else if ([_typeMode isEqualToString:@"enterprise"]){
        _typeAd_hoc.state=0;
        _typeApp_store.state=0;
        _typeEnterprise.state=1;
        _typeDevelopment.state=0;
    }else if ([_typeMode isEqualToString:@"development"]){
        _typeAd_hoc.state=0;
        _typeApp_store.state=0;
        _typeEnterprise.state=0;
        _typeDevelopment.state=1;
    }
    
    if (_signingCertificate==nil||[_signingCertificate isEqualToString:@""]) {
        
        _Release.state=0;
        _Debug.state=0;

        
    }else if ([_signingCertificate isEqualToString:@"iPhone Developer"]){
        _Release.state=0;
        _Debug.state=1;
    }else if ([_signingCertificate isEqualToString:@"iPhone Distribution"]){
        _Release.state=1;
        _Debug.state=0;
    }
    
}
- (BOOL)selectionShouldChangeInTableView:(NSTableView *)tableView
{
    
    
    [[Youai_LOG shareSDK]printLog:@"允许选中表数据"];
    return YES;
    
    
}
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    [[Youai_LOG shareSDK]printLog:@"数据willDisplayCell"];
    
    
}
- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    
    [[Youai_LOG shareSDK]printLog:@"允许编辑表数据"];
    return YES;
    
    
}

#pragma mark - tableview滚动处理
-(void)tableviewDidScroll:(NSNotification *)notification
{
    
    //    NSClipView *contentView = [notification object];
    //    NSLog(@"总高度：%d",contentView.visibleRect.origin.y);
    
}
-(void)setNSNotificationCenter:(NSTableView *)view{
    //监测tableview滚动
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(tableviewDidScroll:)
                                                name:NSViewBoundsDidChangeNotification
                                              object:[[view enclosingScrollView] contentView]];
}
-(void)tableViewUtils:(NSTableView *)view{//表格属性封装
    _taview=view;
    //    [_gameTableview setBackgroundColor:[NSColor colorWithCalibratedRed:23 green:220.0/255 blue:220.0/255 alpha:1.0]];
    view.focusRingType = NSFocusRingTypeDefault;                          //tableview获得焦点时的风格
    view.selectionHighlightStyle = NSTableViewSelectionHighlightStyleSourceList;//行高亮的风格
    view.headerView.frame = NSZeroRect;                                   //表头
    view.delegate = self;
    view.dataSource = self;
}

-(void)scrollViewUtils:(NSScrollView *)view andTableView:(NSTableView *)tbview andWindow:(NSWindow *)weindow{//属性封装
    _autoPackingParamArry=[NSMutableArray array];
    _dbpzWindow=weindow;
    [view setDocumentView:tbview];
    //     view.pageScroll=YES;
    [view setDrawsBackground:NO];        //不画背景（背景默认画成白色）
    [view setHasVerticalScroller:YES];   //有垂直滚动条
    //[view setHasHorizontalScroller:YES];   //有水平滚动条
    view.autohidesScrollers = YES;       //自动隐藏滚动条（滚动的时候出现）
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
