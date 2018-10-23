//
//  ReportParser.m
//  Arcos
//
//  Created by David Kilmartin on 13/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ReportParser.h"

@implementation ReportParser
@synthesize delegate;

-(id)init{
    self=[super init];
    if (self!=nil) {
        firstRow=YES;
        theAttributes=[[NSMutableArray alloc]init];
        attributeTypes=[[NSMutableArray alloc]init];
        rowData=[[NSMutableDictionary alloc]init];
        currentElement=@"";
    }
    return self;
}

-(id)initWithURL:(NSURL*)aUrl{
    self=[self init];
    
    if (self!=nil) {
        theParser=[[NSXMLParser alloc]initWithContentsOfURL:aUrl];
        [theParser setDelegate:self];
        [theParser setShouldResolveExternalEntities:YES];
    }
    return self;
}
-(void)start{
    [theParser parse];
}
-(void)startWithURL:(NSURL*)aUrl{
    if (theParser!=nil) {
        [theParser abortParsing];
        [theParser release];
        theParser=nil;
    }
    
    theParser=[[NSXMLParser alloc]initWithContentsOfURL:aUrl];
    [theParser setDelegate:self];
    [theParser setShouldResolveExternalEntities:YES];
    [theParser parse];
}

#pragma parser delegate
// Document handling methods
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"start document parsing");
    [self.delegate startParse];
}
// sent when the parser begins parsing of the document.
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"end document parsing");
    [self.delegate endParse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    //parse view
    if ([elementName isEqualToString:@"Main_x0020_View"]){
        
        

    }else {
        if (firstRow&&![elementName isEqualToString:@"NewDataSet"]) {
            [theAttributes addObject:elementName];
            [attributeTypes addObject:@"NSString"];
        }
        //NSLog(@"attribut found -- %@",elementName);
        if (![elementName isEqualToString:@"NewDataSet"]) {
            currentElement=elementName;
        }
    }
    
    //parse subtotal
    
    if ([elementName isEqualToString:@"SubTotals"]) {
        
        [parser abortParsing];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return;
    }
    string=[string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]]; 
    if ([string length]<=0) {
        return;
    }
    
    if ([rowData objectForKey:currentElement]!=nil) {
        string=[string stringByAppendingString:[rowData objectForKey:currentElement]];
    }else {
        [rowData setObject:string forKey:currentElement];
    }
    //NSLog(@"found char ---- %@ length %d  for %@",string,string.length,currentElement);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if (([elementName isEqualToString:@"Main_x0020_View"])){
         //NSLog(@"main view end");
        if (firstRow) {
            firstRow=NO;
            NSLog(@"first attribut--%@",theAttributes);
            [self.delegate attributesFound:theAttributes types:attributeTypes];
        }
        NSLog(@"row data %@",rowData);
        [self.delegate rowFound:rowData];
        
        [rowData removeAllObjects];
    }
}

-(void)dealloc{
    if (theParser!=nil) {
        [theParser release];
    }
    [theAttributes release];
    [attributeTypes release];
    [rowData release];
    self.delegate=nil;
    
    [super dealloc];
}
@end
