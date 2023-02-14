//
//  QGoodDetailController.m
//  QiNiu_Solution_iOS
//
//  Created by 郭茜 on 2022/8/3.
//

#import "QGoodDetailController.h"
#import <QNLiveKit/QNLiveKit.h>
#import <QNLiveUIKit/QNLiveUIKit.h>
#import "AlertViewController.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import "QDragView.h"

#define BlankWidth ([UIScreen mainScreen].bounds.size.width - 340)/3

@interface QGoodDetailController ()

//商品图
@property (nonatomic,strong)UIImageView *iconImageView;
//现价
@property (nonatomic,strong)UILabel *currentPriceLabel;
//标签
@property (nonatomic, strong)QTagList *tagList;
//商品名称
@property (nonatomic,strong)UILabel *titleLabel;
//提示
@property (nonatomic,strong)UILabel *hintLabel;
//购物车按钮
@property (nonatomic,strong)UIButton *shopBagButton;
//购买按钮
@property (nonatomic,strong)UIButton *buyButton;

@property (nonatomic,strong)GoodsModel *itemModel;

@property (nonatomic, strong)PLPlayer *player;

@property (nonatomic, strong)QDragView *dragView;


@end

@implementation QGoodDetailController

- (instancetype)initWithGoodModel:(GoodsModel *)goodModel {
    if (self = [super init]) {
        self.itemModel = goodModel;
    }
    return self;
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self iconImageView];
    [self currentPriceLabel];
    [self tagList];
    [self titleLabel];
    [self hintLabel];
    [self shopBagButton];
    [self buyButton];
    [self playWithUrl:self.roomInfo.rtmp_url];
}

- (void)hintAlertShow {
    [AlertViewController showConfirmAlertWithTitle:@"提醒" content:@"商品页面为您APP内自有页面， 此处仅展示流程。 您可以点击直播小窗，返回直播间。" actionTitle:@"知道了" handler:^(UIAlertAction * _Nonnull action) {
            
    }];
}

- (void)playWithUrl:(NSString *)url {
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    PLPlayFormat format = kPLPLAY_FORMAT_UnKnown;
    
    [option setOptionValue:@(format) forKey:PLPlayerOptionKeyVideoPreferFormat];
    [option setOptionValue:@(kPLLogNone) forKey:PLPlayerOptionKeyLogLevel];
    
    self.player = [PLPlayer playerWithURL:[NSURL URLWithString:url] option:option];
    [self.dragView addSubview:self.player.playerView ];
    self.player.playerView.frame = self.dragView.bounds;
    self.player.delegateQueue = dispatch_get_main_queue();
    [self.player play];
    
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(75, 10, 20, 20)];
    [back setImage:[UIImage imageNamed:@"icon_quit"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(endPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.player.playerView addSubview:back];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
    self.player.playerView.userInteractionEnabled = YES;
    [self.player.playerView addGestureRecognizer:tap];
}

- (void)endPlay {
    [self.player stop];
    [self.player.playerView  removeFromSuperview];
    [self.dragView removeFromSuperview];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.userInteractionEnabled = YES;
        [self.view addSubview:_iconImageView];
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:self.itemModel.thumbnail]];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(20);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(self.view.frame.size.width);
        }];
        
        UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(15, 15, 25, 25)];
        [back setImage:[UIImage imageNamed:@"detail_back"] forState:UIControlStateNormal];
        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [_iconImageView addSubview:back];
        
    }
    return _iconImageView;
}

- (UILabel *)currentPriceLabel {
    if (!_currentPriceLabel) {
        _currentPriceLabel = [[UILabel alloc]init];
        _currentPriceLabel.textColor = [UIColor colorWithHexString:@"EF4149"];
        _currentPriceLabel.text = self.itemModel.current_price;
        _currentPriceLabel.font = [UIFont systemFontOfSize:18];
        [self.view addSubview:_currentPriceLabel];
        [_currentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImageView.mas_bottom).offset(5);
            make.left.equalTo(self.view).offset(15);
        }];
    }
    return _currentPriceLabel;
}

- (QTagList *)tagList {
    if (!_tagList) {
        _tagList = [[QTagList alloc] init];
        _tagList.backgroundColor = [UIColor clearColor];
        CGSize size = [self.itemModel.current_price boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18.0]} context:nil].size;
        _tagList.frame = CGRectMake(size.width + 30, self.view.frame.size.width + 20, 250, 0);
        _tagList.tagBackgroundColor = [UIColor orangeColor];
        _tagList.tagColor = [UIColor whiteColor];
        _tagList.tagButtonMargin = 2;
        _tagList.tagMargin = 8;
        _tagList.tagSize = CGSizeMake(40, 0);
        _tagList.tagFont = [UIFont systemFontOfSize:10];
        [_tagList addTags:[self.itemModel.tags componentsSeparatedByString:@","]];
        [self.view addSubview:_tagList];
    }
    return _tagList;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = self.itemModel.title;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.view addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.currentPriceLabel);
            make.top.equalTo(self.currentPriceLabel.mas_bottom).offset(10);
            make.right.equalTo(self.view).offset(-15);
        }];
    }
    return _titleLabel;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc]init];
        _hintLabel.textColor = [UIColor grayColor];
        _hintLabel.text = @"此处将跳转到您自有的商品页面。\n当前页面为直播带货的流程闭环展示，仅供参考，不代表七牛云提供商城服务。你可以再次，体验直播小窗功能。";
        _hintLabel.font = [UIFont systemFontOfSize:12];
        _hintLabel.numberOfLines = 0;
        [self.view addSubview:_hintLabel];
        [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.right.equalTo(self.view).offset(-15);
        }];
    }
    return _hintLabel;
}

- (UIButton *)shopBagButton {
    if (!_shopBagButton) {
        _shopBagButton = [[UIButton alloc]initWithFrame:CGRectMake(BlankWidth, self.view.frame.size.height - 60, 170, 40)];
        [_shopBagButton setImage:[UIImage imageNamed:@"add_shop_bag"] forState:UIControlStateNormal];
        [_shopBagButton addTarget:self action:@selector(hintAlertShow) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_shopBagButton];
    }
    return _shopBagButton;
}

- (UIButton *)buyButton {
    if (!_buyButton) {
        _buyButton = [[UIButton alloc]init];
        [_buyButton setImage:[UIImage imageNamed:@"buy"] forState:UIControlStateNormal];
        [_buyButton addTarget:self action:@selector(hintAlertShow) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_buyButton];
        [_buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.shopBagButton);
            make.left.equalTo(self.shopBagButton.mas_right).offset(BlankWidth);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(170);
        }];
    }
    return _buyButton;
}

- (QDragView *)dragView {
    if (!_dragView) {
        _dragView = [[QDragView alloc]initWithFrame:CGRectMake(kScreenWidth - 120, kScreenHeight - 240, 100, 170)];
        [self.view addSubview:_dragView];
    }
    return _dragView;
}

@end
