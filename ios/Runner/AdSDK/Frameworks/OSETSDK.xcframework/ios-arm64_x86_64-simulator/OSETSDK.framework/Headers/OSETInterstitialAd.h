//
//  OSETInterstitialAd.h
//  YhsADSProject
//
//  Created by 熊俊 on 2020/4/27.
//  Copyright © 2020 熊俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OSETInterstitialAdDelegate <NSObject>
@optional

/// 插屏加载成功
/// @param interstitialAd 插屏实例
/// @param slotId 广告位ID
- (void)interstitialDidReceiveSuccess:(id)interstitialAd slotId:(NSString *)slotId;

/// 插屏加载失败
- (void)interstitialLoadToFailed:(id)interstitialAd error:(NSError *)error;

/// 插屏点击
- (void)interstitialDidClick:(id)interstitialAd;

/// 插屏关闭
- (void)interstitialDidClose:(id)interstitialAd;

@end

@interface OSETInterstitialAd : NSObject

@property (nonatomic,weak) id <OSETInterstitialAdDelegate> delegate;

/// 插屏初始化
/// @param slotId 广告位ID
- (instancetype)initWithSlotId:(NSString *)slotId;

/// 加载
- (void)loadAdData;

/// 显示
- (void)showInterstitialWithViewController:(UIViewController *)viewController;

//这个广告是否准备好播放。
-(BOOL)isReady;
@end

NS_ASSUME_NONNULL_END
