//
//  rcktAES.h
//  James
//
//  Created by Modesty en Roland on 22/02/15.
//  Copyright (c) 2015 Rckt. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonCryptor.h>

@interface rcktAES : NSData

- (NSData*)AES128Decrypt: (NSData*)hex key:(NSString*)key;
- (NSData*)AES128Encrypt:  (NSData*)str key:(NSString*)key;

- (NSString *)addPaddingToString:(NSString *)string;
- (NSString *)createKeyFromPassword:(NSString*)pwd;
- (NSString*)hexStringFromData:(NSData *)data;
- (NSData *)dataFromHexString:(NSString *)string;

@end
