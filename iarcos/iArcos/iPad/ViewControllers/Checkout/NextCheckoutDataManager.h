//
//  NextCheckoutDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 25/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NextCheckoutDataManager : NSObject {
    NSMutableArray* _sortedOrderKeys;
//    NSMutableDictionary* _orderLines;
//    NSMutableDictionary* _orderHeader;
}

@property(nonatomic,retain) NSMutableArray* sortedOrderKeys;
//@property(nonatomic,retain) NSMutableDictionary* orderLines;
//@property(nonatomic,retain) NSMutableDictionary* orderHeader;

- (NSMutableArray*)descrDetailAllFieldsWithDescrTypeCode:(NSString*)aDescrTypeCode hasDescrDetailCode:(NSString*)aDescrDetailCode;

@end
