//
//  OSETSDKPlugin.h
//  Runner
//
//  Created by Shens on 27/12/2022.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface OSETSDKPlugin : NSObject
+ (instancetype)shareInstance;
@property(nonatomic,strong)FlutterViewController * rootVC;
@property(nonatomic,strong)UIWindow * window;

@property (nonatomic, strong) FlutterMethodChannel *channel;

-(void)initSDK:(NSObject<FlutterPluginRegistry>*)registry withWindow:(UIWindow *)window;
@end

NS_ASSUME_NONNULL_END
