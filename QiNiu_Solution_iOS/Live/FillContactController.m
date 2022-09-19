//
//  FillContactController.m
//  QiNiu_Solution_iOS
//
//  Created by 郭茜 on 2022/8/9.
//

#import "FillContactController.h"
#import "AlertViewController.h"
#import "MBProgressHUD+QNShow.h"
#import "QNCheckStringTool.h"

@interface FillContactController ()

@property (nonatomic,strong)UIButton *closeButton;

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *contactLabel;

@property (nonatomic,strong)UITextField *textField;

@property (nonatomic, strong) UIButton *submitButton;


@end

@implementation FillContactController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self titleLabel];
    [self closeButton];
    [self contactLabel];
    [self textField];
    [self submitButton];
}

- (void)back {
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}

- (void)submitClick {
    
    if (self.textField.text.length == 0) {
        [MBProgressHUD showText:@"您还未填写联系方式"];
        return;
    }
    
    if (![QNCheckStringTool validateEmail:self.textField.text] && ![QNCheckStringTool validateMobile:self.textField.text]) {
        [MBProgressHUD showText:@"请填写正确的手机号或邮箱"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"isQiniuUser"] = @(self.isRegist);
    params[@"userName"] = self.textField.text;
    [QNNetworkUtil postRequestWithAction:@"live/statistics" params:params success:^(NSDictionary *responseData) {
        
        [self.view removeFromSuperview];
        [self popAlert];

        } failure:^(NSError *error) {
        
        }];
}

- (void)popAlert {
    __weak typeof(self)weakSelf = self;
    [AlertViewController showConfirmAlertWithTitle:@"提交成功" content:@"我们将尽快联系您" actionTitle:@"确定" handler:^(UIAlertAction * _Nonnull action) {
        [self removeFromParentViewController];
        if (weakSelf.dismissBlock) {
            weakSelf.dismissBlock();
        }
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = @"联系方式";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.view addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(10);
            make.centerX.equalTo(self.view);
        }];
    }
    return _titleLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc]init];
        [_closeButton setImage:[UIImage imageNamed:@"close_gray"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_closeButton];
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.right.equalTo(self.view).offset(-20);
        }];
    }
    return _closeButton;
}



- (UILabel *)contactLabel {
    if (!_contactLabel) {
        _contactLabel = [[UILabel alloc]init];
        _contactLabel.textColor = [UIColor blackColor];
        _contactLabel.text = self.isRegist ? @"七牛云账号" : @"手机号";
        _contactLabel.textAlignment = NSTextAlignmentCenter;
        _contactLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:_contactLabel];
        [_contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(25);
            make.left.equalTo(self.view).offset(20);
        }];
    }
    return _contactLabel;
}

-(UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.placeholder = self.isRegist ? @"请输您的注册邮箱或手机号" : @"请输您的手机号";
        _textField.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contactLabel.mas_bottom).offset(15);
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.height.mas_equalTo(45);
        }];
    }
    return _textField;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [[UIButton alloc]init];
        _submitButton.backgroundColor = [UIColor colorWithHexString:@"007AFF"];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        _submitButton.layer.cornerRadius = 4;
        [self.view addSubview:_submitButton];
        [_submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.right.equalTo(self.view).offset(-15);
            make.top.equalTo(self.textField.mas_bottom).offset(20);
            make.height.mas_offset(40);
        }];
    }
    return _submitButton;
}

@end
