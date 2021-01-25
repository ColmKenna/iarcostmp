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

- (instancetype)init {
    self = [super init];
    if (self) {
        self.displayList = [NSMutableArray array];
        self.qtyShowFlag = NO;
        self.valueShowFlag = NO;
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
    for (CXMLElement* element in subList) {
        NSMutableDictionary* elementDict = [NSMutableDictionary dictionary];
        for (int i = 0; i < element.childCount; i++) {
            if (![[element childAtIndex:i].name isEqualToString:@"text"]) {
                [elementDict setObject:[[element childAtIndex:i] stringValue] forKey:[element childAtIndex:i].name];
            }
        }
        
        NSString* subTitleString = [NSString stringWithFormat:@"%@",[elementDict objectForKey:@"Details"]];
        [elementDict setObject:subTitleString forKey:@"Title"];
        NSNumber* qtyNumber = [ArcosUtils convertStringToNumber:[elementDict objectForKey:@"Qty"]];
        NSNumber* valueNumber = [ArcosUtils convertStringToFloatNumber:[elementDict objectForKey:@"Value"]];
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
