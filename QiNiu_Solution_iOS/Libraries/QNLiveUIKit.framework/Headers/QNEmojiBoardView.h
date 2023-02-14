//
//  QNEmojiBoardView.h
//  ChatRoom
//
//  Created by 罗骏 on 2018/5/11.
//  Copyright © 2018年 罗骏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QNEmojiBoardView;

/**
 表情输入的回调
 */
@protocol QNEmojiViewDelegate <NSObject>
@optional

/**
 点击表情的回调
 
 @param emojiView 表情输入的View
 @param string    点击的表情对应的字符串编码
 */
- (void)didTouchEmojiView:(QNEmojiBoardView *)emojiView touchedEmoji:(NSString *)string;

/**
 点击发送按钮的回调

 */
- (void)didSendButtonEvent;

@end

@interface QNEmojiBoardView : UIView

/*!
 表情输入的回调
 */
@property(nonatomic, weak) id<QNEmojiViewDelegate> delegate;


@end
