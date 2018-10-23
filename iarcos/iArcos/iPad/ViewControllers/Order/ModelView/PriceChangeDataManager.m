//
//  PriceChangeDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 13/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "PriceChangeDataManager.h"
#import "ArcosCoreData.h"

@implementation PriceChangeDataManager
@synthesize displayList = _displayList;
@synthesize dataDict = _dataDict;


- (void)dealloc {
    self.displayList = nil;
    self.dataDict = nil;
    
    [super dealloc];
}

- (void)processRawData {    
    NSString* priceInProductTable = @"";
    NSMutableArray* tmpProductDictList = [[ArcosCoreData sharedArcosCoreData] productWithIUR:[self.dataDict objectForKey:@"ProductIUR"] withResultType:NSDictionaryResultType];
    if (tmpProductDictList != nil) {
        NSDictionary* tmpProductDict = [tmpProductDictList objectAtIndex:0];
        priceInProductTable = [NSString stringWithFormat:@"%.2f", [[tmpProductDict objectForKey:@"UnitTradePrice"] floatValue]];
    }
    NSString* priceInPriceList = @"";
    if ([[self.dataDict objectForKey:@"PriceFlag"] intValue] == 1) {
        priceInPriceList = [NSString stringWithFormat:@"%.2f", [[self.dataDict objectForKey:@"UnitPrice"] floatValue]];
    } else if ([[self.dataDict objectForKey:@"PriceFlag"] intValue] == 2) {
        priceInPriceList = [NSString stringWithFormat:@"%.2f", [[self.dataDict objectForKey:@"UnitPrice"] floatValue]];
    }
    
    self.displayList = [NSMutableArray arrayWithCapacity:3];
    [self.displayList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:1] fieldName:@"Standard Price" fieldData:priceInProductTable priceFlag:[NSNumber numberWithInt:0]]];
    [self.displayList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:1] fieldName:@"Customer Price" fieldData:priceInPriceList priceFlag:[self.dataDict objectForKey:@"PriceFlag"]]];
    [self.displayList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:2] fieldName:@"Special Price" fieldData:@"" priceFlag:[NSNumber numberWithInt:0]]];
}

- (NSMutableDictionary*)createCellDataWithCellType:(NSNumber*)aCellType fieldName:(NSString*)aFieldName fieldData:(id)aFieldData priceFlag:(NSNumber*)aPriceFlag {
    NSMutableDictionary* tmpDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [tmpDataDict setObject:aCellType forKey:@"CellType"];
    [tmpDataDict setObject:aFieldName forKey:@"FieldName"];
    [tmpDataDict setObject:aFieldData forKey:@"FieldData"];
    [tmpDataDict setObject:aPriceFlag forKey:@"PriceFlag"];
    
    return tmpDataDict;
}

- (void)updateDataWithData:(NSString*)aData forIndexPath:(NSIndexPath*)theIndexPath {
    NSMutableDictionary* auxDataDict = [self.displayList objectAtIndex:theIndexPath.row];
    [auxDataDict setObject:aData forKey:@"FieldData"];
}

@end
