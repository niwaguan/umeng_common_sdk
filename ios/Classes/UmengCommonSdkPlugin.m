#import "UmengCommonSdkPlugin.h"
#import <UMCommon/UMConfigure.h>
#import <UMCommon/MobClick.h>

@interface UMengflutterpluginForUMCommon : NSObject
@end
@implementation UMengflutterpluginForUMCommon

+ (BOOL)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
  BOOL resultCode = YES;
  if ([@"initCommon" isEqualToString:call.method]){
    // [UMConfigure setLogEnabled:YES];
    NSArray* arguments = (NSArray *)call.arguments;
    NSString* appkey = arguments[0];
    NSString* channel = arguments[1];
    [UMConfigure initWithAppkey:appkey channel:channel];
  }
  else{
    resultCode = NO;
  }
  return resultCode;
}
@end

@interface UMengflutterpluginForAnalytics : NSObject
@end
@implementation UMengflutterpluginForAnalytics : NSObject

+ (BOOL)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
  BOOL resultCode = YES;
  NSArray* arguments = (NSArray *)call.arguments;
  if ([@"onEvent" isEqualToString:call.method]){
    NSString* eventName = arguments[0];
    NSDictionary* properties = arguments[1];
    [MobClick event:eventName attributes:properties];
  }
  else if ([@"onProfileSignIn" isEqualToString:call.method]){
    NSString* userID = arguments[0];
    [MobClick profileSignInWithPUID:userID];
  }
  else if ([@"onProfileSignOff" isEqualToString:call.method]){
    [MobClick profileSignOff];
  }
  else if ([@"setPageCollectionModeAuto" isEqualToString:call.method]){
    [MobClick setAutoPageEnabled:YES];
  }
  else if ([@"setPageCollectionModeManual" isEqualToString:call.method]){
    [MobClick setAutoPageEnabled:NO];
  }
  else if ([@"onPageStart" isEqualToString:call.method]){
    NSString* pageName = arguments[0];
    [MobClick beginLogPageView:pageName];
  }
  else if ([@"onPageEnd" isEqualToString:call.method]){
    NSString* pageName = arguments[0];
    [MobClick endLogPageView:pageName];
  }
  else if ([@"reportError" isEqualToString:call.method]){
    NSLog(@"reportError API not existed ");
    resultCode = NO;
  }
  else{
    resultCode = NO;
  }
  return resultCode;
}

@end

@implementation UmengCommonSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
                                   methodChannelWithName:@"umeng_common_sdk"
                                   binaryMessenger:[registrar messenger]];
  UmengCommonSdkPlugin* instance = [[UmengCommonSdkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
//  [registrar addApplicationDelegate:instance];
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
//  if ([MobClick handleUrl:url]) {
//    return YES;
//  }
//  return NO;
//}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    //result(FlutterMethodNotImplemented);
  }
  
  BOOL resultCode = [UMengflutterpluginForUMCommon handleMethodCall:call result:result];
  if (resultCode) {
    result(NULL);
    return;
  }
  
  resultCode = [UMengflutterpluginForAnalytics handleMethodCall:call result:result];
  if (resultCode) {
    result(NULL);
    return;
  }
  
  result(FlutterMethodNotImplemented);
}

@end
