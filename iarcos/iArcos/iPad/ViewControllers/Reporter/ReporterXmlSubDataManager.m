//
//  ReporterXmlSubDataManager.m
//  iArcos
//
//  Created by Richard on 21/01/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import "ReporterXmlSubDataManager.h"

@implementation ReporterXmlSubDataManager
@synthesize displayList = _displayList;
@synthesize reportDocument = _reportDocument;
@synthesize qtyShowFlag = _qtyShowFlag;
@synthesize valueShowFlag = _valueShowFlag;
@synthesize countSum = _countSum;
@synthesize qtySum = _qtySum;
@synthesize valueSum = _valueSum;
@synthesize subTableRowPressed = _subTableRowPressed;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.displayList = [NSMutableArray array];
        self.qtyShowFlag = NO;
        self.valueShowFlag = NO;
        self.subTableRowPressed = NO;
    }
    return self;
}

- (void)dealloc {
    self.displayList = nil;
    self.reportDocument = nil;
    
    [super dealloc];
}

- (void)processRawData:(CXMLDocument*)aReportDocument {
    self.reportDocument = aReportDocument;
    NSMutableArray* subList = [[[self.reportDocument nodesForXPath:@"//Sub" error:nil] mutableCopy] autorelease];
    self.displayList = [NSMutableArray arrayWithCapacity:[subList count]];
    self.qtyShowFlag = NO;
    self.valueShowFlag = NO;
    self.countSum = 0;
    self.qtySum = 0;
    self.valueSum = 0.0f;
    for (CXMLElement* element in subList) {
        NSMutableDictionary* elementDict = [NSMutableDictionary dictionary];
        for (int i = 0; i < element.childCount; i++) {
            if (![[element childAtIndex:i].name isEqualToString:@"text"]) {
                [elementDict setObject:[ArcosUtils convertNilToEmpty:[[element childAtIndex:i] stringValue]] forKey:[ArcosUtils convertNilToEmpty:[element childAtIndex:i].name]];
            }
        }
        
        NSString* subTitleString = [NSString stringWithFormat:@"%@",[elementDict objectForKey:@"Details"]];
        [elementDict setObject:[ArcosUtils convertNilToEmpty:subTitleString] forKey:@"Title"];
        NSNumber* countNumber = [ArcosUtils convertStringToNumber:[elementDict objectForKey:@"Count"]];
        NSNumber* qtyNumber = [ArcosUtils convertStringToNumber:[elementDict objectForKey:@"Qty"]];
        NSNumber* valueNumber = [ArcosUtils convertStringToFloatNumber:[elementDict objectForKey:@"Value"]];
        self.countSum += [countNumber intValue];
        self.qtySum += [qtyNumber intValue];
        self.valueSum += [valueNumber floatValue];
        if ([qtyNumber intValue] != 0) {
            self.qtyShowFlag = YES;
        }
        if ([valueNumber floatValue] != 0) {
            self.valueShowFlag = YES;
        }

        [self.displayList addObject:elementDict];
    }
}

@end
