//
//  ReportProductCell.m
//  Arcos
//
//  Created by David Kilmartin on 24/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ReportProductCell.h"

@implementation ReportProductCell
@synthesize  code;
@synthesize  description;
@synthesize  EAN;
@synthesize  catalog;
@synthesize  active;
@synthesize  lastorderdate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSMutableDictionary *)data{
    
}
-(void)setDataXML:(CXMLElement*)element{
    NSMutableDictionary* elementDict=[[[NSMutableDictionary alloc]init]autorelease];
    for (int i=0; i<element.childCount; i++) {
        
        if (![[element childAtIndex:i].name isEqualToString:@"text"]&&[[element childAtIndex:i]stringValue]!=nil) {
            //NSLog(@"child name:%@  %d  child value:%@  %d",[element childAtIndex:i].name,[[element childAtIndex:i].name length],[[element childAtIndex:i]stringValue],[[[element childAtIndex:i]stringValue]length]);
            
            [elementDict setObject:[[element childAtIndex:i]stringValue] forKey:[element childAtIndex:i].name];
        }
    }
    
    self.code.text=[elementDict objectForKey:@"Code"];
    self.description.text=[elementDict objectForKey:@"Description"];
    self.catalog.text=[elementDict objectForKey:@"Catalog_x0020_Code"];
    self.EAN.text=[elementDict objectForKey:@"EAN"];
    self.active.text=[elementDict objectForKey:@"Active"];
    
    NSString* deliveryString=[elementDict objectForKey:@"LastOrderDate"];
    self.lastorderdate.text=[deliveryString substringWithRange:NSMakeRange(0, 10)];
    

}

-(void)dealloc{
    if (self.code != nil) { self.code = nil; }
    if (self.description != nil) { self.description = nil; }
    if (self.EAN != nil) { self.EAN = nil; }
    if (self.catalog != nil) { self.catalog = nil; }
    if (self.active != nil) { self.active = nil; }
    if (self.lastorderdate != nil) { self.lastorderdate = nil; }
    
    
    [super dealloc];
}
@end
