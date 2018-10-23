//
//  ArcosXMLParser.m
//  Arcos
//
//  Created by David Kilmartin on 12/06/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ArcosXMLParser.h"
#import "CXMLDocument.h"
#import "Soap.h"

@implementation ArcosXMLParser



+ (id)doXMLParse:(NSString*)aFileName deserializeTo:(id)aDeserializeTo {
    NSString* path = [[NSBundle mainBundle] pathForResource:aFileName ofType:@"xml"];
    NSData* data = [[NSData alloc] initWithContentsOfFile:path];
    NSError* error = nil;
    CXMLDocument* doc = [[CXMLDocument alloc] initWithData: data options: 0 error: &error];
    
    CXMLNode* element = [[Soap getNode: [doc rootElement] withName: @"Body"] childAtIndex:0];
    id output = nil;
    if(aDeserializeTo == nil) {
        output = [Soap deserialize:element];
    } else {
        if([aDeserializeTo respondsToSelector: @selector(initWithNode:)]) {
//            NSLog(@"first branch is executed.");
            element = [element childAtIndex:0];
            output = [aDeserializeTo initWithNode: element];
        } else {
            NSLog(@"second branch is executed.");
            NSString* value = [[[element childAtIndex:0] childAtIndex:0] stringValue];
            output = [Soap convert: value toType: aDeserializeTo];
        }
    }
//    NSLog(@"output %@", output);
    [data release];
    data = nil;
    [doc release];
    doc = nil;
    return output;
}

@end
