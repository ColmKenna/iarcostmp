//
//  ArcosLineSegment.h
//  iArcos
//
//  Created by David Kilmartin on 23/08/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArcosLineSegment : NSObject {
    CGPoint start;
    CGPoint end;
}

@property(nonatomic,assign) CGPoint start;
@property(nonatomic,assign) CGPoint end;

-(id) init:(CGPoint)aStart withEnd:(CGPoint)anEnd;

@end
