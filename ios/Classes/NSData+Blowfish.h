//
//  NSData+Blowfish.h
//  BlowfishMasterYi
//
//  Created by Bun LV on 5/8/20.
//  Copyright © 2020 ResourceCheck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Blowfish)

+ (NSString *)doBlowfishEncrypt:(NSString *)message withKey:(NSString *)key withError:(NSError **)_error;
+ (NSString *)doBlowfishDecrypt:(NSString *)message withKey:(NSString *)key withError:(NSError **)_error;

@end

NS_ASSUME_NONNULL_END
