//
//  QLiveDetailItemView.m
//  QiNiu_Solution_iOS
//
//  Created by 郭茜 on 2022/9/1.
//

#import "QLiveDetailItemView.h"

@interface QLiveDetailItemView ()

@property (nonatomic, strong)UILabel *detailLabel;

@property (nonatomic, strong)UILabel *titleLabel;

@end

@implementation QLiveDetailItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self titleLabel];
        [self detailLabel];
        
    }
    return self;
}

- (void)updateWithDetail:(NSString *)detail title:(NSString *)title {
    self.detailLabel.text = detail;
    self.titleLabel.text = title;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 40, kScreenWidth/3, 20)];
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 20, kScreenWidth/3, 20)];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
