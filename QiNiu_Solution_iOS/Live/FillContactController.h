//
//  FillContactController.h
//  QiNiu_Solution_iOS
//
//  Created by 郭茜 on 2022/8/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//联系方式填写vc
@interface FillContactController : UIViewController

@property(nonatomic,assign)BOOL isRegist;//是否有注册过七牛账号

@property (nonatomic, copy) void (^dismissBlock)(void);

@end

NS_ASSUME_NONNULL_END
