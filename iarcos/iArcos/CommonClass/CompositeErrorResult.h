//
//  CompositeErrorResult.h
//  iArcos
//
//  Created by David Kilmartin on 15/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompositeErrorResult : NSObject {
    BOOL _successFlag;
    NSString* _errorMsg;
}

@property(nonatomic, assign) BOOL successFlag;
@property(nonatomic, retain) NSString* errorMsg;

@end
