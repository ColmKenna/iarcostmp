//
//  PriceChangeTableCellFactory.h
//  iArcos
//
//  Created by David Kilmartin on 13/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PriceChangeBaseTableCell.h"

@interface PriceChangeTableCellFactory : NSObject {
    NSString* _readableTableCellId;
    NSString* _writableTableCellId;
}

@property(nonatomic, retain) NSString* readableTableCellId;
@property(nonatomic, retain) NSString* writableTableCellId;

+ (instancetype)factory;
- (PriceChangeBaseTableCell*)createPriceChangeBaseTableCellWithData:(NSMutableDictionary*)aDataDict;
- (NSString*)identifierWithData:(NSMutableDictionary*)aDataDict;

@end
