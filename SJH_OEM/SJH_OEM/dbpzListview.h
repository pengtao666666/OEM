//
//  dbpzListview.h
//  SJH_OEM
//  Author PENGTAO
//  Created by me on 2018/8/7.
//  Copyright © 2018年 me. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "Youai_LOG.h"
@interface dbpzListview : NSObject

+ (dbpzListview *)shareSDK;
-(void)tableViewUtils:(NSTableView *)view;
-(void)scrollViewUtils:(NSScrollView *)view andTableView:(NSTableView *)tbview andWindow:(NSWindow *)weindow;
-(void)setNSNotificationCenter:(NSTableView *)view;

-(void)clearData;
-(void)initview:(NSTextField *)ComputerUserName and:(NSTextField *)ipaDir and:(NSTextField *)ComputerUserPassword and:(NSTextField *)ipaPackages and:(NSTextField *)certificate and:(NSTextField *)certificatePassword and:(NSTextField *)gamePyPath and:(NSTextField *)MotherEngineeringPath andProjectTarget:(NSTextField *)target andDundleID:(NSTextField *)bundleid;
-(void)onSaveClick:(NSButton *)view;
-(void)clearAllpz;
-(NSString *)getFilePath:(NSString *)file;
-(void)onEditing:(NSButton *)view;
-(void)initMoreAutoPackingView:(NSButton *)button;
-(void)initResouceViewIconsPath:(NSTextField *)icons andLaunchImagesPath:(NSTextField *)imagesPath andSelectIcons:(NSButton *)selectIcons andSelectImagesPath:(NSButton *)selectImagesPath;
-(void)initTypeSelectView:(NSButton *)app_store and:(NSButton *)ad_hoc and:(NSButton *)enterprise and:(NSButton *)development;
-(void)initButtonView:(NSButton *)selectCertificatePath and:(NSButton *)selectIpaDirPath and:(NSButton *)selectGamePyPath and:(NSButton *)selectMotherEngineeringPath and:(NSButton *)ManualPacking and:(NSButton *)AutoPacking  and:(NSButton *)StratPacking and:(NSButton *)debug and:(NSButton *)release;
@end
