//
//  IOSFlutterPlatformNativeFactory.h
//  Runner
//
//  Created by Shens on 18/4/2025.
//

#import <Foundation/Foundation.h>
#import "GeneratedPluginRegistrant.h"

NS_ASSUME_NONNULL_BEGIN

@interface IOSFlutterPlatformNativeFactory : NSObject<FlutterPlatformViewFactory>

@property(nonatomic,strong)UIViewController * vc;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar;
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger withVC:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
