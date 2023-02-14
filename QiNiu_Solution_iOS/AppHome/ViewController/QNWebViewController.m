//
//  QNWebViewController.m
//  QiNiu_Solution_iOS
//
//  Created by 孙慕 on 2023/2/13.
//

#import "QNWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

#import <QNLiveKit/QNLiveKit.h>
#import <QNLiveUIKit/QNLiveUIKit.h>

#import "QGoodDetailController.h"

@interface QNWebViewController ()<WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate>

@property (nonatomic,strong)WKWebView *mWebView;
@property (nonatomic,strong)WKUserContentController *userContentController;

@end

@implementation QNWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
     
    // 为WKWebViewConfiguration设置偏好设置
    WKPreferences *preferences = [[WKPreferences alloc] init];
     // 允许native和js交互
    preferences.javaScriptEnabled = YES;
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;
     
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"routerNative"];
    configuration.userContentController = userContentController;
    self.userContentController = userContentController;

     // 初始化webview
     WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
     NSURL *url = [NSURL URLWithString:@"https://sol-introduce.qiniu.com/"];

     NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
     [webView loadRequest:request];
    
     webView.allowsBackForwardNavigationGestures = YES;
     [self.view addSubview:webView];
    
     self.mWebView = webView;
}


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.body isEqualToString:@"niucube://shopping/index"]) {// 低代码电商直播
       // 互动直播demo跳转：
        [self goToInteractiveLive];
    }
    if ([message.body isEqualToString:@"niucube://liveKit/index"]) {//
        [self goToEcommerceLive];
    }
}

- (void)goToInteractiveLive{
    __weak typeof(self)weakSelf = self;
    [QLive initWithToken:QN_Live_Token serverURL:@"https://live-api.qiniu.com" errorBack:^(NSError * _Nonnull error) {
        //如果token过期
        [weakSelf getLiveToken:^(NSString * _Nonnull token) {
            [QLive initWithToken:token serverURL:@"https://live-api.qiniu.com" errorBack:nil];
        }];
    }];
    [QLive setUser:Get_avatar nick:Get_Nickname extension:nil];
    [QLive setBeauty:YES];
    [[QLive getRooms] setRoomsListener:self];
    QLiveListController *vc = [QLiveListController new];
    
    //自己实现跳转观众页面
    vc.audienceJoinBlock = ^(QNLiveRoomInfo * _Nonnull roomInfo) {
        QNAudienceController *vc = [QNAudienceController new];
        vc.roomInfo = roomInfo;
        //跳转商品页
        [vc bottomMenuUseConfig:@[@1,@0,@1,@1]];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)goToEcommerceLive{
    __weak typeof(self)weakSelf = self;
    [QLive initWithToken:QN_Live_Token serverURL:@"https://live-api.qiniu.com" errorBack:^(NSError * _Nonnull error) {
        //如果token过期
        [weakSelf getLiveToken:^(NSString * _Nonnull token) {
            [QLive initWithToken:token serverURL:@"https://live-api.qiniu.com" errorBack:nil];
        }];
    }];
    [QLive setUser:Get_avatar nick:Get_Nickname extension:nil];
    [QLive setBeauty:YES];
    [[QLive getRooms] setRoomsListener:self];
    QLiveListController *vc = [QLiveListController new];
    
    //自己实现跳转观众页面
    vc.audienceJoinBlock = ^(QNLiveRoomInfo * _Nonnull roomInfo) {
        QNAudienceController *vc = [QNAudienceController new];
        vc.roomInfo = roomInfo;
        //跳转商品页
        vc.goodClickedBlock = ^(GoodsModel * _Nonnull itemModel) {
            QGoodDetailController *good = [[QGoodDetailController alloc]initWithGoodModel:itemModel];
            good.modalPresentationStyle = UIModalPresentationFullScreen;
            good.roomInfo = roomInfo;
            [self presentViewController:good animated:YES completion:nil];
        };
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dealloc{
    [self.userContentController removeScriptMessageHandlerForName:@"event"];
}

//获取liveToken
- (void)getLiveToken:(nullable void (^)(NSString * _Nonnull token))callBack {
    
    NSString *action = [NSString stringWithFormat:@"live/auth_token?userID=%@&deviceID=%@",Get_User_id,@"111"];
    [QNNetworkUtil getRequestWithAction:action params:nil success:^(NSDictionary *responseData) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:responseData[@"accessToken"] forKey:Live_Token];
        [defaults synchronize];
        
        callBack(responseData[@"accessToken"]);

        } failure:^(NSError *error) {
        
        }];
}

@end
