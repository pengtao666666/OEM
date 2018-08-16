//
//  paramesListView.h
//  SJH_OEM
//  Author PENGTAO
//  Created by me on 2018/8/1.
//  Copyright © 2018年 me. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "Youai_LOG.h"
@interface paramesListView : NSObject<NSApplicationDelegate>

+ (paramesListView *)shareSDK;
-(void)tableViewUtils:(NSTableView *)view;
-(void)scrollViewUtils:(NSScrollView *)view andTableView:(NSTableView *)tbview;
-(void)setNSNotificationCenter:(NSTableView *)view;
-(void)setData:(NSDictionary *)data;
-(void)clearData;

@end
