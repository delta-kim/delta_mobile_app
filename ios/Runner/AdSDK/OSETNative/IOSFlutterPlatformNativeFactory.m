//
//  IOSFlutterPlatformNativeFactory.m
//  Runner
//
//  Created by Shens on 18/4/2025.
//

#import "IOSFlutterPlatformNativeFactory.h"
#import "IOSPlatformNative.h"


// OSETBannerViewFactory.m
@implementation IOSFlutterPlatformNativeFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}


/**
 * 返回platformview实现类
 *@param frame 视图的大小
 *@param viewId 视图的唯一表示id
 *@param args 从flutter  creationParams 传回的参数
 *
 */
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger  withVC:(UIViewController *)vc{
    self = [super init];
    if (self) {
        _messenger = messenger;
        self.vc = vc;
    }
    return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id)args  {
    return [[IOSPlatformNative alloc] initWithFrame:frame
                                  viewIdentifier:viewId
                                       arguments:args
                                 binaryMessenger:_messenger
                                               vc:self.vc];
}

//如果需要使用args传参到ios，需要实现这个方法，返回协议。否则会失败。
- (NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar{
    [registrar registerViewFactory:[[IOSFlutterPlatformNativeFactory alloc] init] withId:@"ad_set/native"];
}

@end
