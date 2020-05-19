#import "EncryptblowfishPlugin.h"
#import "NSData+Blowfish.h"

@implementation EncryptblowfishPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"encryptblowfish"
            binaryMessenger:[registrar messenger]];
  EncryptblowfishPlugin* instance = [[EncryptblowfishPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

    NSDictionary *dictData = call.arguments;

  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else if([@"getStringAfterEncrypt" isEqualToString:call.method]){
      
      NSString *key = dictData[@"key"];
      NSString *origin = dictData[@"origin"];
      NSLog(@"key: %@", key);
      
      NSError *error = nil;
      NSString *encrypt = [NSData doBlowfishEncrypt:origin withKey:key withError:&error];
      
      result([@"iOS " stringByAppendingString:encrypt]);
//      NSString *decrypt = [NSData doBlowfishDecrypt:encrypt withKey:@"" withError:&error];
  }else if([@"getStringAfterDecrypt" isEqualToString:call.method]){
      NSString *keydecrypt = dictData[@"key"];
      NSString *decryptStr = dictData[@"decrypt"];
      NSLog(@"key: %@", keydecrypt);
      NSError *error = nil;
      NSString *decrypt = [NSData doBlowfishDecrypt:decryptStr withKey:keydecrypt withError:&error];//TODO tim cach truyen dau vao cua ham vao : chuoi decrypt & key
      
      result([@"iOS " stringByAppendingString:decrypt]);

    }else {
    result(FlutterMethodNotImplemented);
  }
}

@end
