//
//  OSETNaiveAd.h
//  YhsADSProject
//
//  Created by 熊俊 on 2020/4/28.
//  Copyright © 2020 熊俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OSETNativeAdDelegate <NSObject>
@optional

/// 信息流加载成功
- (void)nativeExpressAdLoadSuccess:(id)nativeExpressView;

/// 加载失败
/// @param nativeExpressAd 信息流实例
/// @param error 错误信息
- (void)nativeExpressAdFailedToLoad:(id)nativeExpressAd error:(NSError *)error;

/// 信息流点击事件
/// @param nativeExpressView view
- (void)nativeExpressAdDidClick:(id)nativeExpressView;

- (void)nativeExpressAdDidClose:(id)nativeExpressView;

/// 信息流过期事件
//- (void)nativeExpressAdDidExpire:(id)nativeExpressView;

@end

@interface OSETNativeAd : NSObject

@property (nonatomic,weak) id <OSETNativeAdDelegate> delegate;
@property(nonatomic, weak) UIViewController *rootViewController;
@property(nonatomic, assign) CGSize size;

/// 信息流初始化
/// @param slotId 广告位ID
- (instancetype)initWithSlotId:(NSString *)slotId;

/// 加载信息流
- (void)loadAdData;

//nativeAdContainerView
@end

NS_ASSUME_NONNULL_END
