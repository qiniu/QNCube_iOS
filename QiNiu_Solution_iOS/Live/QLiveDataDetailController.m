//
//  QLiveDataDetailController.m
//  QiNiu_Solution_iOS
//
//  Created by 郭茜 on 2022/9/1.
//

#import "QLiveDataDetailController.h"
#import "QLiveDetailItemView.h"
#import "QLiveDataView.h"
@interface QLiveDataDetailController ()

@end

@implementation QLiveDataDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self backButton];
    [self titleLabel];
    [self secondTitleLabel];
    [self detailViewWithModelArray:self.dataArray];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)titleLabel {
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.text = @"详细数据";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(35);
        make.centerX.equalTo(self.view);
    }];
}

- (void)secondTitleLabel {
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.text = @"某某直播间";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(95);
        make.centerX.equalTo(self.view);
    }];
}

- (void)detailViewWithModelArray:(NSArray<QliveDataModel *> *)arrayModel {
    //数据N行2列显示
    NSInteger N ;
    if (self.dataArray.count % 2 == 0) {
        N = self.dataArray.count/2;
    } else if (self.dataArray.count % 2 == 1){
        N = (self.dataArray.count + 1 )/2;
    } else {
        N = 1;
    }
    
    NSInteger x = -1;
    for(int i = 0; i<N; i++)
    {
        for(int j = 0; j<2; j++)
        {
            if (x == self.dataArray.count) {
                return;
            }
            x = x + 1;
            CGFloat width = kScreenWidth / 2;
            CGFloat height = 70;
            CGRect frame = CGRectMake(j * width, i * height + 135, width, height);
            QLiveDetailItemView *view = [[QLiveDetailItemView alloc]initWithFrame:frame];
            if (x < self.dataArray.count) {
                [view updateWithDetail:self.dataArray[x].detailStr title:self.dataArray[x].titleStr];
            }
            [self.view addSubview:view];
        }
    }
}
- (void)backButton {
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(20, 35, 25, 25)];
    [back setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
}


@end
