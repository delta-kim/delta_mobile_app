//
//  IOSPlatformView.m
//  Runner
//
//  Created by YaoHaoFei on 2022/4/21.

#import "IOSPlatformView.h"
#import "OSETSDKPlugin.h"

@implementation IOSPlatformView
- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger{
    self = [super init];
      if (self) {
          self.bannerFrame = frame;
          // 初始化 MethodChannel（通道名需与 Flutter 端一致）
          NSString *channelName = [NSString stringWithFormat:@"ad_set/banner_%lld", viewId];
          _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
          // 解析 Flutter 传递的参数
          NSString *posId = args[@"pos_id"];
//          NSString *userId = args[@"user_id"];
          // 初始化广告视图
          self.bannerAd = [[OSETBannerAd alloc] initWithSlotId:posId containView:self.bannerView  rect:CGRectMake(0, 0, frame.size.width,frame.size.height)];
          self.bannerAd.delegate = self;
          [self.bannerAd loadAdDataAndShow];
      }
      return self;
}


- (UIView *)bannerView{
    if(_bannerView == nil){
        _bannerView = [[UIView alloc] initWithFrame:self.bannerFrame];
    }
    return _bannerView;
}

- (UIView *)view{
    return [self bannerView];
}
- (void)bannerDidReceiveSuccess:(id)bannerView slotId:(NSString *)slotId{
    NSLog(@"oset-main-bannerDidReceiveSuccess");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.channel invokeMethod:@"onBannerShow" arguments:nil];
    });
}
/// banner加载失败
- (void)bannerLoadToFailed:(id)bannerView error:(NSError *)error{
    NSLog(@"oset-main-bannerLoadToFailed-%@",error);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.channel invokeMethod:@"onBannerError" arguments:@{@"errorCode":[NSString stringWithFormat:@"%ld",error.code],@"errorMessage":error.localizedDescription}];
    });
}
- (void)bannerDidClose:(id)bannerView{
    NSLog(@"oset-main-bannerDidClose");
    UIView *view = (UIView *)bannerView;
    [view removeFromSuperview];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.channel invokeMethod:@"onBannerClose" arguments:nil];
    });
}
/// banner点击
- (void)bannerDidClick:(id)bannerView{
    NSLog(@"oset-main-bannerDidClick");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.channel invokeMethod:@"onBannerClick" arguments:nil];
    });
}
@end
