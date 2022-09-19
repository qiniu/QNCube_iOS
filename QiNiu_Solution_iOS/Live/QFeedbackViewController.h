//
//  QFeedbackViewController.h
//  QiNiu_Solution_iOS
//
//  Created by 郭茜 on 2022/8/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QNLiveRoomInfo;

//信息收集页
@interface QFeedbackViewController : UIViewController

@property (nonatomic, strong) QNLiveRoomInfo *roomInfo;


@end

NS_ASSUME_NONNULL_END
