//
//  IOSPlatformNative.m
//  Runner
//
//  Created by Shens on 18/4/2025.
//

#import "IOSPlatformNative.h"
#import "OSETSDKPlugin.h"



@implementation IOSPlatformNative

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
                           vc:(UIViewController *)vc{
    self = [super init];
      if (self) {
          self.nativeFrame = frame;
          // 初始化 MethodChannel（通道名需与 Flutter 端一致）
          NSString *channelName = [NSString stringWithFormat:@"ad_set/native_%lld", viewId];
          _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
          // 解析 Flutter 传递的参数
          NSString *posId = args[@"pos_id"];
          self.nativeAd = [[OSETNativeAd alloc]initWithSlotId:posId];
          self.nativeAd.delegate = self;
          self.nativeAd.rootViewController = vc;
          self.nativeAd.size = CGSizeMake(frame.size.width, frame.size.height);
          [self.nativeAd loadAdData];
      }
      return self;
}


- (UIView *)nativrView{
    if(_nativrView == nil){
        _nativrView = [[UIView alloc] initWithFrame:self.nativeFrame];
    }
    return _nativrView;
}

- (UIView *)view{
    return [self nativrView];
}
/// 信息流加载成功
- (void)nativeExpressAdLoadSuccess:(id)nativeExpressView{
    NSLog(@"nativeExpressAdLoadSuccess=%@",nativeExpressView);
    if([nativeExpressView isKindOfClass:[UIView class]]){
        UIView * nativeAdView = nativeExpressView;
        nativeAdView.backgroundColor = [UIColor greenColor];
        // 将广告视图添加到容器视图
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.nativrView addSubview:nativeAdView];
        });
    }
}

/// 加载失败
/// @param nativeExpressAd 信息流实例
/// @param error 错误信息
- (void)nativeExpressAdFailedToLoad:(id)nativeExpressAd error:(NSError *)error{
    NSLog(@"nativeExpressAdFailedToLoad%@",error);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.channel invokeMethod:@"onNativeError" arguments:@{@"errorCode":[NSString stringWithFormat:@"%ld",error.code],@"errorMessage":error.localizedDescription}];
    });
}

/// 信息流点击事件
/// @param nativeExpressView view
- (void)nativeExpressAdDidClick:(id)nativeExpressView{
    NSLog(@"nativeExpressAdDidClick");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.channel invokeMethod:@"onNativeClick" arguments:nil];
    });

}

/// 信息流过期事件
- (void)nativeExpressAdDidClose:(id)nativeExpressView{
    NSLog(@"nativeExpressAdDidClose");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.channel invokeMethod:@"onNativeClose" arguments:nil];
    });
    if([nativeExpressView isKindOfClass:[UIView class]]){
        UIView * view = (UIView *)nativeExpressView;
        [view removeFromSuperview];
        view = nil;
    }

}
//- (void)bannerDidReceiveSuccess:(id)bannerView slotId:(NSString *)slotId{
//    NSLog(@"oset-main-bannerDidReceiveSuccess");
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.channel invokeMethod:@"onBannerShow" arguments:nil];
//    });
//}
///// banner加载失败
//- (void)bannerLoadToFailed:(id)bannerView error:(NSError *)error{
//    NSLog(@"oset-main-bannerLoadToFailed-%@",error);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.channel invokeMethod:@"onBannerError" arguments:@{@"errorCode":[NSString stringWithFormat:@"%ld",error.code],@"errorMessage":error.localizedDescription}];
//    });
//}
//- (void)bannerDidClose:(id)bannerView{
//    NSLog(@"oset-main-bannerDidClose");
//    UIView *view = (UIView *)bannerView;
//    [view removeFromSuperview];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.channel invokeMethod:@"onBannerClose" arguments:nil];
//    });
//}
///// banner点击
//- (void)bannerDidClick:(id)bannerView{
//    NSLog(@"oset-main-bannerDidClick");
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.channel invokeMethod:@"onBannerClick" arguments:nil];
//    });
//}
@end
