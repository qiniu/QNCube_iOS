//
//  QNCheckStringTool.h
//  QiNiu_Solution_iOS
//
//  Created by 郭茜 on 2022/8/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNCheckStringTool : NSObject

//邮箱
+ (BOOL) validateEmail:(NSString *)email;
//电话
+ (BOOL)validateMobile:(NSString *)phone;
//车牌号
+ (BOOL) validateCarNo:(NSString *)carNo;
//车的型号
+ (BOOL) validateCarType:(NSString *)CarType;
//用户名
+ (BOOL) validateUserName:(NSString *)name;
//密码
+ (BOOL) validatePassword:(NSString *)passWord;
//昵称
+ (BOOL) validateNickname:(NSString *)nickname;
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
//判断是否有特殊符号
- (BOOL)effectivePassword;
//判断手机型号
+ (NSString *)deviceString;

@end

NS_ASSUME_NONNULL_END
