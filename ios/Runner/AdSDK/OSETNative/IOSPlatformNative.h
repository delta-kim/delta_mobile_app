//
//  IOSPlatformNative.h
//  Runner
//
//  Created by Shens on 18/4/2025.
//

#import <Foundation/Foundation.h>
#import "GeneratedPluginRegistrant.h"
#import <OSETSDK/OSETSDK.h>
NS_ASSUME_NONNULL_BEGIN

@interface IOSPlatformNative : NSObject<FlutterPlatformView,OSETNativeAdDelegate>
@property (nonatomic, strong) FlutterMethodChannel *channel;
@property(nonatomic,strong) UIView * nativrView;
@property (nonatomic,strong) OSETNativeAd * nativeAd;
@property (nonatomic,assign) CGRect nativeFrame;

//-(id)initWithAdId:(NSString *)adId withFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
                           vc:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
