//
//  QLabel.m
//  QiNiu_Solution_iOS
//
//  Created by 郭茜 on 2022/8/9.
//

#import "QLabel.h"

@implementation QLabel

- (instancetype)init {

if (self = [super init]) {

    _textInsets = UIEdgeInsetsZero;

}

return self;

}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {

        _textInsets = UIEdgeInsetsZero;

    }

return self;

}

- (void)drawTextInRect:(CGRect)rect {

    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];

}


@end
