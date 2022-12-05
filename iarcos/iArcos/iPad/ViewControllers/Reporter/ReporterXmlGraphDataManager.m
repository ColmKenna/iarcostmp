//
//  ReporterXmlGraphDataManager.m
//  iArcos
//
//  Created by Richard on 25/01/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import "ReporterXmlGraphDataManager.h"

@implementation ReporterXmlGraphDataManager
@synthesize displayList = _displayList;
@synthesize reportDocument = _reportDocument;
@synthesize identifier = _identifier;
@synthesize actualBarCount = _actualBarCount;
@synthesize maxNormalBarCount = _maxNormalBarCount;
@synthesize arrayCountBiggerThanMaxNornalBarCountFlag = _arrayCountBiggerThanMaxNornalBarCountFlag;
@synthesize processedDisplayList = _processedDisplayList;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.displayList = [NSMutableArray array];
        self.identifier = @"barIdentifier";
        self.maxNormalBarCount = 10;
        self.arrayCountBiggerThanMaxNornalBarCountFlag = NO;
    }
    return self;
}

- (void)dealloc {
    self.displayList = nil;
    self.reportDocument = nil;
    self.identifier = nil;
    self.processedDisplayList = nil;
    
    [super dealloc];
}

- (void)processRawData:(CXMLDocument*)aReportDocument {
    self.reportDocument = aReportDocument;
    NSMutableArray* subList = [[[self.reportDocument nodesForXPath:@"//Sub" error:nil] mutableCopy] autorelease];
    NSMutableArray* rawDisplayList = [NSMutableArray arrayWithCapacity:[subList count]];
    self.displayList = [NSMutableArray arrayWithCapacity:[subList count]];
    float totalCount = 0.0;
    for (CXMLElement* element in subList) {
        NSMutableDictionary* elementDict = [NSMutableDictionary dictionary];
        for (int i = 0; i < element.childCount; i++) {
            if (![[element childAtIndex:i].name isEqualToString:@"text"]) {
                [elementDict setObject:[[element childAtIndex:i] stringValue] forKey:[element childAtIndex:i].name];
            }
        }
        totalCount += [[ArcosUtils convertStringToNumber:[elementDict objectForKey:@"Count"]] floatValue];

        [rawDisplayList addObject:elementDict];
    }
    
    for (int i = 0; i < [rawDisplayList count]; i++) {
        NSMutableDictionary* auxElementDict = [rawDisplayList objectAtIndex:i];
        NSMutableDictionary* myDict = [NSMutableDictionary dictionaryWithDictionary:auxElementDict];
        NSNumber* tmpCount = [ArcosUtils convertStringToNumber:[myDict objectForKey:@"Count"]];
        float tmpCountPercentage = 0;
        if (totalCount == 0) {
            tmpCountPercentage = 100;
        } else {
            tmpCountPercentage = [tmpCount floatValue] / totalCount * 100;
        }
        [myDict setObject:[NSNumber numberWithFloat:tmpCountPercentage] forKey:@"Percentage"];
        [self.displayList addObject:myDict];
    }
    
    NSSortDescriptor* percentageDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Percentage" ascending:NO selector:@selector(compare:)] autorelease];
    [self.displayList sortUsingDescriptors:[NSArray arrayWithObjects:percentageDescriptor, nil]];
    int auxArrayCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.displayList count]];
    int auxCompositeResultListCount = auxArrayCount;
    self.actualBarCount = auxArrayCount;
    self.arrayCountBiggerThanMaxNornalBarCountFlag = NO;
    if (auxArrayCount > self.maxNormalBarCount) {
        auxArrayCount = self.maxNormalBarCount;
        self.arrayCountBiggerThanMaxNornalBarCountFlag = YES;
        auxCompositeResultListCount = auxArrayCount + 1;
        self.actualBarCount = auxArrayCount + 1;
    }
    float otherTotalPercentage = 0.0;
    if (self.arrayCountBiggerThanMaxNornalBarCountFlag) {
        for (int i = self.maxNormalBarCount; i < [self.displayList count]; i++) {
            NSMutableDictionary* tmpFinalResultDict = [self.displayList objectAtIndex:i];
            otherTotalPercentage += [[tmpFinalResultDict objectForKey:@"Percentage"] floatValue];
        }
    }
    NSMutableArray* auxCompositeResultList = [NSMutableArray arrayWithCapacity:auxCompositeResultListCount];
    for (int i = 0; i < auxArrayCount; i++) {
        [auxCompositeResultList addObject:[self.displayList objectAtIndex:i]];
    }
    if (self.arrayCountBiggerThanMaxNornalBarCountFlag) {
        NSMutableDictionary* otherResultDict = [NSMutableDictionary dictionaryWithCapacity:2];
        [otherResultDict setObject:@"Other" forKey:@"Details"];
        [otherResultDict setObject:[NSNumber numberWithFloat:otherTotalPercentage] forKey:@"Percentage"];
        [auxCompositeResultList addObject:otherResultDict];
    }
    
    self.processedDisplayList = [NSMutableArray arrayWithArray:auxCompositeResultList];
}

@end
