//
//  AppDelegate.m
//  SJH_OEM
//  Author PENGTAO
//  Created by me on 2018/7/25.
//  Copyright © 2018年 me. All rights reserved.
//
#import "Youai_LOG.h"
#import "paramesListView.h"
#import "interfaceConfig.h"
#import "HttpUtils.h"
#import "AppDelegate.h"
#import "ViewUtils.h"
#import "selectGameView.h"
#import "SDKManagerView.h"
#import "dbpzListview.h"
@interface AppDelegate ()<NSTabViewDelegate,NSTableViewDataSource,NSSearchFieldDelegate>
@property (weak) IBOutlet NSTextField *UserNameField;
@property (weak) IBOutlet NSTextField *PassWordField;
@property (weak) IBOutlet NSTextField *TStext;
@property (weak) IBOutlet NSButton *ischeck;
@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSWindow *selectGameWindow;
@property (weak) IBOutlet NSWindow *sdkpzWindow;
@property (weak) IBOutlet NSBox *selectGameBox;
@property (weak) IBOutlet NSBox *sdkpzBox;
@property (weak) IBOutlet NSTableView *gameTableview;
@property (weak) IBOutlet NSScrollView *gameScrollView;
@property (weak) IBOutlet NSTextField *selectGameTextTitle;
@property (weak) IBOutlet NSSearchField *selectGameSearch;

@property (weak) IBOutlet NSBox *sdkpzlistBox;
@property NSScrollView *sdkpzlistScrollView;
@property NSTableView *sdkpzlistTableView;
@property NSTableColumn *column;

@property (weak) IBOutlet NSBox *sdkpzParamsBox;
@property NSScrollView *sdkpzParamslistScrollView;
@property NSTableView *sdkpzParamslistTableView;
@property NSTableColumn *Paramscolumn;


@property (weak) IBOutlet NSWindow *dbpzWindow;
@property (weak) IBOutlet NSBox *dbpzBox;

@property (weak) IBOutlet NSTextField *SDKID;
@property (weak) IBOutlet NSTextField *SDK;
@property (weak) IBOutlet NSTextField *SDKVersion;

@property (weak) IBOutlet NSTextField *SDKVersionName;
@property (weak) IBOutlet NSTextField *SDKChannle;
@property (weak) IBOutlet NSTextField *packgese;

@property (weak) IBOutlet NSWindow *sdkDownloadWindow;
@property (weak) IBOutlet NSBox *sdkDownloadBox;
@property NSScrollView *sdkDownloadScrollView;
@property NSTableView *sdkDownloadTableView;
@property NSTableColumn *sdkDownloadcolumn;

@property (strong) NSMutableArray *dataArrays;
@property (strong) NSMutableArray *channledataArrays;
@property (strong) NSMutableArray *channledSearshDataArrays;
@property (strong) NSMutableArray *searchdataArrays;
@property (strong) NSMutableArray *SDKManagerSearchdataArrays;
@property (weak) IBOutlet NSTextField *downloadSDKManagerTitle;



@property (weak) IBOutlet NSTextField *ComputerUserName;
@property (weak) IBOutlet NSTextField *ipaDir;
@property (weak) IBOutlet NSTextField *ComputerUserPassword;
@property (weak) IBOutlet NSTextField *ipaPackages;
@property (weak) IBOutlet NSTextField *certificate;
@property (weak) IBOutlet NSTextField *certificatePassword;
@property (weak) IBOutlet NSTextField *gamePyPath;
@property (weak) IBOutlet NSTextField *MotherEngineeringPath;
@property (weak) IBOutlet NSButton *selectCertificatePath;
@property (weak) IBOutlet NSButton *selectIpaDirPath;
@property (weak) IBOutlet NSButton *selectGamePyPath;
@property (weak) IBOutlet NSButton *selectMotherEngineeringPath;
@property (weak) IBOutlet NSButton *ManualPacking;
@property (weak) IBOutlet NSButton *AutoPacking;
@property (weak) IBOutlet NSButton *StratPacking;
@property (weak) IBOutlet NSButton *Release;
@property (weak) IBOutlet NSButton *Debug;
@property (weak) IBOutlet NSTextField *projectTarget;

@property (weak) IBOutlet NSButton *typeApp_store;
@property (weak) IBOutlet NSButton *typeAd_hoc;
@property (weak) IBOutlet NSButton *typeEnterprise;
@property (weak) IBOutlet NSButton *typeDevelopment;
@property (weak) IBOutlet NSTextField *bundleID;
@property NSInteger isLandscape;
@property NSInteger selectedRowNum;
@property BOOL isSearch;
@property BOOL isretrun;;
@property BOOL isGameTableview;
@property BOOL issdkpzlistTableview;
@property (nonatomic, copy) NSString *descriptions;
@property (nonatomic, copy) NSString *payOrderUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *loginCheckUrl;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *payCheckUrl;
@property (nonatomic, copy) NSString *gameSimpleName;


@property (weak) IBOutlet NSButton *moreAutoPacking;
@end

@implementation AppDelegate
NSImageView *sdkimgView;
NSTextField *sdktextField;
NSTextField *sdktextField2;
-(void)initsdkpzView//参数配置界面
{
    [self initsdkpzTitleView];
    [self initsdkpzSDKListView];
    [self initsdkpzparamslistview];
}

-(void)initsdkpzparamslistview{//参数配置界面的SDK参数详情列表布局
    _sdkpzParamslistScrollView= [[NSScrollView alloc]initWithFrame:CGRectMake(6, 5, 524, 470)];
    _sdkpzParamslistTableView= [[NSTableView alloc]initWithFrame:CGRectMake(6, 5, 524, 470)];
    _Paramscolumn = [[NSTableColumn alloc]initWithIdentifier:@"item"];
    _Paramscolumn.width = 530;
    _Paramscolumn.minWidth = 530;
    _Paramscolumn.maxWidth = 530;
    _Paramscolumn.hidden=NO;
    _Paramscolumn.headerToolTip = @"提示";
    _Paramscolumn.title = @"数据";
    _Paramscolumn.editable = YES ;
    _Paramscolumn.sortDescriptorPrototype = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO];
    _Paramscolumn.resizingMask =NSTableColumnUserResizingMask;
    [_sdkpzParamslistTableView addTableColumn:_Paramscolumn];
    [_sdkpzParamslistScrollView.contentView addSubview:_sdkpzParamslistTableView];
    [_sdkpzParamsBox.contentView addSubview:_sdkpzParamslistScrollView];
    [_sdkpzBox.contentView addSubview:_sdkpzParamsBox];

    
    [[paramesListView shareSDK]setNSNotificationCenter:_sdkpzParamslistTableView];
    [[paramesListView shareSDK]tableViewUtils:_sdkpzParamslistTableView];
    [[paramesListView shareSDK]scrollViewUtils:_sdkpzParamslistScrollView andTableView:_sdkpzParamslistTableView];
    
}

-(void)initsdkpzSDKListView{//参数配置界面的SDK列表布局
    [[selectGameView shareSDK]initview:_SDKID sdk:_SDK sdkvison:_SDKVersion sdkvsionname:_SDKVersionName channel:_SDKChannle  packge:_packgese];
   _sdkpzlistScrollView= [[NSScrollView alloc]initWithFrame:CGRectMake(5, 7, 281, 495)];
    _sdkpzlistTableView= [[NSTableView alloc]initWithFrame:CGRectMake(5, 7, 281, 495)];
    
    _column = [[NSTableColumn alloc]initWithIdentifier:@"item"];
    _column.width = 281;
    _column.minWidth = 281;
    _column.maxWidth = 281;
    _column.hidden=NO;
    _column.headerToolTip = @"提示";
    _column.title = @"数据";
    _column.editable = NO ;
    _column.sortDescriptorPrototype = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO];
    _column.resizingMask =NSTableColumnUserResizingMask;
    [_sdkpzlistTableView addTableColumn:_column];
//    [_sdkpzlistBox.contentView addSubview:_sdkpzlistSearch];
    
    [_sdkpzlistScrollView.contentView addSubview:_sdkpzlistTableView];
    [_sdkpzlistBox.contentView addSubview:_sdkpzlistScrollView];
    [_sdkpzBox.contentView addSubview:_sdkpzlistBox];
     [[selectGameView shareSDK]setNSNotificationCenter:_sdkpzlistTableView];
    [[selectGameView shareSDK]tableViewUtils:_sdkpzlistTableView];
   
    [[selectGameView shareSDK]scrollViewUtils:_sdkpzlistScrollView andTableView:_sdkpzlistTableView];
   
    NSDictionary *data=nil;
    if (_isSearch) {
        data=_searchdataArrays[_selectedRowNum];
    }else{
        data=_dataArrays[_selectedRowNum];
    }
   NSString *netUrl=[NSString stringWithFormat:@"%@%@%@",gameSdkListUrl,[data objectForKey:@"ID"],@"&client_type=IOS"];
     NSLog(@"netUrl answer: %@", netUrl);
    if ([self downloadChannlelist:netUrl]) {
        
        [[Youai_LOG shareSDK]printLog:@"刷新数据"];
       
        [[selectGameView shareSDK]setData:_channledataArrays];
       
        
        
       [[Youai_LOG shareSDK]printLog:@"刷新数据"];
    }
     [[ViewUtils shareSDK]reloadData:_sdkpzlistTableView];
    
}
-(void)initsdkpzTitleView{//参数配置界面的头部布局
    sdkimgView = [[NSImageView alloc]initWithFrame:CGRectMake(870, 610, 110, 110)];
    NSDictionary *data=nil;
    if (_isSearch) {
        data=_searchdataArrays[_selectedRowNum];
    }else{
        data=_dataArrays[_selectedRowNum];
    }
    NSString *path=[NSString stringWithFormat:@"%@%@",enterprisePlatformRootUrl,[data objectForKey:@"icon"]];
    [[ViewUtils shareSDK]imageViewUtils:path andImg:sdkimgView];
   
    [_sdkpzBox.contentView addSubview:sdkimgView];
    
    sdktextField= [[NSTextField alloc] initWithFrame:CGRectMake(1000, 610, 150, 30)];
    [[ViewUtils shareSDK]textFieldUtils:[data objectForKey:@"name"] andTextFiled:sdktextField];
    
    [_sdkpzBox addSubview:sdktextField];
    
    sdktextField2= [[NSTextField alloc] initWithFrame:CGRectMake(1000, 690, 150, 30)];
    [[ViewUtils shareSDK]textFieldUtils:[data objectForKey:@"description"] andTextFiled:(NSTextField *)sdktextField2];
    
    [_sdkpzBox addSubview:sdktextField2];
    NSTextField *textField3 = [[NSTextField alloc] initWithFrame:CGRectMake(0, 600, 1128, 2)];
    
    [[ViewUtils shareSDK]drowLineUtils:textField3];
    [_sdkpzBox addSubview:textField3];
    [_sdkpzWindow.contentView addSubview:_sdkpzBox];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

 [Youai_LOG shareSDK].LOG_TAG=@"YES";
    [Youai_LOG shareSDK].SaveLog=NO;
    [[self window ]center];//居中显示
     [[self selectGameWindow ]center];//居中显示
    [[self sdkDownloadWindow]center];
    [[self sdkpzWindow]center];
     [[self dbpzWindow]center];
   [[self selectGameWindow]center];
    [[self selectGameWindow]orderOut:nil];//隐藏选择游戏界面，登陆成功后再显示
    [[self sdkDownloadWindow]orderOut:nil];
     [[self sdkpzWindow]orderOut:nil];//隐藏sdk配置界面
     [[self dbpzWindow]orderOut:nil];
}

-(IBAction)gotoSDKDownloadWindow:(id)sender{//跳转到SDK管理页面
    NSString *channleSDKListURL=[NSString stringWithFormat:@"%@%@",sdkListUrl,@"?ct=IOS"];
    
    BOOL ok=[[HttpUtils shareSDK]downLoadUtils:channleSDKListURL];
    if (ok) {
        _sdkDownloadScrollView= [[NSScrollView alloc]initWithFrame:CGRectMake(8, 5, 1112, 605)];
        _sdkDownloadTableView= [[NSTableView alloc]initWithFrame:CGRectMake(8, 5, 1112, 605)];
        _sdkDownloadcolumn = [[NSTableColumn alloc]initWithIdentifier:@"item"];
        _sdkDownloadcolumn.width = 10000;
        _sdkDownloadcolumn.minWidth = 1112;
        _sdkDownloadcolumn.maxWidth = 10000;
        _sdkDownloadcolumn.hidden=NO;
        _sdkDownloadcolumn.headerToolTip = @"提示";
        _sdkDownloadcolumn.title = @"数据";
        _sdkDownloadcolumn.editable = NO ;
        _sdkDownloadcolumn.sortDescriptorPrototype = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO];
        _sdkDownloadcolumn.resizingMask =NSTableColumnUserResizingMask;
        [_sdkDownloadTableView addTableColumn:_sdkDownloadcolumn];
      
        [_sdkDownloadScrollView.contentView addSubview:_sdkDownloadTableView];
        [_sdkDownloadBox.contentView addSubview:_sdkDownloadScrollView];
        
        [[SDKManagerView shareSDK]setNSNotificationCenter:_sdkDownloadTableView];
        [[SDKManagerView shareSDK]tableViewUtils:_sdkDownloadTableView];
        
        [[SDKManagerView shareSDK]scrollViewUtils:_sdkDownloadScrollView andTableView:_sdkDownloadTableView];

        [[SDKManagerView shareSDK]setprogressIndicatorview:_downloadSDKManagerTitle];
        [[ViewUtils shareSDK]reloadData:_sdkDownloadTableView];
        
        [[self sdkpzWindow]orderOut:nil];
        
        [[self sdkDownloadWindow]orderFront:nil];
    }
   
    
}
-(void)saveparamsViewinit{
    NSScrollView *scrollview=[[NSScrollView alloc]initWithFrame:CGRectMake(20, 153, 320, 500)];
    NSTableView *tableview=[[NSTableView alloc]initWithFrame:CGRectMake(20, 153, 320, 500)];
    NSTableColumn *column = [[NSTableColumn alloc]initWithIdentifier:@"item"];
    column.width = 320;
    column.minWidth = 320;
    column.maxWidth = 320;
    column.hidden=NO;
    column.headerToolTip = @"提示";
    column.title = @"数据";
    column.editable = YES ;
    column.sortDescriptorPrototype = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO];
    column.resizingMask =NSTableColumnNoResizing;
    
    [tableview addTableColumn:column];
    [scrollview addSubview:tableview];
    [_dbpzBox addSubview:scrollview];
    
    [[dbpzListview shareSDK]tableViewUtils:tableview];
    [[dbpzListview shareSDK]setNSNotificationCenter:tableview];
    [[dbpzListview shareSDK]scrollViewUtils:scrollview andTableView:tableview andWindow:_dbpzWindow];
    
    
}
-(IBAction)clearAllpz:(id)sender{
    
    [[dbpzListview shareSDK]clearAllpz];
    
}


-(IBAction)changeEditing:(id)sender{
   
     [[dbpzListview shareSDK]onEditing:sender];
    
}
-(IBAction)saveParamsClicks:(id)sender{
    [[dbpzListview shareSDK]onSaveClick:sender];
    
}
-(IBAction)saveparamsAndgotodbWindow:(id)sender{//点击确认按钮保存参数并且跳转到打包配置页面
    [[self sdkpzWindow]orderOut:nil];
     [[self dbpzWindow]orderFront:nil];
    [[Youai_LOG shareSDK]printLog:@"或渠道数据的大小为：" andmsg:[@([ViewUtils shareSDK].Array.count)stringValue]];
    [self saveparamsViewinit];
    [[dbpzListview shareSDK]initMoreAutoPackingView:_moreAutoPacking];
    [[dbpzListview shareSDK]initTypeSelectView:_typeApp_store and:_typeAd_hoc and:_typeEnterprise and:_typeDevelopment];
    [[dbpzListview shareSDK]initview:_ComputerUserName and:_ipaDir and:_ComputerUserPassword and:_ipaPackages and:_certificate and:_certificatePassword and:_gamePyPath and:_MotherEngineeringPath andProjectTarget:_projectTarget andDundleID:_bundleID];
 
    [[dbpzListview shareSDK]initButtonView:_selectCertificatePath and:_selectIpaDirPath and:_selectGamePyPath and:_selectMotherEngineeringPath and:_ManualPacking and:_AutoPacking and:_StratPacking and:_Debug and:_Release];
}

-(IBAction)retrunsdkpzwindow:(id)sender{//打包配置里返回sdk参数配置页面
     [[self dbpzWindow]orderOut:nil];
     [[self sdkpzWindow]orderFront:nil];
    [[dbpzListview shareSDK] clearData];
}

-(IBAction)gotoSDKPZWindow:(id)sender{
    [_sdkDownloadTableView removeFromSuperview];
    [[self sdkDownloadWindow]orderOut:nil];
    
    [[self sdkpzWindow]orderFront:nil];
}
-(IBAction)returnGameList:(id)sender{//返回游戏列表按钮

    [[ViewUtils shareSDK]clearData:sdkimgView and:sdktextField and:sdktextField2];
//    [_channledataArrays removeAllObjects];
//    [[selectGameView shareSDK]clearData];
     [_sdkpzlistTableView removeFromSuperview];
    [_sdkpzParamslistTableView removeFromSuperview];
//    [[ViewUtils shareSDK]reloadData:_sdkpzlistTableView];
   
     [[self sdkpzWindow]orderOut:nil];//隐藏sdk配置界面
    [[self selectGameWindow]orderFront:nil];
   
}
- (IBAction)searchAnswer:(id)sender {//游戏列表搜索按钮
    NSLog(@"search answer: %@", [sender stringValue]);
    if ([sender stringValue]==nil||[[sender stringValue] isEqualToString:@""]) {
        _isSearch=false;
    }else{
        _searchdataArrays=[NSMutableArray array];
        for (int i=0; i<self.dataArrays.count; i++) {
            NSDictionary *dic=_dataArrays[i];
            NSString *name=[dic objectForKey:@"name"];
            if ([name containsString:[sender stringValue]]) {
                [[Youai_LOG shareSDK]printLog:@"找到了"];
                _isSearch=true;
                [_searchdataArrays addObject:dic];
                
            }
        }
        
    }
    
    [[ViewUtils shareSDK]reloadData:_gameTableview];
    
}
- (IBAction)sdksearchAnswer:(id)sender {//渠道列表搜索按钮
    NSLog(@"sdksearchAnswer answer: %@", [sender stringValue]);
    if ([sender stringValue]==nil||[[sender stringValue] isEqualToString:@""]) {
//        [[selectGameView shareSDK]clearData];
        [[selectGameView shareSDK]setData:_channledataArrays];
        [[ViewUtils shareSDK]reloadData:_sdkpzlistTableView];
    }else{
      _channledSearshDataArrays=[NSMutableArray array];
        for (int i=0; i<_channledataArrays.count; i++) {
            NSDictionary *dic=_channledataArrays[i];
            NSString *name=[dic objectForKey:@"sdkName"];
            if ([name containsString:[sender stringValue]]) {
                [[Youai_LOG shareSDK]printLog:@"找到了"];
               
                [_channledSearshDataArrays addObject:dic];
                
            }
        }
        
//        [[selectGameView shareSDK]clearData];
        [[selectGameView shareSDK]setData:_channledSearshDataArrays];
        [[ViewUtils shareSDK]reloadData:_sdkpzlistTableView];
        
    }
    
   
    
}

-(IBAction)SDKManagerSearch:(id)sender{
    NSLog(@"sdksearchAnswer answer: %@", [sender stringValue]);
    if ([sender stringValue]==nil||[[sender stringValue] isEqualToString:@""]) {
        [SDKManagerView shareSDK].isSearch=false;
       
    }else{
        _SDKManagerSearchdataArrays=[NSMutableArray array];
       [SDKManagerView shareSDK].isSearch=true;
        for (int i=0; i<[HttpUtils shareSDK].dataDictionary.count; i++) {
             NSDictionary *dic=[HttpUtils shareSDK].dataDictionary[i];
            NSString *name=[dic objectForKey:@"name"];
            if ([name containsString:[sender stringValue]]) {
                [[Youai_LOG shareSDK]printLog:@"找到了"];
                
                [_SDKManagerSearchdataArrays addObject:dic];
                
            }
        }
        [[SDKManagerView shareSDK]setData:_SDKManagerSearchdataArrays];
       
        
    }
    
     [[ViewUtils shareSDK]reloadData:_sdkDownloadTableView];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
- (void)searchFieldDidStartSearching:(NSSearchField *)sender//没什么用
{
     [[Youai_LOG shareSDK] printLog:@"开始搜索"];
     [[Youai_LOG shareSDK] printLog:[_selectGameSearch stringValue]];
}

- (void)searchFieldDidEndSearching:(NSSearchField *)sender//没什么用
{
     [[Youai_LOG shareSDK] printLog:@"结束搜索"];
}
- (IBAction)actionLogin:(id)sender {//登陆按钮
    [[Youai_LOG shareSDK] printLog:@"点击了登陆接口"];
    NSNumber *ch=@(_ischeck.state) ;
    [[Youai_LOG shareSDK] printLog:[ch stringValue]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"username"];
    [[Youai_LOG shareSDK] printLog:_PassWordField.stringValue];
    if (!([_UserNameField.stringValue isEqualToString:@""]||_UserNameField.stringValue==nil)) {
        if (!([_PassWordField.stringValue isEqualToString:@""]||_PassWordField.stringValue==nil)) {
            _TStext.stringValue=@"";
            
            if (_ischeck.state) {
                [userDefaults setObject:_UserNameField.stringValue forKey:@"username"];
                [userDefaults synchronize];
            }else{
                [userDefaults setObject:@"" forKey:@"username"];
                [userDefaults synchronize];
            }
            name=[userDefaults objectForKey:@"username"];
            _UserNameField.stringValue=name;
            BOOL ok=[self loginCheck:gameListUrl];
            if (ok) {
                //跳转到下一页
                [[Youai_LOG shareSDK] printLog:@"登陆成功"];
                 [self initGameView];
                 [[self window] orderOut:nil];//隐藏登陆界面

                [[self selectGameWindow] orderFront:nil];//显示选择游戏界面
               
               
            }else{
                _TStext.stringValue=@"登陆失败，请检查账户信息或者网络";
            }
            
        }else{
            
            [[Youai_LOG shareSDK] printLog:@"密码不允许为空！请重新输入"];
            
            _TStext.stringValue=@"密码不允许为空！请重新输入";
        }
    }else{
        
        [[Youai_LOG shareSDK] printLog:@"用户名不允许为空！请重新输入"];
        
        _TStext.stringValue=@"用户名不允许为空！请重新输入";
    }
    
    [[Youai_LOG shareSDK] printLog:name];
    
    
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
    [view setDocumentView:tbview];
    [view setDrawsBackground:NO];        //不画背景（背景默认画成白色）
    [view setHasVerticalScroller:YES];   //有垂直滚动条
    //[view setHasHorizontalScroller:YES];   //有水平滚动条
    view.autohidesScrollers = YES;       //自动隐藏滚动条（滚动的时候出现）
}
-(void)initGameView{
    
    
    
    [_selectGameWindow.contentView addSubview:_selectGameBox];
   
    [_selectGameBox.contentView addSubview:_selectGameTextTitle];
    [_selectGameBox.contentView addSubview:_selectGameSearch];
    [self tableViewUtils:_gameTableview];

    [self scrollViewUtils:_gameScrollView andTableView:_gameTableview];
     [_selectGameBox.contentView addSubview:_gameScrollView];

    [self setNSNotificationCenter:_gameTableview];
    
    [[ViewUtils shareSDK]reloadData:_gameTableview];
}
-(void)setNSNotificationCenter:(NSTableView *)view{
    //监测tableview滚动
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(tableviewDidScroll:)
                                                name:NSViewBoundsDidChangeNotification
                                              object:[[view enclosingScrollView] contentView]];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
  
   
        if (_isSearch) {
            return _searchdataArrays.count;
        }else{
            return _dataArrays.count;
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
    
 
   
   
        NSDictionary *data=nil;
        if (_isSearch) {
            data=_searchdataArrays[row];
        }else{
            data=_dataArrays[row];
        }
        
        [ViewUtils shareSDK].gameparams=data;
        _isLandscape=[[data objectForKey:@"isLandscape"]intValue];
        _descriptions=[data objectForKey:@"description"];
        _payOrderUrl=[data objectForKey:@"payOrderUrl"];
        _name=[data objectForKey:@"name"];
        _loginCheckUrl=[data objectForKey:@"loginCheckUrl"];
        _icon=[data objectForKey:@"icon"];
        _ID=[data objectForKey:@"ID"];
        _payCheckUrl=[data objectForKey:@"payCheckUrl"];
        _gameSimpleName=[data objectForKey:@"gameSimpleName"];
        NSString *strIdt=[tableColumn identifier];
        NSTableCellView *aView = [tableView makeViewWithIdentifier:strIdt owner:self];
        if (!aView)
            aView = [[NSTableCellView alloc]initWithFrame:CGRectMake(0, 0, tableColumn.width, 150)];
        else
            for (NSView *view in aView.subviews)[view removeFromSuperview];
        //初始化NSImageView并设置它的大小
        NSImageView *imgView = [[NSImageView alloc]initWithFrame:CGRectMake(0, 10, 120, 120)];
        NSString *path=[NSString stringWithFormat:@"%@%@",enterprisePlatformRootUrl,_icon];
        
        [[ViewUtils shareSDK]imageViewUtils:path andImg:imgView];
        [aView addSubview:imgView];
        
        NSTextField *textField = [[NSTextField alloc] initWithFrame:CGRectMake(160, 100, 100, 40)];
        
        [[ViewUtils shareSDK]textFieldUtils:_name andTextFiled:textField];
        [aView addSubview:textField];
        
        
        NSTextField *textField2 = [[NSTextField alloc] initWithFrame:CGRectMake(160, 50, 100, 40)];
       
        if (_isLandscape==1) {
            
             [[ViewUtils shareSDK]textFieldUtils:@"横屏" andTextFiled:textField2];
        }else{
           
             [[ViewUtils shareSDK]textFieldUtils:@"竖屏" andTextFiled:textField2];
        }
        [aView addSubview:textField2];
        
        
        NSTextField *textField3 = [[NSTextField alloc] initWithFrame:CGRectMake(160, 10, 100, 40)];
        
         [[ViewUtils shareSDK]textFieldUtils:_descriptions andTextFiled:textField3];
        [aView addSubview:textField3];
        
        NSTextField *textField4 = [[NSTextField alloc] initWithFrame:CGRectMake(300, 130, 500, 20)];
        
        NSString *payOrderUrl=[NSString stringWithFormat:@"%@%@",@"payOrderUrl -->  ",_payOrderUrl];
        
         [[ViewUtils shareSDK]textFieldUtils:payOrderUrl andTextFiled:textField4];
        [aView addSubview:textField4];
        
        NSTextField *textField5 = [[NSTextField alloc] initWithFrame:CGRectMake(300, 100, 500, 20)];
        NSString *loginCheckUrl=[NSString stringWithFormat:@"%@%@",@"loginCheckUrl -->  ",_loginCheckUrl];
    
         [[ViewUtils shareSDK]textFieldUtils:loginCheckUrl andTextFiled:textField5];
        [aView addSubview:textField5];
        
        NSTextField *textField6 = [[NSTextField alloc] initWithFrame:CGRectMake(300, 70, 500, 20)];
        NSString *payCheckUrl=[NSString stringWithFormat:@"%@%@",@"payCheckUrl -->  ",_payCheckUrl];
        
        [[ViewUtils shareSDK]textFieldUtils:payCheckUrl andTextFiled:textField6];
        [aView addSubview:textField6];
        
        NSTextField *textField7 = [[NSTextField alloc] initWithFrame:CGRectMake(300, 40, 500, 20)];
        NSString *gameID=[NSString stringWithFormat:@"%@%@",@"游戏ID -->  ",_ID];
       
         [[ViewUtils shareSDK]textFieldUtils:gameID andTextFiled:textField7];
        [aView addSubview:textField7];
        
        NSTextField *textField8 = [[NSTextField alloc] initWithFrame:CGRectMake(300, 10, 500, 20)];
        NSString *gameSimpleName=[NSString stringWithFormat:@"%@%@",@"gameSimpleName -->  ",_gameSimpleName];
        
         [[ViewUtils shareSDK]textFieldUtils:gameSimpleName andTextFiled:textField8];
        [aView addSubview:textField8];
        
        NSTextField *textField9 = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, 2)];
        
        [[ViewUtils shareSDK]drowLineUtils:textField9];
        [aView addSubview:textField9];
        
        return aView;
    
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
   
    
        _selectedRowNum = row;
        [[Youai_LOG shareSDK]printLog:@"选中了" andmsg:[@(_selectedRowNum)stringValue]];
        return YES;
   
    
}
- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn{
    
        [[Youai_LOG shareSDK]printLog:@"点击了" andmsg:tableColumn.dataCell];
 

}

// 选中的响应
-(void)tableViewSelectionDidChange:(nonnull NSNotification* )notification{
  
        _gameTableview= notification.object;
        //do something
        NSLog(@"选中了kkkk-----%ld", (long)_gameTableview.selectedRow);
    
        
        [[self selectGameWindow]orderOut:nil];//隐藏选择游戏界面，登陆成功后再显示
        
        [[self sdkpzWindow]orderFront:nil];//显示sdk配置界面
        
        [self initsdkpzView];

    
    
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
   
        NSClipView *contentView = [notification object];
       
        //    CGFloat scrollY = contentView.visibleRect.origin.y-20;//这里减去20是因为tableHeader的20高度
        //    _scrollTF.stringValue = [NSString stringWithFormat:@"滚动 %.1f",scrollY];
    
   
}


-(NSString*)getCurrentTimestamp{
    // 时间戳转时间
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString* timeStr = [[NSString alloc]initWithFormat:@"%.f",interval];
    return timeStr;
}
-(BOOL)downloadChannlelist:(NSString *)url{
    NSString *received=[[HttpUtils shareSDK] httpGetSyn:url];
     [[Youai_LOG shareSDK]printLog:@"channlelist：" andmsg:received];
    
    /*
     
     
     {
     "channelParameter2": "",
     "sdkName": "久久游iOS",
     "writeToManifest": 0,
     "parameters": "{\"appScheme\": \"com.sxch.jjyx\", \"appId\": \"sxcios\"}",
     "sdkVersionName": "2.6.6",
     "packageName": "com.sxch.jjyx",
     "gameName": "风云接入测试",
     "gameVersionId": 11,
     "channelSimpleName": "",
     "custom": "{}",
     "userType": 226,
     "channelParameter1": "",
     "client_type": "IOS",
     "sdkVersionCode": "V2_6_6",
     "itemConfig": "{}",
     "sdkId": 226,
     "shareSdkAppKey": "",
     "sdkSimpleName": "jiujiuyou_ios",
     "gameSimpleName": "fytx_test"
     }
     
     */
    NSDictionary *data=[self dictionaryWithJsonString:received];
    //得到词典中所有Value值
    
    NSEnumerator * enumeratorValue = [data objectEnumerator];
    //    consts=data.count;
    //快速枚举遍历所有Value的值
    _channledataArrays=[NSMutableArray array];
//     [_channledataArrays removeAllObjects];
//    [_channledataArrays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//    }];
    for (NSObject *object in enumeratorValue) {
        
         [[Youai_LOG shareSDK]printLog:@"/////////////////////////////"];
        NSString *sdkName=[[ViewUtils shareSDK]cheackNullData:[object valueForKey:@"sdkName"]];
        [[Youai_LOG shareSDK]printLog:@"sdkName=" andmsg:sdkName];
        NSString *sdkVersionName=[[ViewUtils shareSDK]cheackNullData:[object valueForKey:@"sdkVersionName"]];
        [[Youai_LOG shareSDK]printLog:@"sdkVersionName=" andmsg:sdkVersionName];
        NSString *packageName=[[ViewUtils shareSDK]cheackNullData:[object valueForKey:@"packageName"]];
        [[Youai_LOG shareSDK]printLog:@"packageName=" andmsg:packageName];
        NSString *channelSimpleName=[[ViewUtils shareSDK]cheackNullData:[object valueForKey:@"channelSimpleName"]];
           [[Youai_LOG shareSDK]printLog:@"channelSimpleName=" andmsg:channelSimpleName];
        NSString *sdkVersionCode=[[ViewUtils shareSDK]cheackNullData:[object valueForKey:@"sdkVersionCode"]];
          [[Youai_LOG shareSDK]printLog:@"sdkVersionCode=" andmsg:sdkVersionCode];
        int  sdkId=[[object valueForKey:@"sdkId"]intValue];
        NSString *sdkId2=[[ViewUtils shareSDK]cheackNullData:[@(sdkId)stringValue]];
          [[Youai_LOG shareSDK]printLog:@"sdkId2=" andmsg:sdkId2];
        NSString *sdkSimpleName=[[ViewUtils shareSDK]cheackNullData:[object valueForKey:@"sdkSimpleName"]];
          [[Youai_LOG shareSDK]printLog:@"sdkSimpleName=" andmsg:sdkSimpleName];
         NSString *channelParameter2=[[ViewUtils shareSDK]cheackNullData:[object valueForKey:@"channelParameter2"]];
         [[Youai_LOG shareSDK]printLog:@"channelParameter2=" andmsg:channelParameter2];
         int writeToManifest=[[object valueForKey:@"writeToManifest"]intValue];
        NSString *writeToManifest2=[[ViewUtils shareSDK]cheackNullData:[@(writeToManifest)stringValue]];
         [[Youai_LOG shareSDK]printLog:@"writeToManifest2=" andmsg:writeToManifest2];
         NSString *parameters=[[ViewUtils shareSDK]cheackNullData:[object valueForKey:@"parameters"]];
         [[Youai_LOG shareSDK]printLog:@"parameters=" andmsg:parameters];
         NSString *gameName=[[ViewUtils shareSDK]cheackNullData:[object valueForKey:@"gameName"]];
         [[Youai_LOG shareSDK]printLog:@"gameName=" andmsg:gameName];
         int gameVersionId=[[object valueForKey:@"gameVersionId"]intValue];
        NSString *gameVersionId2=[[ViewUtils shareSDK]cheackNullData:[@(gameVersionId) stringValue]];
        [[Youai_LOG shareSDK]printLog:@"gameVersionId2=" andmsg:gameVersionId2];
         NSString *custom=[[ViewUtils shareSDK]cheackNullData:[object valueForKey:@"custom"]];
          [[Youai_LOG shareSDK]printLog:@"custom=" andmsg:custom];
        NSString *channelParameter1=[[ViewUtils shareSDK]cheackNullData:[object valueForKey:@"channelParameter1"]];
         [[Youai_LOG shareSDK]printLog:@"channelParameter1=" andmsg:channelParameter1];
        NSString *client_type=[[ViewUtils shareSDK]cheackNullData:[object valueForKey:@"client_type"]];
         [[Youai_LOG shareSDK]printLog:@"client_type=" andmsg:client_type];
        int  userType=[[object valueForKey:@"userType"]intValue];
        NSString *userType2=[[ViewUtils shareSDK]cheackNullData:[@(userType)stringValue]];
          [[Youai_LOG shareSDK]printLog:@"userType2=" andmsg:userType2];
        NSString *itemConfig=[[ViewUtils shareSDK]cheackNullData:[object valueForKey:@"itemConfig"]];
          [[Youai_LOG shareSDK]printLog:@"itemConfig=" andmsg:itemConfig];
        NSString *shareSdkAppKey=[[ViewUtils shareSDK]cheackNullData:[object valueForKey:@"shareSdkAppKey"]];
        [[Youai_LOG shareSDK]printLog:@"shareSdkAppKey=" andmsg:shareSdkAppKey];
        NSString *gameSimpleName=[[ViewUtils shareSDK]cheackNullData:[object valueForKey:@"gameSimpleName"]];
        [[Youai_LOG shareSDK]printLog:@"gameSimpleName=" andmsg:gameSimpleName];
         [[Youai_LOG shareSDK]printLog:@"/////////////////////////////"];
       
        
        NSDictionary *dataDic=@{@"sdkName":sdkName,@"sdkVersionName":sdkVersionName,@"packageName":packageName
                                ,@"channelSimpleName":channelSimpleName,@"sdkVersionCode":sdkVersionCode,@"sdkId":sdkId2
                                ,@"sdkSimpleName":sdkSimpleName,@"channelParameter2":channelParameter2,@"writeToManifest":writeToManifest2
                                ,@"parameters":parameters,@"gameName":gameName,@"gameVersionId":gameVersionId2,@"custom":custom
                                ,@"channelParameter1":channelParameter1,@"client_type":client_type,@"userType":userType2
                                ,@"itemConfig":itemConfig,@"shareSdkAppKey":shareSdkAppKey,@"gameSimpleName":gameSimpleName
                                };
        [_channledataArrays addObject:dataDic];
        
    }
    NSInteger con= _channledataArrays.count;
    
    [[Youai_LOG shareSDK]printLog:@"总数=" andmsg:[@(con)stringValue]];
   
    return YES;
    
}
-(BOOL)loginCheck:(NSString *)url{
    
    NSString *netUrl=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",url,@"?u=",_UserNameField.stringValue,@"&p=",_PassWordField.stringValue,@"&t=",[self getCurrentTimestamp]];
    [[Youai_LOG shareSDK]printLog:@"登陆请求地址：" andmsg:netUrl];
    
    NSString *received=[[HttpUtils shareSDK] httpGetSyn:netUrl];
    NSInteger len= received.length;
    [[Youai_LOG shareSDK] printLog:[@(len)stringValue]];
    if (received==nil||[received isEqualToString:@""]||len<3) {
        return NO;
    }else{
        
        
        
        return [self paseJson:received];;
    }
    
}
NSInteger *consts;
-(BOOL)paseJson:(NSString *)str{
    
    NSDictionary *data=[self dictionaryWithJsonString:str];
    
    //得到词典中所有Value值
    
    NSEnumerator * enumeratorValue = [data objectEnumerator];
//    consts=data.count;
    //快速枚举遍历所有Value的值
    _dataArrays=[NSMutableArray array];
    for (NSObject *object in enumeratorValue) {
        
        
        NSString *name=[object valueForKey:@"name"];
        NSString *isLandscape=[object valueForKey:@"isLandscape"];
        NSString *description=[object valueForKey:@"description"];
        NSString *payOrderUrl=[object valueForKey:@"payOrderUrl"];
        NSString *loginCheckUrl=[object valueForKey:@"loginCheckUrl"];
        NSString *icon=[object valueForKey:@"icon"];
        NSString *ID=[object valueForKey:@"id"];
        NSString *payCheckUrl=[object valueForKey:@"payCheckUrl"];
        NSString *gameSimpleName=[object valueForKey:@"gameSimpleName"];

        NSDictionary *dataDic=@{@"name":name,@"isLandscape":isLandscape,@"description":description,@"payOrderUrl":payOrderUrl,@"loginCheckUrl":loginCheckUrl,@"icon":icon,@"ID":ID,@"payCheckUrl":payCheckUrl,@"gameSimpleName":gameSimpleName};
        [self.dataArrays addObject:dataDic];

    }
    NSInteger con= self.dataArrays.count;
    
    [[Youai_LOG shareSDK]printLog:@"总数=" andmsg:[@(con)stringValue]];
    return YES;
    
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
