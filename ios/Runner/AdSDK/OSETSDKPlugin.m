//
//  OSETSDKPlugin.m
//  Runner
//
//  Created by Shens on 27/12/2022.
//

#import "OSETSDKPlugin.h"
#import <OSETSDK/OSETSDK.h>
#import "GeneratedPluginRegistrant.h"

#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>
#import "IOSFlutterPlatformViewFactory.h"
// 未知
#define  unknown  @"unknown"
// 广告加载完毕
#define  onAdLoaded  @"onAdLoaded"
// 广告错误
#define  onAdError  @"onAdError"
// 广告展示
#define onAdExposure  @"onAdExposure"
// 广告关闭
#define onAdClosed  @"onAdClosed"
// 广告点击
#define onAdClicked  @"onAdClicked"
// 获得奖励
#define onAdReward  @"onReward"
// 跳过广告
#define onAdSkip  @"onAdSkip"
// 超过广告时间
#define onAdTimeOver  @"onAdTimeOver"

@interface OSETSDKPlugin()<OSETSplashAdDelegate,OSETInterstitialAdDelegate,OSETRewardVideoAdDelegate,FlutterStreamHandler>

@property (nonatomic,strong) OSETSplashAd *splashAd;
@property (nonatomic,strong) OSETInterstitialAd *interstitialAd;
@property (nonatomic,strong) OSETRewardVideoAd *rewardVideoAd;

@end

static OSETSDKPlugin *manager = nil;

@implementation OSETSDKPlugin
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OSETSDKPlugin alloc] init];
    });
    return manager;
}
-(void)initSDK:(NSObject<FlutterPluginRegistry>*)registry withWindow:(UIWindow *)window{
    
    if(window && [window isKindOfClass:[UIWindow class]]){
        self.window = window;
    }else{
        window = [UIApplication sharedApplication].keyWindow;
        self.window = window;
    }
    
    if([window.rootViewController isKindOfClass:[FlutterViewController class]]){
        self.rootVC = (FlutterViewController *)window.rootViewController;
    }else if([window.rootViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController * nav =(UINavigationController *)window.rootViewController;
        self.rootVC = (FlutterViewController *)nav.topViewController;
    }
    //注册事件通道
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"AdSet_HW" binaryMessenger:self.rootVC.binaryMessenger];
    [eventChannel setStreamHandler:self];

    //注册消息通道
      FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
                                              methodChannelWithName:@"AdSet_HW"
                                              binaryMessenger:self.rootVC.binaryMessenger];
//    __weak typeof(self) weakSelf = self;
    self.channel = batteryChannel;
    [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
      // Note: this method is invoked on the UI thread.
        if ([@"getPlatformVersion" isEqualToString:call.method]) {
            result([OSETManager version]);
        }else if ([@"initSdk" isEqualToString:call.method]) {
          if (call.arguments) {
              NSDictionary * dict = [NSDictionary dictionaryWithDictionary:call.arguments];
              if (dict[@"isDebug"]) {
                  [OSETManager openDebugLog];
              }
              NSString * appKey =  dict[@"appKey"];
              if(appKey && [appKey isKindOfClass:[NSString class]] && appKey.length>0){
                  [OSETManager configure:appKey successful:^{
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [self.channel invokeMethod:@"initSuccess" arguments:nil];
                      });
                  } failure:^(NSError * _Nonnull error) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [self.channel invokeMethod:@"initError" arguments:error.localizedDescription];
                      });
                  }];
              }else{
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [self.channel invokeMethod:@"initError" arguments:@"initSdk-appKey-为空"];
                  });
              }
          }
      }else if([@"showAppOpen" isEqualToString:call.method]) {
          if (call.arguments) {
              NSDictionary * dict = [NSDictionary dictionaryWithDictionary:call.arguments];
              if ([self isNotNull:dict[@"posId"]]) {
                  self.splashAd = [[OSETSplashAd alloc] initWithSlotId:dict[@"posId"]];
                  self.splashAd.delegate = self;
                  [self.splashAd loadAdData];
              }else{
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [self.channel invokeMethod:@"showAppOpenError" arguments:@{@"errorCode":@"1",@"errorMessage":@"showAppOpen-posId-为空"}];
                  });
              }
          }else{
//              result(@(NO));
          }

      }else if([@"showInterstitial" isEqualToString:call.method]) {
          if (call.arguments) {
              NSDictionary * dict = [NSDictionary dictionaryWithDictionary:call.arguments];
              if ([self isNotNull:dict[@"posId"]]) {
                  self.interstitialAd = [[OSETInterstitialAd alloc] initWithSlotId:dict[@"posId"]];
                  self.interstitialAd.delegate = self;
                  [self.interstitialAd loadAdData];
              }else{
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [self.channel invokeMethod:@"onInterstitialError" arguments:@{@"errorCode":@"1",@"errorMessage":@"showAppOpen-posId-为空"}];
                  });
              }
          }else{
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self.channel invokeMethod:@"onInterstitialError" arguments:@{@"errorCode":@"1",@"errorMessage":@"showAppOpen-posId-为空"}];
              });
          }
      }else if([@"showReward" isEqualToString:call.method]) {
          if (call.arguments) {
              NSDictionary * dict = [NSDictionary dictionaryWithDictionary:call.arguments];
              if ([self isNotNull:dict[@"posId"]]) {
                  NSString * userId = @"";
                  if ([self isNotNull:dict[@"userId"]]) {
                      userId = dict[@"userId"];
                  }
                  if(self.rewardVideoAd){
                      self.rewardVideoAd.delegate = self;
                      [self.rewardVideoAd loadAdData];
                  }else{
                      self.rewardVideoAd = [[OSETRewardVideoAd alloc] initWithSlotId:dict[@"posId"] withUserId:dict[@"userId"]];
                      self.rewardVideoAd.delegate = self;
                      [self.rewardVideoAd loadAdData];
                  }
              }else{
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [self.channel invokeMethod:@"onRewardError" arguments:@{@"errorCode":@"1",@"errorMessage":@"showAppOpen-posId-为空"}];
                  });
              }
          }else{
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self.channel invokeMethod:@"onRewardError" arguments:@{@"errorCode":@"1",@"errorMessage":@"showAppOpen-posId-为空"}];
              });
          }
      }else if([@"checkAndReqPermission" isEqualToString:call.method]) {
          if (@available(iOS 14, *)) {
              [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                  // Tracking authorization completed. Start loading ads here.
              }];
          } else {
              // Fallback on earlier versions
          }
          result(@(YES));
      }else {
        result(FlutterMethodNotImplemented);
        NSLog(@"OC没有找到方法%@",call.method);
      }
//        result(@);
    }];
}

#pragma mark OSETSplashAdDelegate
- (void)splashDidReceiveSuccess:(nonnull id)splashAd slotId:(nonnull NSString *)slotId {
    NSLog(@"oset-main-splashDidReceiveSuccess");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.channel invokeMethod:@"onAppOpenShow" arguments:nil];
        [self.splashAd showSplashAd];
    });
}

- (void)splashLoadToFailed:(nonnull id)splashAd error:(nonnull NSError *)error {
    NSLog(@"oset-main-splashLoadToFailed-%@",error);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.channel invokeMethod:@"onAppOpenError" arguments:@{@"errorCode":[NSString stringWithFormat:@"%ld",error.code],@"errorMessage":error.localizedDescription}];
    });
}

- (void)splashDidClick:(nonnull id)splashAd {

    NSLog(@"oset-main-splashDidClick");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.channel invokeMethod:@"onAppOpenClick" arguments:nil];
    });
}

- (void)splashDidClose:(nonnull id)splashAd {
    self.splashAd  = nil;
    NSLog(@"oset-main-splashDidClose");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.channel invokeMethod:@"onAppOpenClose" arguments:nil];
    });
}
#pragma mark OSETInterstitialAdDelegate
- (void)interstitialDidReceiveSuccess:(nonnull id)interstitialAd slotId:(nonnull NSString *)slotId {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.interstitialAd showInterstitialWithViewController:self.rootVC];
        [self.channel invokeMethod:@"onInterstitialShow" arguments:nil];
    });
}

- (void)interstitialLoadToFailed:(nonnull id)interstitialAd error:(nonnull NSError *)error {
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setValue:onAdError forKey:@"eventType"];
//    [dic setValue:@"interstitial" forKey:@"adType"];
//    [dic setValue:[NSString stringWithFormat:@"code = %ld",(long)error.code] forKey:@"msg"];
    //if (self.eventSink) self.eventSink(dic);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.channel invokeMethod:@"onInterstitialError" arguments:@{@"errorCode":[NSString stringWithFormat:@"%ld",error.code],@"errorMessage":error.localizedDescription}];
    });
}

- (void)interstitialDidClick:(nonnull id)interstitialAd {
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setValue:onAdClicked forKey:@"eventType"];
//    [dic setValue:@"interstitial" forKey:@"adType"];
//    [dic setValue:@"" forKey:@"msg"];
    //if (self.eventSink) self.eventSink(dic);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.channel invokeMethod:@"onInterstitialClick" arguments:nil];
    });
}

- (void)interstitialDidClose:(nonnull id)interstitialAd {
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setValue:onAdClosed forKey:@"eventType"];
//    [dic setValue:@"interstitial" forKey:@"adType"];
//    [dic setValue:@"" forKey:@"msg"];
    //if (self.eventSink) self.eventSink(dic);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.channel invokeMethod:@"onInterstitialClose" arguments:nil];
    });
}
#pragma mark OSETRewardVideoAdDelegate
- (void)rewardVideoDidReceiveSuccess:(nonnull id)rewardVideoAd slotId:(nonnull NSString *)slotId {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.rewardVideoAd showRewardVideoWithViewController:self.rootVC];
        NSLog(@"oset-main-rewardVideoDidReceiveSuccess");
        [self.channel invokeMethod:@"onRewardShow" arguments:nil];
    });
}

- (void)rewardVideoLoadToFailed:(nonnull id)rewardVideoAd error:(nonnull NSError *)error {
    if(error){

        dispatch_async(dispatch_get_main_queue(), ^{
            NSString * errStr = @"";
            if(error){
                errStr =error.localizedDescription;
            }
            [self.channel invokeMethod:@"onRewardError" arguments:errStr];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.channel invokeMethod:@"onRewardError" arguments:@{@"errorCode":[NSString stringWithFormat:@"%ld",error.code],@"errorMessage":error.localizedDescription}];
        });
    }
}
- (void)rewardVideoDidClick:(nonnull id)rewardVideoAd {
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setValue:onAdClicked forKey:@"eventType"];
//    [dic setValue:@"rewardVideo" forKey:@"adType"];
//    [dic setValue:@"" forKey:@"msg"];
    //if (self.eventSink) self.eventSink(dic);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"oset-main-rewardVideoDidClick");
        [self.channel invokeMethod:@"onRewardClick" arguments:nil];
    });
}
- (void)rewardVideoDidClose:(id)rewardVideoAd checkString:(NSString *)checkString{
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setValue:onAdClosed forKey:@"eventType"];
//    [dic setValue:@"" forKey:@"msg"];
//    [dic setValue:@"rewardVideo" forKey:@"adType"];
    //if (self.eventSink) self.eventSink(dic);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"oset-main-rewardVideoDidClose");
        [self.channel invokeMethod:@"onRewardClose" arguments:checkString];
    });
}
//激励视频播放结束
- (void)rewardVideoPlayEnd:(id)rewardVideoAd  checkString:(NSString *)checkString{
}
-(void)rewardVideoPlayError:(id)rewardVideoAd error:(NSError *)error{
}
-(void)rewardVideoPlayStart:(id)rewardVideoAd checkString:(NSString *)checkString{
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setValue:onAdExposure forKey:@"eventType"];
//    [dic setValue:@"" forKey:@"msg"];
//    [dic setValue:@"rewardVideo" forKey:@"adType"];
    //if (self.eventSink) self.eventSink(dic);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"oset-main-rewardVideoPlayStart");
        [self.channel invokeMethod:@"onRewardShow" arguments:checkString];
    });
}
//激励视频奖励
- (void)rewardVideoOnReward:(id)rewardVideoAd checkString:(NSString *)checkString{
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setValue:onAdReward forKey:@"eventType"];
//    [dic setValue:checkString forKey:@"msg"];
//    [dic setValue:@"rewardVideo" forKey:@"adType"];
    //if (self.eventSink) self.eventSink(dic);
//    NSLog(@"=====激励视频    OnReward");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"oset-main-rewardVideoOnReward");
        [self.channel invokeMethod:@"onRewardReward" arguments:@{@"requestId":checkString,@"var1":@0.0}];
    });
}

#pragma make NULL 判断字符是否为空
-(BOOL)isNotNull:(id)velue{
    if (velue && ![velue isKindOfClass:[NSNull class]]) {
        NSString *str = [NSString stringWithFormat:@"%@",velue];
        if (str.length >0) {
            return YES;
        }
    }
    return NO;
}
#pragma make FlutterEventChannel
// 这个onListen是Flutter端开始监听这个channel时的回调，第二个参数 EventSink是用来传数据的载体。
- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)events {
//    self.eventSink = events;
    NSLog(@"onListenWithArguments %@  == %@",arguments,events);
    return nil;
}
/// flutter不再接收
- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    // arguments flutter给native的参数
    NSLog(@"lutter给native的参数 onCancelWithArguments %@",arguments);
    return nil;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar{
    [registrar registerViewFactory:[[IOSFlutterPlatformViewFactory alloc] init] withId:@"flutter_plugin_ad_banner"];
}

@end
