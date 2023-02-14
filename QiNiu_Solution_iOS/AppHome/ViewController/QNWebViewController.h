//
//  QNWebViewController.h
//  QiNiu_Solution_iOS
//
//  Created by 孙慕 on 2023/2/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNWebViewController : UIViewController

-(void)setJSCallback:(void (^)(NSURL *packagePage))callback;


@end

NS_ASSUME_NONNULL_END
