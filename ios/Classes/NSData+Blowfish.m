//
//  NSData+Blowfish.m
//  BlowfishMasterYi
//
//  Created by Bun LV on 5/8/20.
//  Copyright © 2020 ResourceCheck. All rights reserved.
//

#import "NSData+Blowfish.h"

@implementation NSData (Blowfish)

+ (NSData *)doBlowfish:(NSData *)dataIn
               context:(CCOperation)kCCEncrypt_or_kCCDecrypt
                   key:(NSData *)key
               options:(CCOptions)options
                    iv:(NSData *)iv
                 error:(NSError **)error
{
    CCCryptorStatus ccStatus   = kCCSuccess;
    size_t          cryptBytes = 0;
    NSMutableData  *dataOut    = [NSMutableData dataWithLength:dataIn.length + kCCBlockSizeBlowfish];

    ccStatus = CCCrypt( kCCEncrypt_or_kCCDecrypt,
                       kCCAlgorithmBlowfish,
                       options,
                       key.bytes,
                       key.length,
                       (iv)?nil:iv.bytes,
                       dataIn.bytes,
                       dataIn.length,
                       dataOut.mutableBytes,
                       dataOut.length,
                       &cryptBytes);

    if (ccStatus == kCCSuccess) {
        dataOut.length = cryptBytes;
    }
    else {
        if (error) {
            *error = [NSError errorWithDomain:@"kEncryptionError"
                                         code:ccStatus
                                     userInfo:nil];
        }
        dataOut = nil;
    }
    return dataOut;
}

+ (NSString *)doBlowfishEncrypt:(NSString *)message withKey:(NSString *)key withError:(NSError **)_error
{
    NSError *error;
    NSData *dataEncrypted = [self doBlowfish:[message dataUsingEncoding:NSUTF8StringEncoding]
                                     context:kCCEncrypt
                                         key:[key dataUsingEncoding:NSUTF8StringEncoding]
                                     options:kCCOptionPKCS7Padding
                                          iv:nil
                                       error:&error];
    
    if (error)
    {
        NSLog(@"%@", error.localizedDescription);
        *_error = error;
        
        return @"";
    }
    else
    {
        NSString *str = [dataEncrypted base64EncodedStringWithOptions:0];
        if (str)
        {
            return str;
        }
    }
    
    return @"";
}

+ (NSString *)doBlowfishDecrypt:(NSString *)message withKey:(NSString *)key withError:(NSError **)_error
{
    NSError *error;
    NSData *dataDecrypted = [self doBlowfish:[[NSData alloc] initWithBase64EncodedString:message options:0]
                                     context:kCCDecrypt
                                         key:[key dataUsingEncoding:NSUTF8StringEncoding]
                                     options:kCCOptionPKCS7Padding
                                          iv:nil
                                       error:&error];
    
    if (error)
    {
        NSLog(@"%@", error.localizedDescription);
        *_error = error;
        
        return @"";
    }
    else
    {
        NSString *str = [[NSString alloc] initWithData:dataDecrypted encoding:NSUTF8StringEncoding];
        if (str)
        {
            return str;
        }
    }
    
    return @"";
}

@end
