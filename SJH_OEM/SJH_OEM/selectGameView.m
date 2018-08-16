//
//  selectGameView.m
//  SJH_OEM
//  Author PENGTAO
//  Created by me on 2018/7/30.
//  Copyright © 2018年 me. All rights reserved.
//
#import "paramesListView.h"
#import "ViewUtils.h"
#import "selectGameView.h"
#import "FileUtils.h"
@interface selectGameView()<NSTabViewDelegate,NSTableViewDataSource,NSSearchFieldDelegate>
@property (strong ) NSMutableArray *datadic;
@property NSTextField *textField;
@property NSButton *pushButton;

@property NSTextField *SDKID;
@property  NSTextField *SDK;
@property  NSTextField *SDKVersion;
@property  NSTextField *SDKVersionName;
@property  NSTextField *SDKChannle;
@property  BOOL isOn;
@property NSTextField *packgese;



@property NSInteger rowitem;



@end
static selectGameView *selectins= nil;
@implementation selectGameView
+ (selectGameView *)shareSDK
{
    static dispatch_once_t dgonceToken;
    dispatch_once(&dgonceToken, ^{
        selectins = [[selectGameView alloc] init];
        
    });
    
    return selectins;
}
-(void)initview:(NSTextField *)sdkid sdk:(NSTextField *)sdk sdkvison:(NSTextField *)version sdkvsionname:(NSTextField *)versionname channel:(NSTextField *)chnnle packge:(NSTextField *)pac{
    _SDKID=sdkid;
    _SDK=sdk;
    _SDKVersion=version;
    _SDKVersionName=versionname;
    _SDKChannle=chnnle;
   
    _packgese=pac;
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (_datadic==nil||_datadic.count<1) {
        [[Youai_LOG shareSDK]printLog:@"numberOfRowsInTableView"];
        return 0;
    }
    NSLog(@"总行数@%ld",_datadic.count);
    return _datadic.count;
    
}

//这个方法虽然不返回什么东西，但是必须实现，不实现可能会出问题－比如行视图显示不出来等。（10.11貌似不实现也可以，可是10.10及以下还是不行的）
- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    return nil;
    
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
     NSLog(@"第%ld行高60",row);
    
    return 40;
    
}


- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    
    NSLog(@"第%ld行",row);
     _rowitem=row;
    NSString *strIdt=[tableColumn identifier];
   NSTableCellView *aView = [tableView makeViewWithIdentifier:strIdt owner:self];
    if (!aView)
        aView = [[NSTableCellView alloc]initWithFrame:CGRectMake(0, 0, tableColumn.width, 40)];
    else
        for (NSView *view in aView.subviews)[view removeFromSuperview];
    
    _textField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width/2+tableColumn.width/4, 30)];

    [[Youai_LOG shareSDK]printLog:@"numberOfRowsInTableView-如也"];

    NSString *text=[[ViewUtils shareSDK]cheackNullData:[_datadic[row] objectForKey:@"sdkName"]];
    [[ViewUtils shareSDK]textFieldUtils:text andTextFiled:_textField];

   
    [aView addSubview:_textField];
    _pushButton=[[NSButton alloc]initWithFrame:CGRectMake(tableColumn.width/2+tableColumn.width/4, 0, 60, 40)];

    //按钮样式
    _pushButton.bezelStyle = NSRoundedDisclosureBezelStyle;

    //是否显示背景 默认YES
    _pushButton.bordered = YES;
    //按钮的Type
    [_pushButton setButtonType:NSButtonTypeSwitch];

    //按钮的标题
    [_pushButton setTitle:@"打包"];
    //是否隐藏
    _pushButton.hidden = NO;
    //设置按钮的tag
    _pushButton.tag = 100;
    [_pushButton setAction:@selector(isclickandchanged:)];
    [_pushButton setTarget:self];
    //标题居中显示
    _pushButton.alignment = NSTextAlignmentCenter;
    //设置背景是否透明
    _pushButton.transparent = NO;
    //按钮初始状态
    _pushButton.state = NSOffState;
    //按钮是否高亮
    _pushButton.highlighted = NO;

     [aView addSubview:_pushButton];
    NSDictionary *DicData=@{@"button":_pushButton,@"row":[@(row)stringValue]};
    [[ViewUtils shareSDK].dbpzdataArray addObject:DicData];
    return aView;
    
}
-(void)isclickandchanged:(id)sender{//是否勾选打包监听
//    [[Youai_LOG shareSDK]printLog:@"状态改变了"];
    for (int i=0; i<[ViewUtils shareSDK].dbpzdataArray.count; i++) {
        NSDictionary *btdic=[ViewUtils shareSDK].dbpzdataArray[i];
        NSButton *bt=[btdic objectForKey:@"button"];
        NSString *row=[btdic objectForKey:@"row"];
       
        if (bt==sender) {
//            [[Youai_LOG shareSDK]printLog:@"状态改变了"];
           
            if (bt.state) {
                
                 [[Youai_LOG shareSDK]printLog:@"选中了"];
                for (int j=0; j<[ViewUtils shareSDK].dbpzArray.count; j++) {
                NSMutableDictionary *dic=[ViewUtils shareSDK].dbpzArray[j];
                    NSString *line=[dic objectForKey:@"line"];
                    if ([row isEqualToString:line]) {
                        [[Youai_LOG shareSDK]printLog:line];
                        if ([[ViewUtils shareSDK].Array containsObject:dic]) {
                            return;
                        }
                        [[ViewUtils shareSDK].Array addObject:dic];
                      
                    }
                }
               
            }else{
               
                [[Youai_LOG shareSDK]printLog:@"未选择"];
                for (int j=0; j<[ViewUtils shareSDK].dbpzArray.count; j++) {
                    NSMutableDictionary *dic=[ViewUtils shareSDK].dbpzArray[j];
                    NSString *line=[dic objectForKey:@"line"];
                    if ([row isEqualToString:line]) {
                        [[Youai_LOG shareSDK]printLog:line];
                        [[ViewUtils shareSDK].Array removeObject:dic];
                    }
                }
            }
           
        }
    }
}
-(void)clearData{
    [_datadic removeAllObjects];
//    _datadic=nil;
//    if (_textField!=nil) {
//         _textField.stringValue=@"";
//    }
//    if (_pushButton!=nil) {
//        _pushButton.hidden = YES;
//
//    }

}
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    
     [[Youai_LOG shareSDK]printLog:@"允许选中表数据3"];
  _rowitem=row;
  
    return YES;
    
    
}
- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn{
    
    [[Youai_LOG shareSDK]printLog:@"点击了" andmsg:tableColumn.dataCell];
    
    
}

// 选中的响应
-(void)tableViewSelectionDidChange:(nonnull NSNotification* )notification{
    /*
     
     2018-08-07 10:15:02.714496+0800 SJH_OEM[709:133319] PT_LOG: sdkName=熊猫玩
     2018-08-07 10:15:02.714504+0800 SJH_OEM[709:133319] PT_LOG: sdkVersionName=2.0
     2018-08-07 10:15:02.714512+0800 SJH_OEM[709:133319] PT_LOG: packageName=1
     2018-08-07 10:15:02.714519+0800 SJH_OEM[709:133319] PT_LOG: channelSimpleName=
     2018-08-07 10:15:02.714526+0800 SJH_OEM[709:133319] PT_LOG: sdkVersionCode=V1_0
     2018-08-07 10:15:02.714536+0800 SJH_OEM[709:133319] PT_LOG: sdkId2=482
     2018-08-07 10:15:02.714544+0800 SJH_OEM[709:133319] PT_LOG: sdkSimpleName=xiongmaowan_ios
     2018-08-07 10:15:02.714560+0800 SJH_OEM[709:133319] PT_LOG: channelParameter2=
     2018-08-07 10:15:02.714570+0800 SJH_OEM[709:133319] PT_LOG: writeToManifest2=0
     2018-08-07 10:15:02.714579+0800 SJH_OEM[709:133319] PT_LOG: parameters={"ADTKey": "", "appScheme": "", "xmwchannel": "", "TouTiaoKey": "", "client_id": ""}
     2018-08-07 10:15:02.714587+0800 SJH_OEM[709:133319] PT_LOG: gameName=风云接入测试
     2018-08-07 10:15:02.714597+0800 SJH_OEM[709:133319] PT_LOG: gameVersionId2=11
     2018-08-07 10:15:02.714604+0800 SJH_OEM[709:133319] PT_LOG: custom={}
     2018-08-07 10:15:02.714612+0800 SJH_OEM[709:133319] PT_LOG: channelParameter1=
     2018-08-07 10:15:02.714619+0800 SJH_OEM[709:133319] PT_LOG: client_type=IOS
     2018-08-07 10:15:02.714628+0800 SJH_OEM[709:133319] PT_LOG: userType2=482
     2018-08-07 10:15:02.714637+0800 SJH_OEM[709:133319] PT_LOG: itemConfig={"com.dtKrQcyh.SyooanWP_6": {"amount": "6", "name": "60钻石"}}
     2018-08-07 10:15:02.714644+0800 SJH_OEM[709:133319] PT_LOG: shareSdkAppKey=
     2018-08-07 10:15:02.714706+0800 SJH_OEM[709:133319] PT_LOG: gameSimpleName=fytx_test
     
     */
  
    //do something
   [[Youai_LOG shareSDK]printLog:@"允许选中表数据2"];
    NSDictionary *data=_datadic[_rowitem];
    _SDK.stringValue=[data objectForKey:@"sdkSimpleName"];
    _SDKID.stringValue=[data objectForKey:@"sdkId"];
    _SDKChannle.stringValue=[data objectForKey:@"channelSimpleName"];
//    _SDKChannle2.stringValue=[data objectForKey:@"channelParameter2"];
    _SDKVersion.stringValue=[data objectForKey:@"sdkVersionCode"];
    _SDKVersionName.stringValue=[data objectForKey:@"sdkVersionName"];
    _packgese.stringValue=[data objectForKey:@"packageName"];
  
    [[paramesListView shareSDK]setData:data];
    [self downloadConfigFile:data];
    
    
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
-(void)downloadConfigFile:(NSDictionary *)data{

    NSString *pool_seting_dir=[NSString stringWithFormat:@"%@/%@/%@/%@",NSHomeDirectory(),@"poolsdk_file/pool_sting",[data objectForKey:@"sdkName"],[data objectForKey:@"sdkVersionName"]];
    NSString *pool_seting_path=[NSString stringWithFormat:@"%@/%@",pool_seting_dir,@"pool_setting"];
    NSDictionary *gamepms=[ViewUtils shareSDK].gameparams;
    
    NSString *payOrderUrl=[gamepms objectForKey:@"payOrderUrl"];
    NSString *loginCheckUrl=[gamepms objectForKey:@"loginCheckUrl"];
     NSString *payCheckUrl=[gamepms objectForKey:@"payCheckUrl"];
    NSString *userType=[data objectForKey:@"userType"];
    NSString *sdkSimpleName=[data objectForKey:@"sdkSimpleName"];
    NSString *custom=[data objectForKey:@"custom"];
     NSString *sdkVersionCode=[data objectForKey:@"sdkVersionCode"];
    NSString *c1=[data objectForKey:@"channelParameter1"];
     NSString *c2=[data objectForKey:@"channelParameter2"];
    NSString *gameSimpleName=[data objectForKey:@"gameSimpleName"];
    
    NSDictionary *parameter=[self dictionaryWithJsonString:[data objectForKey:@"parameters"]];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionaryWithDictionary:parameter];
    [parameters setObject:loginCheckUrl forKey:@"loginCheckUrl"];
    [parameters setObject:payOrderUrl forKey:@"payOrderUrl"];
    [parameters setObject:payCheckUrl forKey:@"payCheckUrl"];
    [parameters setObject:userType forKey:@"userType"];
    [parameters setObject:sdkSimpleName forKey:@"sdkSimpleName"];
    [parameters setObject:custom forKey:@"custom"];
    [parameters setObject:sdkVersionCode forKey:@"sdkVersionCode"];
    [parameters setObject:c1 forKey:@"c1"];
     [parameters setObject:c2 forKey:@"c2"];
      [parameters setObject:gameSimpleName forKey:@"gameSimpleName"];
    
    [[Youai_LOG shareSDK]printLog:@"拼接后的数据：" andmsg:parameters];
    
     NSData *da=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    
    [[Youai_LOG shareSDK]printLog:@"pool_seting路径为：" andmsg:pool_seting_path];
    
    if (![[FileUtils shareSDK]checkIsFile:pool_seting_dir]) {
        [[FileUtils shareSDK]createDirectoryAtPath:pool_seting_dir];
    }
    if ([[FileUtils shareSDK]checkIsFile:pool_seting_path]) {
        [[FileUtils shareSDK]removeFileOrDir:pool_seting_path];
    }
    BOOL ok=[[FileUtils shareSDK]createfileAtpath:pool_seting_path andData:da];
    if (ok) {
        [[Youai_LOG shareSDK]printLog:@"新建成功"];
    }
   
    
    
    [ViewUtils shareSDK].dbpzdataAll=parameters;
    
    [[ViewUtils shareSDK].dbpzdataAll setObject:[data objectForKey:@"sdkName"] forKey:@"sdkName"];
    [[ViewUtils shareSDK].dbpzdataAll setObject:[data objectForKey:@"sdkVersionName"] forKey:@"sdkVersionName"];
    [[ViewUtils shareSDK].dbpzdataAll setObject:[@(_rowitem)stringValue] forKey:@"line"];
     [[Youai_LOG shareSDK]printLog:@"dbpzdataAll：" andmsg: [ViewUtils shareSDK].dbpzdataAll];
     [[ViewUtils shareSDK].dbpzArray addObject:[ViewUtils shareSDK].dbpzdataAll];
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
    return NO;
    
    
}

#pragma mark - tableview滚动处理
-(void)tableviewDidScroll:(NSNotification *)notification
{
   
    NSClipView *contentView = [notification object];
     NSLog(@"总高度：%d",contentView.visibleRect.origin.y);
//
//        CGFloat scrollY = contentView.visibleRect.origin.y-60;//这里减去20是因为tableHeader的20高度
//    CGFloat scrollx = contentView.visibleRect.origin.x;//这里减去20是因为tableHeader的20高度
//    CGPointMake(scrollx, scrollY);
    //    _scrollTF.stringValue = [NSString stringWithFormat:@"滚动 %.1f",scrollY];
//     [[Youai_LOG shareSDK]printLog:[NSString stringWithFormat:@"滚动 y%.1f",scrollY]];
//     [[Youai_LOG shareSDK]printLog:[NSString stringWithFormat:@"滚动 x%.1f",scrollx]];
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
    view.focusRingType = NSFocusRingTypeNone;                             //tableview获得焦点时的风格
    view.selectionHighlightStyle = NSTableViewSelectionHighlightStyleRegular;//行高亮的风格
    view.headerView.frame = NSZeroRect;                                   //表头
    view.delegate = self;
    view.dataSource = self;
}

-(void)scrollViewUtils:(NSScrollView *)view andTableView:(NSTableView *)tbview{//属性封装
    [ViewUtils shareSDK].dbpzdataArray=[NSMutableArray array];
     [ViewUtils shareSDK].dbpzArray=[NSMutableArray array];
     [ViewUtils shareSDK].Array=[NSMutableArray array];
    [view setDocumentView:tbview];
//     view.pageScroll=YES;
    [view setDrawsBackground:NO];        //不画背景（背景默认画成白色）
    [view setHasVerticalScroller:YES];   //有垂直滚动条
    //[view setHasHorizontalScroller:YES];   //有水平滚动条
    view.autohidesScrollers = YES;       //自动隐藏滚动条（滚动的时候出现）
}
-(void)setData:(NSMutableArray *)data{
    _datadic=data;
}
@end
