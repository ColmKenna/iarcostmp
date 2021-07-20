//
//  ArcosMyResult.m
//  iArcos
//
//  Created by Richard on 19/07/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import "ArcosMyResult.h"

@implementation ArcosMyResult
@synthesize uni = _uni;
@synthesize ud = _ud;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.uni = 0;
        self.ud = 0;
    }
    return self;
}

- (void)processRawData:(NSString*)aProductColour {
    NSArray* dataArray = [[ArcosUtils convertNilToEmpty:aProductColour] componentsSeparatedByString:@","];
    if ([dataArray count] != 2) return;
    NSString* uniStr = [ArcosUtils trim:[dataArray firstObject]];
    NSString* udStr = [ArcosUtils trim:[dataArray lastObject]];
    if (![ArcosValidator isInteger:uniStr] || ![ArcosValidator isInteger:udStr]) return;
    self.uni = [[ArcosUtils convertStringToNumber:uniStr] intValue];
    self.ud = [[ArcosUtils convertStringToNumber:udStr] intValue];
}

@end
