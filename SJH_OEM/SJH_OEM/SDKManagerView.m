//
//  SDKManagerView.m
//  SJH_OEM
//  Author PENGTAO
//  Created by me on 2018/8/2.
//  Copyright © 2018年 me. All rights reserved.
//
#import "HttpUtils.h"
#import "SDKManagerView.h"
#import "ViewUtils.h"
#import "interfaceConfig.h"
#import "DownloadFileUtils.h"
#import "FileUtils.h"
#define weakObject(type) __weak typeof(type) weak##type = type
#import "SSZipArchive/SSZipArchive.h"

@interface SDKManagerView()<NSTabViewDelegate,NSTableViewDataSource>
@property NSMutableArray *sdkVersionListArray;
@property NSMutableArray *sdkVersionSearchListArray;
@property NSMutableArray *downloadParamsArray;
@property NSButton *download;
@property NSTextField *downloadSDKManagerTitle;

@property NSString *buttonTitle;
@property (nonatomic, strong) NSString *newpoolsdk_file;
@property (nonatomic, strong) NSString *sdkfilepath;
@property (nonatomic, strong) NSString *poolsdksdkpath;
@property (nonatomic, strong) NSString *removepoolsdksdkpath;
@property NSTableView *tableview;
@property BOOL isupdate;
@property int stause;
@end
static SDKManagerView *selectins= nil;
@implementation SDKManagerView
+ (SDKManagerView *)shareSDK
{
    static dispatch_once_t dgonceToken;
    dispatch_once(&dgonceToken, ^{
        selectins = [[SDKManagerView alloc] init];
        
    });
    
    return selectins;
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (_isSearch) {
        return _sdkVersionSearchListArray.count;
    }else{
         return [HttpUtils shareSDK].dataDictionary.count;
    }
   
    
}

//这个方法虽然不返回什么东西，但是必须实现，不实现可能会出问题－比如行视图显示不出来等。（10.11貌似不实现也可以，可是10.10及以下还是不行的）
- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    return nil;
    
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    
    return 150;
    
}


- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    
    /*
     
     
     {
     "description": "",
     "name": "iTools iOS",  需要
     "partnerCompanyId": 0,
     "client_type": "IOS",
     "sdkConfig": "",
     "simpleName": "itools",
     "currentVersion": "V3.0.3",
     "iconUri": "/static/img/default-s.png", 需要
     "writeToManifest": 0,
     "parameterFormat": "",
     "id": 72,   需要
     "sdkVersionList": [{ 需要
     "status": 2,
     "code": "V2_5_1", 需要
     "description": "",
     "zipPlugUri": "/static/upload/zip/2018/4/10/1523337055_itools.zip",  需要
     "createDate": "2016-03-02 13:37:25",
     "completeDate": "2016-03-02 13:37:25",
     "config_template": {
     "client": [{
     "key_name": "appScheme",
     "describe": "bundle id(com.mango.ios.fytx)",
     "name": "appScheme"
     }],
     "server": [{
     "key_name": "APP_ID",
     "describe": "APP_ID",
     "name": "APP_ID"
     }, {
     "key_name": "PUBLIC_KEY",
     "describe": "PUBLIC_KEY",
     "name": "PUBLIC_KEY"
     }]
     },
     "sdkId": 72,
     "help_url": null,
     "zipSdkUri": "",
     "id": 100,
     "name": "V3.0.2" 需要
     }, {
     "status": 2,
     "code": "V3_0_2",
     "description": " ",
     "zipPlugUri": "/static/upload/zip/2018/4/10/1523354394_itools.zip",
     "createDate": "2018-04-10 14:38:12",
     "completeDate": "2018-04-10 14:38:12",
     "config_template": {
     "client": [{
     "key_name": "APP_ID",
     "describe": "APP_ID",
     "name": "APP_ID"
     }, {
     "key_name": "APP_KEY",
     "describe": "APP_KEY",
     "name": "APP_KEY"
     }, {
     "key_name": "appScheme",
     "describe": "bundle id(com.mango.ios.fytx)",
     "name": "appScheme"
     }, {
     "key_name": "loginShowView",
     "describe": "登录界面可否关闭(YES/NO)默认YES",
     "name": "loginShowView"
     }, {
     "key_name": "AutoLogin",
     "describe": "可否自动登录(YES/NO)默认YES",
     "name": "AutoLogin"
     }, {
     "key_name": "showFloatView",
     "describe": "浮标是否展示(YES/NO)默认YES",
     "name": "showFloatView"
     }],
     "server": [{
     "key_name": "APP_ID",
     "describe": "APP_ID",
     "name": "APP_ID"
     }, {
     "key_name": "PUBLIC_KEY",
     "describe": "固定值 MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC2kcrRvxURhFijDoPpqZ/IgPlAgppkKrek6wSrua1zBiGTwHI2f+YCa5vC1JEiIi9uw4srS0OSCB6kY3bP2DGJagBoEgj/rYAGjtYJxJrEiTxVs5/GfPuQBYmU0XAtPXFzciZy446VPJLHMPnmTALmIOR5Dddd1Zklod9IQBMjjwIDAQAB",
     "name": "rsa公钥"
     }]
     },
     "sdkId": 72,
     "help_url": null,
     "zipSdkUri": "",
     "id": 760,
     "name": "V3.0.3"
     }],
     "channelUserType": 0
     }
     
     
     */
    NSString *strIdt=[tableColumn identifier];
    NSTableCellView *aView = [tableView makeViewWithIdentifier:strIdt owner:self];
    if (!aView)
        aView = [[NSTableCellView alloc]initWithFrame:CGRectMake(0, 0, tableColumn.width, 150)];
    else
        for (NSView *view in aView.subviews)[view removeFromSuperview];
    NSInteger num=0;
    NSMutableArray *data;
    if (_isSearch) {
        data=_sdkVersionSearchListArray;
    }else{
        data=[HttpUtils shareSDK].dataDictionary;
    }
    
    
     NSDictionary *sdkVersionList=[data[row] objectForKey:@"sdkVersionList"];

    [self pasedata:sdkVersionList];
    for (int i=0; i<_sdkVersionListArray.count; i++) {
        
        NSImageView *imgView = [[NSImageView alloc]initWithFrame:CGRectMake(10+num, 20, 120, 120)];
        NSString *path=[NSString stringWithFormat:@"%@%@",enterprisePlatformRootUrl,[data[row] objectForKey:@"iconUri"]];
        
        [[ViewUtils shareSDK]imageViewUtils:path andImg:imgView];
      
        NSTextField *name= [[NSTextField alloc]initWithFrame:CGRectMake(150+num, 100, 80, 30)];
        [[ViewUtils shareSDK]textFieldUtils:[data[row] objectForKey:@"name"] andTextFiled:name];
        
        NSTextField *version= [[NSTextField alloc]initWithFrame:CGRectMake(150+num, 60, 80, 30)];
        [[ViewUtils shareSDK]textFieldUtils:[_sdkVersionListArray[i] objectForKey:@"name"] andTextFiled:version];
        NSString *zipPlugUri=[_sdkVersionListArray[i] objectForKey:@"zipPlugUri"];
         [[Youai_LOG shareSDK]printLog:@"zipPlugUri检查路径为：" andmsg:zipPlugUri];
        NSString *fileUrl;
        if (zipPlugUri==nil||[zipPlugUri isEqualToString:@""]) {
            fileUrl=@"";
        }else{
            fileUrl=[NSString stringWithFormat:@"%@%@",enterprisePlatformRootUrl,zipPlugUri];
        }
        
        _download=[[NSButton alloc]initWithFrame:CGRectMake(150+num, 10, 70, 30)];
         NSString *poolsdk_file=[NSString stringWithFormat:@"%@%@/%@/%@",NSHomeDirectory(),@"/poolsdk_file",[data[row] objectForKey:@"name"] ,[_sdkVersionListArray[i] objectForKey:@"name"] ];
        
        NSString *cpath=[NSString stringWithFormat:@"%@/%@",poolsdk_file,[[FileUtils shareSDK] checkfileName:fileUrl]];
       
//         [[Youai_LOG shareSDK]printLog:cpath];
        [[Youai_LOG shareSDK]printLog:@"检查路径为：" andmsg:cpath];
        if (poolsdk_file==nil||[poolsdk_file isEqualToString:@""]||![[FileUtils shareSDK]checkIsFile:poolsdk_file]) {
            _buttonTitle=@"下载";
        }else if(![[FileUtils shareSDK]checkIsFile:cpath]){
            _buttonTitle=@"更新";
            self.isupdate=true;
        }else{
            _buttonTitle=@"已下载";
        }
         _download.title=_buttonTitle;
        _download.bordered = YES;
        if ([fileUrl isEqualToString:@""]) {
            _download.hidden=YES;
        }
        [_download setBezelStyle:NSRoundedBezelStyle];
        [_download setTarget:self];
        [_download setAction:@selector(downloadClick:)];
        
        
        NSProgressIndicator *indicator = [[NSProgressIndicator alloc]initWithFrame:CGRectMake(10+num, 0, 130, 5)];
        indicator.style = NSProgressIndicatorBarStyle;

        //这种方式只是给背景rect添加了背景色。
        indicator.wantsLayer = NO;
        indicator.layer.backgroundColor = [NSColor cyanColor].CGColor;
        indicator.hidden=YES;

        indicator.controlSize = NSControlSizeRegular;
//        [indicator setUsesThreadedAnimation:YES];
        [indicator sizeToFit];
       
        
        
        [aView addSubview:imgView];
        
        [aView addSubview:name];
        [aView addSubview:version];
        [aView addSubview:_download];
        [aView addSubview:indicator];
        num=num +250;
        NSDictionary *downloadDicData=@{@"name":[data[row] objectForKey:@"name"],@"version":[_sdkVersionListArray[i] objectForKey:@"name"],@"zipPlugUri":fileUrl,@"id":_download,@"refresh":indicator,@"rmpath":poolsdk_file,@"cpath":cpath};
        [_downloadParamsArray addObject:downloadDicData];
    }
    
   
    return aView;
    
}
-(NSString*)getCurrentTimestamp{
    // 时间戳转时间
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString* timeStr = [[NSString alloc]initWithFormat:@"%.f",interval];
    return timeStr;
}
-(void)pasedata:(NSDictionary *)dic{
    NSEnumerator * enumeratorValue = [dic objectEnumerator];
    /*
     
     "sdkVersionList": [{ 需要
     "status": 2,
     "code": "V2_5_1", 需要
     "description": "",
     "zipPlugUri": "/static/upload/zip/2018/4/10/1523337055_itools.zip",  需要
     "createDate": "2016-03-02 13:37:25",
     "completeDate": "2016-03-02 13:37:25",
     "config_template": {
     "client": [{
     "key_name": "appScheme",
     "describe": "bundle id(com.mango.ios.fytx)",
     "name": "appScheme"
     }],
     "server": [{
     "key_name": "APP_ID",
     "describe": "APP_ID",
     "name": "APP_ID"
     }, {
     "key_name": "PUBLIC_KEY",
     "describe": "PUBLIC_KEY",
     "name": "PUBLIC_KEY"
     }]
     },
     "sdkId": 72,
     "help_url": null,
     "zipSdkUri": "",
     "id": 100,
     "name": "V3.0.2" 需要
     },
     
     */
    _sdkVersionListArray=[NSMutableArray array];
    for (NSObject *object in enumeratorValue) {
        
        
        NSString *code=[object valueForKey:@"code"];
        NSString *zipPlugUri=[object valueForKey:@"zipPlugUri"];
        NSString *name=[object valueForKey:@"name"];
        NSString *sdkId=[object valueForKey:@"sdkId"];
      
        NSDictionary *dataDic=@{@"name":name,@"code":code,@"zipPlugUri":zipPlugUri,@"sdkId":sdkId};
      [_sdkVersionListArray addObject:dataDic];
        
    }
}

-(void)downloadClick:(id)sender
{
     [[Youai_LOG shareSDK]printLog:sender];
    [[Youai_LOG shareSDK]printLog:@"点击了下载"];

    for (int i=0; i<_downloadParamsArray.count; i++) {
        NSDictionary *dic=_downloadParamsArray[i];
        NSButton *bt=[dic objectForKey:@"id"];
        NSString *url=[dic objectForKey:@"zipPlugUri"];
        NSString *name=[dic objectForKey:@"name"];
        NSString *version=[dic objectForKey:@"version"];
         NSString *rmpath=[dic objectForKey:@"rmpath"];
         NSString *cpath=[dic objectForKey:@"cpath"];
         NSProgressIndicator *refresh=[dic objectForKey:@"refresh"];
        if (bt==sender) {
           
            [[DownloadFileUtils shareSDK]setPath:name and:version];
            if (url==nil||[url isEqualToString:@""]) {
                
                 [[Youai_LOG shareSDK]printLog:@"后台没有上传"];
            }else{
                [self startDownFile:url and:refresh andName:name andversion:version andrmpath:rmpath andcpath:cpath];
            }
           
        }
    }

    
}
-(void)startDownFile:(NSString *)url and:(NSProgressIndicator *)ref andName:(NSString *)name andversion:(NSString *)version andrmpath:(NSString *)rmpath andcpath:(NSString *)cpath{
     weakObject(self);
    if (self.isupdate) {
        [[FileUtils shareSDK]removeFileOrDir:rmpath];
        self.isupdate=false;
    }
    if ([[FileUtils shareSDK]checkIsFile:cpath]) {
         [[DownloadFileUtils shareSDK]clearTask];
        return;
    }
     [[Youai_LOG shareSDK]printLog:@"url正在下载："];
    [[Youai_LOG shareSDK]printLog:url];

    [[Youai_LOG shareSDK]printLog:NSHomeDirectory()];
    [[DownloadFileUtils shareSDK]startDownLoad:url WithStartBlock:^(NSString *filePath, NSInteger hasLoadLength, NSInteger totalLength) {
        [[Youai_LOG shareSDK]printLog:@"开始下载文件路径为："];
        [[Youai_LOG shareSDK]printLog:filePath];
        self.sdkfilepath=filePath;
        self.downloadSDKManagerTitle.hidden=NO;

        
        
    } progressBlock:^(NSInteger hasLoadLength, NSInteger totalLength) {
        
        [[Youai_LOG shareSDK]printLog:@"正在下载："];

        [[Youai_LOG shareSDK]printLog:@"百分比为：" andmsg:[NSString stringWithFormat:@"已经下载  %.2f %%",(hasLoadLength/1.0  / totalLength * 100.0)]];

        weakself.self.downloadSDKManagerTitle.stringValue = [NSString stringWithFormat:@"已经下载  %.2f %%",(hasLoadLength/1.0  / totalLength * 100.0)];

    } didCompleteBlock:^(NSError *error) {
         [[Youai_LOG shareSDK]printLog:@"下载完成："];
        self.downloadSDKManagerTitle.hidden=YES;
        if (error!=nil) {
             [[Youai_LOG shareSDK]printLog:error];
        }
        NSString *poolsdk_file=[NSString stringWithFormat:@"%@%@/%@/%@",NSHomeDirectory(),@"/poolsdk_file",name,version];
        self.poolsdksdkpath=poolsdk_file;
        self.newpoolsdk_file=[NSString stringWithFormat:@"%@/%@",poolsdk_file,self.sdkfilepath];
          [[Youai_LOG shareSDK]printLog:poolsdk_file];
        
        if ([[FileUtils shareSDK] createDirectoryAtPath:poolsdk_file]) {
             [[Youai_LOG shareSDK]printLog:@"创建路径成功"];
            [[Youai_LOG shareSDK]printLog:[DownloadFileUtils shareSDK].filesdkpath];
            if ([[FileUtils shareSDK]checkIsFile:self.newpoolsdk_file]) {
                [[FileUtils shareSDK]removeFileOrDir:self.newpoolsdk_file];
            }
            BOOL ok=[[FileUtils shareSDK]moveFileOrDir:[DownloadFileUtils shareSDK].filesdkpath andto:self.newpoolsdk_file];
            if (ok) {
                BOOL uipok=[SSZipArchive unzipFileAtPath:self.newpoolsdk_file toDestination:poolsdk_file overwrite:YES password:nil error:nil];
                if (uipok) {
                     [[Youai_LOG shareSDK]printLog:@"解压成功"];
//                     [[FileUtils shareSDK]removeFileOrDir:self.newpoolsdk_file];
                }
            }
            [[FileUtils shareSDK]removeFileOrDir:[NSString stringWithFormat:@"/Users/me/Library/Caches/%@.txt",self.sdkfilepath]];
        }
        [[DownloadFileUtils shareSDK]clearTask];
        [[ViewUtils shareSDK]reloadData:self.tableview];
    }];
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
    _buttonTitle=@"下载";
    _tableview=tbview;
    _downloadParamsArray=[NSMutableArray array];
    [view setDocumentView:tbview];
//    view.pageScroll=YES;
    [view setDrawsBackground:NO];        //不画背景（背景默认画成白色）
    [view setHasVerticalScroller:YES];   //有垂直滚动条
    [view setHasHorizontalScroller:YES];   //有水平滚动条
    view.autohidesScrollers = NO;       //自动隐藏滚动条（滚动的时候出现）
    
}
-(void)setprogressIndicatorview:(NSTextField *)title{
    self.downloadSDKManagerTitle=title;
    self.downloadSDKManagerTitle.hidden=YES;
   
}
-(void)setData:(NSMutableArray *)data
{
    _sdkVersionSearchListArray=data;
}


@end
