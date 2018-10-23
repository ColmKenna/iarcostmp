//
//  ArcosLineSegment.m
//  iArcos
//
//  Created by David Kilmartin on 23/08/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "ArcosLineSegment.h"

@implementation ArcosLineSegment

@synthesize start;
@synthesize end;

-(id) init:(CGPoint)aStart withEnd:(CGPoint)anEnd{
    self = [super init];
    self.start = aStart;
    self.end = anEnd;
    return self;
}

@end
