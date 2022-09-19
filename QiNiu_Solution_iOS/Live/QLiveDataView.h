//
//  QLiveDataView.h
//  QiNiu_Solution_iOS
//
//  Created by 郭茜 on 2022/8/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QliveDataModel : NSObject

@property (nonatomic, copy) NSString *detailStr;

@property (nonatomic, copy) NSString *titleStr;
@end

@interface QLiveDataView : UIView

- (void)updateWithModelArray:(NSArray<QliveDataModel *> *)arrayModel;

@property (nonatomic, copy) void (^clickDetailBlock)(void);

@end

NS_ASSUME_NONNULL_END
