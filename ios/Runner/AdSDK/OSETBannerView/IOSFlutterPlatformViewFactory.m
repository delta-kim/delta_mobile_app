//
//  IOSFlutterPlatformViewFactory.m
//  Runner
//
//  Created by YaoHaoFei on 2022/4/21.
//

#import "IOSFlutterPlatformViewFactory.h"
#import "IOSPlatformView.h"


// OSETBannerViewFactory.m
@implementation IOSFlutterPlatformViewFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}


/**
 * 返回platformview实现类
 *@param frame 视图的大小
 *@param viewId 视图的唯一表示id
 *@param args 从flutter  creationParams 传回的参数
 *
 */
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id)args {
    return [[IOSPlatformView alloc] initWithFrame:frame
                                  viewIdentifier:viewId
                                       arguments:args
                                 binaryMessenger:_messenger];
}

//如果需要使用args传参到ios，需要实现这个方法，返回协议。否则会失败。
- (NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar{
    [registrar registerViewFactory:[[IOSFlutterPlatformViewFactory alloc] init] withId:@"ad_set/banner"];
}
@end
