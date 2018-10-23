//
//  CheckoutPrinterWrapperDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 24/08/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CheckoutPrinterWrapperDataManager.h"
#import "ArcosLineSegment.h"

@implementation CheckoutPrinterWrapperDataManager
@synthesize fieldDelimiter = _fieldDelimiter;

- (instancetype)init{
    self = [super init];
    if (self != nil) {
        self.fieldDelimiter = @";";
    }
    return self;
}

- (void)dealloc {
    self.fieldDelimiter = nil;
    
    [super dealloc];
}

- (void)saveSignatureWithOrderNumber:(NSNumber*)anOrderNumber dataList:(NSMutableArray*)aDataList {
    if ([aDataList count] == 0) return;
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"OrderNumber = %@", anOrderNumber];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectArray count] > 0) {
        for (OrderHeader* anOrderHeader in objectArray) {
            NSString* signatureString = @"";
            NSMutableArray* signatureList = [NSMutableArray arrayWithCapacity:[aDataList count]];
            for (int i = 0; i < [aDataList count]; i++) {
                ArcosLineSegment* arcosLineSegment = [aDataList objectAtIndex:i];
                [signatureList addObject:[NSString stringWithFormat:@"%1.1f,%1.1f,%1.1f,%1.1f", arcosLineSegment.start.x, arcosLineSegment.start.y, arcosLineSegment.end.x, arcosLineSegment.end.y]];
            }
            signatureString = [signatureList componentsJoinedByString:self.fieldDelimiter];
            anOrderHeader.DeliveryInstructions2 = signatureString;
            [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
        }
    }
}

- (NSMutableArray*)retrieveDataList:(NSNumber*)anOrderNumber {
    NSMutableArray* resultList = [NSMutableArray array];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"OrderNumber = %@", anOrderNumber];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    if ([objectArray count] > 0) {
        NSDictionary* auxOrderHeaderDict = [objectArray objectAtIndex:0];
        NSString* deliveryInstructions2 = [auxOrderHeaderDict objectForKey:@"DeliveryInstructions2"];
        if (deliveryInstructions2 != nil) {
            NSArray* lineList = [deliveryInstructions2 componentsSeparatedByString:self.fieldDelimiter];
            for (int i = 0; i < [lineList count]; i++) {
                NSString* aLine = [lineList objectAtIndex:i];
                NSArray* pointList = [aLine componentsSeparatedByString:@","];
                if ([pointList count] > 3) {
                    ArcosLineSegment* arcosLineSegment = [[ArcosLineSegment alloc] init:CGPointMake([[ArcosUtils convertStringToFloatNumber:[pointList objectAtIndex:0]] floatValue], [[ArcosUtils convertStringToFloatNumber:[pointList objectAtIndex:1]] floatValue]) withEnd:CGPointMake([[ArcosUtils convertStringToFloatNumber:[pointList objectAtIndex:2]] floatValue], [[ArcosUtils convertStringToFloatNumber:[pointList objectAtIndex:3]] floatValue])];
                    [resultList addObject:arcosLineSegment];
                    [arcosLineSegment release];
                }
            }
        }
    }
    return resultList;
}

@end
