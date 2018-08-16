//
//  paramesListView.m
//  SJH_OEM
//  Author PENGTAO
//  Created by me on 2018/8/1.
//  Copyright © 2018年 me. All rights reserved.
//
#import "paramesListView.h"
#import "ViewUtils.h"
@interface paramesListView()<NSTabViewDelegate,NSTableViewDataSource>
@property NSTableView *paramTableView;

@property NSScrollView *paramScrollView;
@property NSDictionary *parameterdic;
@property NSArray *parameterdicAllKeys;
@property NSArray *parameterdicAllValues;
@end
static paramesListView *selectins= nil;
@implementation paramesListView
+ (paramesListView *)shareSDK
{
    static dispatch_once_t dgonceToken;
    dispatch_once(&dgonceToken, ^{
        selectins = [[paramesListView alloc] init];
        
    });
    
    return selectins;
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
     [[Youai_LOG shareSDK]printLog:@"行数为：" andmsg:[@(_parameterdic.count)stringValue]];
    return _parameterdicAllKeys.count;
    
}

//这个方法虽然不返回什么东西，但是必须实现，不实现可能会出问题－比如行视图显示不出来等。（10.11貌似不实现也可以，可是10.10及以下还是不行的）
- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    return nil;
    
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
   
    return 100;
    
}


- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    
     [[Youai_LOG shareSDK]printLog:@"获取到参数key为：" andmsg:_parameterdicAllKeys[row]];
     [[Youai_LOG shareSDK]printLog:@"获取到参数value为：" andmsg:_parameterdicAllValues[row]];
    NSString *strIdt=[tableColumn identifier];
    NSTableCellView *aView = [tableView makeViewWithIdentifier:strIdt owner:self];
    if (!aView)
        aView = [[NSTableCellView alloc]initWithFrame:CGRectMake(0, 0, tableColumn.width, 100)];
    else
        for (NSView *view in aView.subviews)[view removeFromSuperview];
   NSTextField *valuefield=[[NSTextField alloc] initWithFrame:CGRectMake(10, 10, tableColumn.width, 30)];
    [[ViewUtils shareSDK]textFieldUtils:_parameterdicAllValues[row] andTextFiled:valuefield];
//     valuefield.editable=true;
    [valuefield setBordered:true];
    [valuefield setEditable:true];
    [valuefield setSelectable:true];
    
    [aView addSubview:valuefield];
    NSTextField *titlefield=[[NSTextField alloc] initWithFrame:CGRectMake(10, 50, tableColumn.width/2, 40)];
     [[ViewUtils shareSDK]textFieldUtils:_parameterdicAllKeys[row] andTextFiled:titlefield];
    titlefield.editable=false;
   
    [aView addSubview:titlefield];
    return aView;
    
}
-(void)clearData{
    
}
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    
  
    
    return YES;
    
    
}
- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn{
    
   
    
    
}

// 选中的响应
-(void)tableViewSelectionDidChange:(nonnull NSNotification* )notification{
  
    
    
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
    //    [_gameTableview setBackgroundColor:[NSColor colorWithCalibratedRed:23 green:220.0/255 blue:220.0/255 alpha:1.0]];
    view.focusRingType = NSFocusRingTypeDefault;                             //tableview获得焦点时的风格
    view.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;//行高亮的风格
    view.headerView.frame = NSZeroRect;                                   //表头
    view.delegate = self;
    view.dataSource = self;
}

-(void)scrollViewUtils:(NSScrollView *)view andTableView:(NSTableView *)tbview{//属性封装
    _paramTableView=tbview;
    _paramScrollView=view;
    [view setDocumentView:tbview];
    //     view.pageScroll=YES;
    [view setDrawsBackground:NO];        //不画背景（背景默认画成白色）
    [view setHasVerticalScroller:YES];   //有垂直滚动条
    //[view setHasHorizontalScroller:YES];   //有水平滚动条
    view.autohidesScrollers = YES;       //自动隐藏滚动条（滚动的时候出现）
}

-(void)setData:(NSDictionary *)data
{

    if (data!=nil&&data.count>0) {
        
       
    
         NSString *parameters=[data objectForKey:@"parameters"];
         [[Youai_LOG shareSDK]printLog:@"获取到参数为：" andmsg:parameters];
        
        _parameterdic=[self dictionaryWithJsonString:parameters];
        _parameterdicAllKeys=_parameterdic.allKeys;
        _parameterdicAllValues=_parameterdic.allValues;
        
        [[ViewUtils shareSDK]reloadData:_paramTableView];
    }
   
    
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
