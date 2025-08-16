//
//  ADSManager.h
//  YhsADSProject
//
//  Created by 熊俊 on 2019/10/29.
//  Copyright © 2019 熊俊. All rights reserved.
/*
 
 OSETSDK_Version  2.2.0

 iOS 9.0以上
 
 */
 
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OSETManager : NSObject

@property (nonatomic, strong) NSString *testModeDeviceID;


+ (instancetype)shareInstance;

/**
SDK初始化
 
 @param publicId 公共Id
 */
+ (void)configure:(NSString *)publicId successful:(void (^)(void))successful failure:(void (^)(NSError * _Nonnull error))failure;

/// 获取聚合SDK版本号
+ (NSString *)version;

/// 打开日志模式
+ (void)openDebugLog;

//检查SDK是否初始化成功
+ (BOOL)checkConfigure;
+ (void)setMuted:(BOOL)muted;
//设置隐私政策网址url  （UA地区需要 建议设置）
+ (void)setPrivacyPolicy:(NSString *)privacyPolicy;
//设置用户服务条款 url  （可选）
+ (void)setTermsOfServices:(NSString *)termsOfServices;
/**
 SDK配置日志 用户唯一标识符 推荐设置
 
 @param uid  用户唯一标识符 。userid,手机号,加密字符串等。 此ID仅用于log日志追踪 
 */
+ (void)configureLogsWithUid:(NSString *)uid;

@end

NS_ASSUME_NONNULL_END
