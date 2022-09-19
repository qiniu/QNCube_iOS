//
//  QLiveDataView.m
//  QiNiu_Solution_iOS
//
//  Created by 郭茜 on 2022/8/18.
//

#import "QLiveDataView.h"
#import "Qlabel.h"
#import "QLiveDataItemView.h"


@interface QLiveDataView ()

@property (nonatomic,strong)QLabel *liveDataLabel;

@property (nonatomic,strong)NSArray<QliveDataModel *> *modelArray;

@end

@implementation QliveDataModel

@end

@implementation QLiveDataView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:0.1];
        [self liveDataLabel];
    }
    return self;
}

//点击直播详情
- (void)liveDataDetailClick {
    if (self.clickDetailBlock) {
        self.clickDetailBlock();
    }
}

- (void)updateWithModelArray:(NSArray<QliveDataModel *> *)arrayModel {
    self.modelArray = [NSArray arrayWithArray:arrayModel];
    //数据N行3列显示
    NSInteger N ;
    if (self.modelArray.count % 3 == 0) {
        N = self.modelArray.count/3;
    } else if (self.modelArray.count % 3 == 1){
        N = (self.modelArray.count + 2 )/3;
    } else if (self.modelArray.count % 3 == 2){
        N = (self.modelArray.count + 1 )/3;
    } else {
        N = 1;
    }
    NSInteger x = -1;
    for(int i = 0; i<N; i++)
    {
        for(int j = 0; j<3; j++)
        {
            x = x + 1;
            CGFloat width = kScreenWidth / 3;
            CGFloat height = 60;
            CGRect frame = CGRectMake(j * width, i * height + 35, width, height);
            QLiveDataItemView *view = [[QLiveDataItemView alloc]initWithFrame:frame];
            if (x < self.modelArray.count) {
                [view updateWithDetail:self.modelArray[x].detailStr title:self.modelArray[x].titleStr];
            }
            [self addSubview:view];
        }
    }
}

- (QLabel *)liveDataLabel {
    if (!_liveDataLabel) {
        _liveDataLabel = [[QLabel alloc]init];
        _liveDataLabel.textColor = [UIColor whiteColor];
        _liveDataLabel.backgroundColor = [UIColor clearColor];
        _liveDataLabel.text = @"直播数据";
        _liveDataLabel.font = [UIFont systemFontOfSize:14];
        _liveDataLabel.textInsets = UIEdgeInsetsMake(10.f, 15.f, 10.f, 10.f);
        [self addSubview:_liveDataLabel];
        [_liveDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.height.mas_equalTo(50);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(liveDataDetailClick)];
        [_liveDataLabel addGestureRecognizer:tap];
        _liveDataLabel.userInteractionEnabled = YES;
        
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_icon"]];
        [_liveDataLabel addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.liveDataLabel);
            make.right.equalTo(self.liveDataLabel.mas_right).offset(-15);
        }];
    }
    return _liveDataLabel;
}



@end
