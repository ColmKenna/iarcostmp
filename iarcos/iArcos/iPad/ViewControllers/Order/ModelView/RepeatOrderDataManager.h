//
//  RepeatOrderDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 18/09/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderHeader.h"
#import "ArcosCoreData.h"

@interface RepeatOrderDataManager : NSObject {
    NSNumber* _orderStatusIUR;
}

@property(nonatomic, retain) NSNumber* orderStatusIUR;

- (void)repeatOrderWithDataDict:(NSMutableDictionary*)anOrderHeader;

@end
