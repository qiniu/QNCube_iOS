//
//  QFeedbackViewController.m
//  QiNiu_Solution_iOS
//
//  Created by 郭茜 on 2022/8/8.
//

#import "QFeedbackViewController.h"
#import "QLabel.h"
#import "FillContactController.h"
#import "QLiveDataView.h"
#import <QNLiveKit/QNLiveKit.h>
#import <QNLiveKit/QGradient.h>
#import "QLiveDataDetailController.h"
#import "NSDate+QNCategory.h"


@interface QFeedbackViewController ()

@property (nonatomic,strong)UIImageView *bgImageView;

@property (nonatomic,strong)UIImageView *iconImageView;

@property (nonatomic,strong)UILabel *endLabel;

@property (nonatomic,strong)UILabel *nickNameLabel;

@property (nonatomic,strong)UILabel *userIDLabel;

@property (nonatomic,strong)QLiveDataView *liveDataView;

@property (nonatomic,strong)QLabel *detailLabel;

@property (nonatomic,strong)QLabel *noRegistLabel;

@property (nonatomic,strong)QLabel *registLabel;

@property (nonatomic,strong)NSArray<QliveDataModel *> *dataArray;

@end

@implementation QFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self bgImageView];
    [self iconImageView];
    [self endLabel];
    [self nickNameLabel];
    [self userIDLabel];
    [self liveDataView];
    [self detailLabel];
    [self registLabel];
    [self noRegistLabel];
    
    [self requestData];
    
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 45, 35, 25, 25)];
    [back setImage:[UIImage imageNamed:@"icon_quit"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    

}

//请求统计信息
- (void)requestData {
    QStatisticalService *statisticalService = [[QStatisticalService alloc]init];
    statisticalService.roomInfo = [QLive createPusherClient].roomInfo;
    [statisticalService getRoomData:^(NSArray<QRoomDataModel *> * _Nonnull model) {
        
        __block NSMutableArray *array = [NSMutableArray array];
        
        [model enumerateObjectsUsingBlock:^(QRoomDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            QliveDataModel *model = [QliveDataModel new];
            model.detailStr = obj.page_view.stringValue;
            model.titleStr = [self dataTitleStr:obj.type];
            [array addObject:model];
        }];
        
        QliveDataModel *model1 = [QliveDataModel new];
        model1.detailStr = [NSDate compareTwoTime:[self.roomInfo.start_time doubleValue] time2:[[NSDate getNowTimeTimestamp] doubleValue]];
        model1.titleStr = @"直播时长";
        [array addObject:model1];
        
//        QliveDataModel *model2 = [QliveDataModel new];
//        model2.detailStr = @"00:00:17";
//        model2.titleStr = @"平均观看";
//        [array addObject:model2];
        
        self.dataArray = [NSArray arrayWithArray:array];
        [self.liveDataView updateWithModelArray:array];
        }];
}

- (NSString *)dataTitleStr:(QRoomDataType)type {
    switch (type) {
        case QRoomDataTypeWatch:
            return @"浏览次数";
            break;
        case QRoomDataTypeGoodClick:
            return @"商品点击次数";
            break;
        case QRoomDataTypeComment:
            return @"聊天互动";
            break;
        
        default:
            break;
    }
    return @"";
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)noRegistClick {
    [self popFillContactVcWithIsRegist:NO];
}

- (void)registClick {
    [self popFillContactVcWithIsRegist:YES];
}

- (void)popFillContactVcWithIsRegist:(BOOL)isRegist {
    FillContactController *vc = [[FillContactController alloc]init];
    vc.isRegist = isRegist;
    __weak typeof(self)weakSelf = self;
    vc.dismissBlock = ^{
        [weakSelf back];
    };
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(250);
    }];
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.backgroundColor = [UIColor blackColor];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
        [self.view addSubview:_bgImageView];
        [_bgImageView sd_setImageWithURL:[NSURL URLWithString:Get_avatar] placeholderImage:[UIImage imageNamed:@"titleImage"]];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.mas_equalTo(300);
        }];
        
        //遮罩层
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
        [_bgImageView addSubview:view];
        [QGradient setTopToBottomGradientColor:[UIColor blackColor] view:view];
        
    }
    return _bgImageView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        [self.bgImageView addSubview:_iconImageView];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = 40;
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:Get_avatar] placeholderImage:[UIImage imageNamed:@"titleImage"]];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.bgImageView);
            make.width.height.mas_equalTo(80);
        }];
    }
    return _iconImageView;
}

- (UILabel *)endLabel {
    if (!_endLabel) {
        _endLabel = [[UILabel alloc]init];
        _endLabel.textColor = [UIColor whiteColor];
        _endLabel.text = @"直播已结束";
        _endLabel.textAlignment = NSTextAlignmentCenter;
        _endLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.bgImageView addSubview:_endLabel];
        [_endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.iconImageView.mas_top).offset(-30);
            make.centerX.equalTo(self.iconImageView);
        }];
    }
    return _endLabel;
}

- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc]init];
        _nickNameLabel.textColor = [UIColor whiteColor];
        _nickNameLabel.text = Get_Nickname;
        _nickNameLabel.textAlignment = NSTextAlignmentCenter;
        _nickNameLabel.font = [UIFont systemFontOfSize:14];
        [self.bgImageView addSubview:_nickNameLabel];
        [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImageView.mas_bottom).offset(5);
            make.centerX.equalTo(self.iconImageView);
        }];
    }
    return _nickNameLabel;
}

- (UILabel *)userIDLabel {
    if (!_userIDLabel) {
        _userIDLabel = [[UILabel alloc]init];
        _userIDLabel.textColor = [UIColor whiteColor];
        _userIDLabel.text = Get_User_id;
        _userIDLabel.textAlignment = NSTextAlignmentCenter;
        _userIDLabel.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:_userIDLabel];
        [_userIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nickNameLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self.iconImageView);
        }];
    }
    return _userIDLabel;
}

- (QLiveDataView *)liveDataView {
    if (!_liveDataView) {
        _liveDataView = [[QLiveDataView alloc]initWithFrame:CGRectMake(10, 310, kScreenWidth - 20, 180)];
        __weak typeof(self)weakSelf = self;
        _liveDataView.clickDetailBlock = ^{
            QLiveDataDetailController *vc = [QLiveDataDetailController new];
            vc.dataArray = weakSelf.dataArray;
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf presentViewController:vc animated:YES completion:nil];
        };
        [self.view addSubview:_liveDataView];
    }
    return _liveDataView;
}

- (QLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[QLabel alloc]init];
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.backgroundColor = [[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:0.1];
        _detailLabel.text = @"感谢您使用七牛云互动直播（低代码）。\n如需我们提供技术支持，或需了解更多的产品信息，请留下您的联系方式。";
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.numberOfLines = 0;
        _detailLabel.textInsets = UIEdgeInsetsMake(10.f, 15.f, 10.f, 15.f);
        [self.view addSubview:_detailLabel];
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.liveDataView.mas_bottom).offset(10);
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.height.mas_equalTo(80);
        }];
    }
    return _detailLabel;
}

- (QLabel *)registLabel {
    if (!_registLabel) {
        _registLabel = [[QLabel alloc]init];
        _registLabel.textColor = [UIColor whiteColor];
        _registLabel.backgroundColor = [[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:0.1];
        _registLabel.text = @"已注册七牛云";
        _registLabel.font = [UIFont systemFontOfSize:14];
        _registLabel.textInsets = UIEdgeInsetsMake(10.f, 15.f, 10.f, 10.f);
        [self.view addSubview:_registLabel];
        [_registLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.detailLabel.mas_bottom).offset(10);
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.height.mas_equalTo(50);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(registClick)];
        [_registLabel addGestureRecognizer:tap];
        _registLabel.userInteractionEnabled = YES;
        
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_icon"]];
        [_registLabel addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.registLabel);
            make.right.equalTo(self.registLabel.mas_right).offset(-15);
        }];
    }
    return _registLabel;
}

- (QLabel *)noRegistLabel {
    if (!_noRegistLabel) {
        _noRegistLabel = [[QLabel alloc]init];
        _noRegistLabel.textColor = [UIColor whiteColor];
        _noRegistLabel.backgroundColor = [[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:0.1];
        _noRegistLabel.text = @"未注册七牛云";
        _noRegistLabel.font = [UIFont systemFontOfSize:14];
        _noRegistLabel.textInsets = UIEdgeInsetsMake(10.f, 15.f, 10.f, 10.f);
        [self.view addSubview:_noRegistLabel];
        [_noRegistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.registLabel.mas_bottom).offset(10);
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.height.mas_equalTo(50);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noRegistClick)];
        [_noRegistLabel addGestureRecognizer:tap];
        _noRegistLabel.userInteractionEnabled = YES;
        
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_icon"]];
        [_noRegistLabel addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.noRegistLabel);
            make.right.equalTo(self.noRegistLabel.mas_right).offset(-15);
        }];
    }
    return _noRegistLabel;
}


@end
