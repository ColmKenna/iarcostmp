//
//  FileMD5Calculator.m
//  iArcos
//
//  Created by David Kilmartin on 10/07/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "FileMD5Calculator.h"
#include <CommonCrypto/CommonDigest.h>
#import "ArcosUtils.h"

@implementation FileMD5Calculator

- (NSString*)retrieveFileMD5WithFilePath:(NSString*)aFilePath {
    NSFileHandle* handle = [NSFileHandle fileHandleForReadingAtPath:aFilePath];
    if(handle == nil) return @"ERROR GETTING FILE MD5"; // file didnt exist
    
    CC_MD5_CTX md5;
    
    CC_MD5_Init(&md5);
    
    BOOL done = NO;
    while(!done) {
        NSAutoreleasePool * pool = [NSAutoreleasePool new];
        NSData* fileData = [handle readDataOfLength:4096];
        CC_MD5_Update(&md5, [fileData bytes], [ArcosUtils convertNSUIntegerToUnsignedInt:[fileData length]]);
        if( [fileData length] == 0 ) done = YES;
        [pool drain];
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}

@end
