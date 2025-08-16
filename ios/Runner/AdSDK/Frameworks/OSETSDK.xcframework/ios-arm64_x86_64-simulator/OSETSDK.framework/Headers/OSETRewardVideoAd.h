//
//  OSETRewardVideoAd.h
//  YhsADSProject
//
//  Created by 熊俊 on 2020/4/27.
//  Copyright © 2020 熊俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol OSETRewardVideoAdDelegate <NSObject>
@optional

/// 激励视频加载成功
/// @param rewardVideoAd 激励视频实例
/// @param slotId 广告位ID
- (void)rewardVideoDidReceiveSuccess:(id)rewardVideoAd slotId:(NSString *)slotId;
/// 激励视频加载失败
- (void)rewardVideoLoadToFailed:(id)rewardVideoAd error:(NSError *)error;
/// 激励视频点击
- (void)rewardVideoDidClick:(id)rewardVideoAd;
/// 激励视频关闭
- (void)rewardVideoDidClose:(id)rewardVideoAd checkString:(NSString *)checkString;
//激励视频播放出错
- (void)rewardVideoPlayError:(id)rewardVideoAd error:(NSError *)error;
//激励视频开始播放
- (void)rewardVideoPlayStart:(id)rewardVideoAd;
//激励视频奖励
- (void)rewardVideoOnReward:(id)rewardVideoAd checkString:(NSString *)checkString;
@end


@interface OSETRewardVideoAd : NSObject

@property (nonatomic,weak) id <OSETRewardVideoAdDelegate> delegate;


/// 激励视频初始化 
/// @param slotId 广告位ID
- (instancetype)initWithSlotId:(NSString *)slotId withUserId:(NSString *)userId;

/// 加载
- (void)loadAdData;

/// 显示
- (void)showRewardVideoWithViewController:(UIViewController *)viewController;
//这个广告是否准备好播放。
-(BOOL)isReady;
@end

NS_ASSUME_NONNULL_END
