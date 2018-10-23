//
//  DashboardVanStocksDetailTableCellFactory.h
//  iArcos
//
//  Created by David Kilmartin on 09/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DashboardVanStocksDetailBaseTableCell.h"

@interface DashboardVanStocksDetailTableCellFactory : NSObject {
    NSString* _readTableCellId;
    NSString* _writeTableCellId;
    NSString* _actionTableCellId;
}

@property(nonatomic, retain) NSString* readTableCellId;
@property(nonatomic, retain) NSString* writeTableCellId;
@property(nonatomic, retain) NSString* actionTableCellId;

+ (instancetype)factory;
- (DashboardVanStocksDetailBaseTableCell*)createVanStocksDetailBaseTableCellWithData:(NSMutableDictionary*)aDataDict;
- (NSString*)identifierWithData:(NSMutableDictionary*)aDataDict;

@end
