//
//  ArcosErrorResult.h
//  Arcos
//
//  Created by David Kilmartin on 27/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArcosErrorResult : NSObject {
    BOOL _successFlag;
    NSString* _errorDesc;
}

@property(nonatomic, assign) BOOL successFlag;
@property(nonatomic, retain) NSString* errorDesc;

@end
