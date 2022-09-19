//
//  QGoodDetailController.h
//  QiNiu_Solution_iOS
//
//  Created by 郭茜 on 2022/8/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GoodsModel,QNLiveRoomInfo;

//商品详情页面
@interface QGoodDetailController : UIViewController

@property (nonatomic,strong) QNLiveRoomInfo *roomInfo;

- (instancetype)initWithGoodModel:(GoodsModel *)goodModel;

@end

NS_ASSUME_NONNULL_END
