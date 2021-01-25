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

- (instancetype)init {
    self = [super init];
    if (self) {
        self.displayList = [NSMutableArray array];
        self.identifier = @"barIdentifier";
    }
    return self;
}

- (void)dealloc {
    self.displayList = nil;
    self.reportDocument = nil;
    self.identifier = nil;
    
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
}

@end
