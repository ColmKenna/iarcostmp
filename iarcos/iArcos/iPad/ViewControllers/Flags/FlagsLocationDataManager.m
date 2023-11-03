//
//  FlagsLocationDataManager.m
//  iArcos
//
//  Created by Richard on 02/11/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "FlagsLocationDataManager.h"

@implementation FlagsLocationDataManager
@synthesize currentIndexPath = _currentIndexPath;

- (void)dealloc {
    self.currentIndexPath = nil;
        
    [super dealloc];
}

@end
