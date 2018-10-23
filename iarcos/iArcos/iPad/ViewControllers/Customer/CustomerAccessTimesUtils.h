//
//  CustomerAccessTimesUtils.h
//  iArcos
//
//  Created by David Kilmartin on 03/10/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerAccessTimesUtils : NSObject {
    NSMutableDictionary* _weekdayHashtable;
}

@property(nonatomic, retain) NSMutableDictionary* weekdayHashtable;

- (NSString*)retrieveAccessTimesInfoValue:(NSString*)anAccessTimesContent;

@end
