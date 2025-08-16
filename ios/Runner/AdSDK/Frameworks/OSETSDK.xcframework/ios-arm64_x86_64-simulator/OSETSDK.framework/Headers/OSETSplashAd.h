//
//  OSETSplashAd.h
//  YhsADSProject
//
//  Created by 熊俊 on 2020/4/27.
//  Copyright © 2020 熊俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OSETSplashAdDelegate <NSObject>
@optional

/// 开屏加载成功
/// @param splashAd 开屏实例
/// @param slotId 广告位ID
- (void)splashDidReceiveSuccess:(id)splashAd slotId:(NSString *)slotId;

/// 开屏加载失败
- (void)splashLoadToFailed:(id)splashAd error:(NSError *)error;
//广告显示失败
- (void)splashShowToFailed:(id)splashAd error:(NSError *)error;
/// 开屏点击
- (void)splashDidClick:(id)splashAd;

/// 开屏关闭
- (void)splashDidClose:(id)splashAd;
/// 开屏将要关闭
- (void)splashWillClose:(id)splashAd;

@end

@interface OSETSplashAd : NSObject

@property (nonatomic,weak) id <OSETSplashAdDelegate> delegate;

/// 开屏初始化
/// @param slotId 开屏广告位ID
- (instancetype)initWithSlotId:(NSString *)slotId;

/// 加载并且显示
- (void)loadAdData;
-(void)showSplashAd;

//这个广告是否准备好播放。
-(BOOL)isReady;
@end

NS_ASSUME_NONNULL_END
