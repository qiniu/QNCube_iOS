//
//  QLiveDataDetailController.h
//  QiNiu_Solution_iOS
//
//  Created by 郭茜 on 2022/9/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QliveDataModel;

@interface QLiveDataDetailController : UIViewController

@property (nonatomic,strong)NSArray<QliveDataModel *> *dataArray;

@end

NS_ASSUME_NONNULL_END
