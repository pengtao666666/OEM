//
//  SDKManagerView.h
//  SJH_OEM
//  Author PENGTAO
//  Created by me on 2018/8/2.
//  Copyright © 2018年 me. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "Youai_LOG.h"
@interface SDKManagerView : NSObject<NSApplicationDelegate>
@property BOOL isSearch;
+ (SDKManagerView *)shareSDK;
-(void)tableViewUtils:(NSTableView *)view;
-(void)scrollViewUtils:(NSScrollView *)view andTableView:(NSTableView *)tbview;
-(void)setNSNotificationCenter:(NSTableView *)view;
-(void)setData:(NSMutableArray *)data;
-(void)clearData;
-(void)setprogressIndicatorview:(NSTextField *)title;
@end
