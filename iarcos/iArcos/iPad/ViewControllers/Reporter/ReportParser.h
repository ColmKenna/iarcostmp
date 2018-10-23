//
//  ReportParser.h
//  Arcos
//
//  Created by David Kilmartin on 13/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ReportParserDelegate
-(void)startParse;
-(void)attributesFound:(NSArray*)attributArray types:(NSArray*)attributeTypes;
-(void)rowFound:(NSMutableDictionary*)row;
-(void)endParse;
-(void)allRows:(NSMutableArray*)rows;
-(void)errorFound:(NSError*)error;
@end

@interface ReportParser : NSObject<NSXMLParserDelegate>{
    NSXMLParser* theParser;
    BOOL firstRow;
    NSMutableArray* theAttributes;
    NSMutableArray* attributeTypes;
    NSMutableDictionary* rowData;
    
    NSString* currentElement;
    
    id<ReportParserDelegate> delegate;
}
@property(nonatomic,retain)    id<ReportParserDelegate> delegate;

-(id)init;
-(id)initWithURL:(NSURL*)aUrl;
-(void)start;
-(void)startWithURL:(NSURL*)aUrl;
@end
