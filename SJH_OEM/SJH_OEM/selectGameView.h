//
//  selectGameView.h
//  SJH_OEM
//  Author PENGTAO
//  Created by me on 2018/7/30.
//  Copyright © 2018年 me. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "Youai_LOG.h"
@interface selectGameView : NSObject<NSApplicationDelegate>

+ (selectGameView *)shareSDK;
-(void)tableViewUtils:(NSTableView *)view;
-(void)scrollViewUtils:(NSScrollView *)view andTableView:(NSTableView *)tbview;
-(void)setNSNotificationCenter:(NSTableView *)view;
-(void)setData:(NSMutableArray *)data;
-(void)clearData;
-(void)initview:(NSTextField *)sdkid sdk:(NSTextField *)sdk sdkvison:(NSTextField *)version sdkvsionname:(NSTextField *)versionname channel:(NSTextField *)chnnle packge:(NSTextField *)pac;
@end
