//
//  TableViewUtils.h
//  SJH_OEM
//  Author PENGTAO
//  Created by me on 2018/7/30.
//  Copyright © 2018年 me. All rights reserved.
//
#import <Cocoa/Cocoa.h>
@interface ViewUtils:NSObject
@property NSDictionary *gameparams;
@property NSMutableDictionary *dbpzdataAll;
@property NSMutableArray *dbpzdataArray;
@property NSMutableArray *dbpzArray;
@property NSMutableArray *Array;
+ (ViewUtils *)shareSDK;
-(void)clearData:(NSImageView *)img and:(NSTextField *)field and:(NSTextField *)fiel2;
-(void)reloadData:(NSTableView *)view;
-(void)drowLineUtils:(NSTextField *)view;
-(void)imageViewUtils:(NSString *)path andImg:(NSImageView *)view;
-(void)textFieldUtils:(NSString *)text andTextFiled:(NSTextField *)field;
-(NSString *)cheackNullData:(NSString *)smg;
@end
