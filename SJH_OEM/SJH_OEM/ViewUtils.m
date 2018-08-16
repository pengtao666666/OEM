//
//  TableViewUtils.m
//  SJH_OEM
//  Author PENGTAO
//  Created by me on 2018/7/30.
//  Copyright © 2018年 me. All rights reserved.
//

#import "ViewUtils.h"
@interface ViewUtils()

@end
static ViewUtils *ins= nil;
@implementation ViewUtils
+ (ViewUtils *)shareSDK
{
    static dispatch_once_t dgonceToken;
    dispatch_once(&dgonceToken, ^{
        ins = [[ViewUtils alloc] init];
        
    });
    
    return ins;
}
-(NSString *)cheackNullData:(NSString *)smg{
    if (smg==nil) {
//        NSLog(@"数据空了%@",smg);
        return @"空了";
    }else{
        return smg;
    }
}
-(void)clearData:(NSImageView *)img and:(NSTextField *)field and:(NSTextField *)fiel2{//清理数据，防止返回上个页面后再次进入时数据重叠的问题
    if (img!=nil) {
         img.image=nil;
    }
    if (field!=nil) {
       field.stringValue=@"";
    }
    if (fiel2!=nil) {
        fiel2.stringValue=@"";
    }
    
}
-(void)reloadData:(NSTableView *)view{//数据刷新
    [view reloadData];
}
-(void)drowLineUtils:(NSTextField *)view{//线条属性封装
    view.layer.borderColor = [NSColor greenColor].CGColor;
    view.drawsBackground = YES;
    view.bordered = NO;
    view.focusRingType = NSFocusRingTypeNone;
    view.editable = NO;
}
-(void)imageViewUtils:(NSString *)path andImg:(NSImageView *)view{//图片属性配置封装
    //设置圆角
    view.wantsLayer = YES;
    view.layer.cornerRadius = 35.0f;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [NSColor greenColor].CGColor;
    view.layer.masksToBounds = YES;
    view.image =  [[NSImage alloc]initWithContentsOfURL:[NSURL URLWithString:path]];
}
-(void)textFieldUtils:(NSString *)text andTextFiled:(NSTextField *)field{//文本属性封装
    field.stringValue = text;
    field.font = [NSFont systemFontOfSize:15.0f];
    field.textColor = [NSColor blackColor];
    field.drawsBackground = NO;
    field.bordered = NO;
    field.focusRingType = NSFocusRingTypeNone;
    field.editable = NO;
}

@end
