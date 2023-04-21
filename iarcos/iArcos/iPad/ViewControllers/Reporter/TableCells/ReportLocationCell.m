//
//  ReportLocationCell.m
//  Arcos
//
//  Created by David Kilmartin on 04/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//


#import "ReportLocationCell.h"

@implementation ReportLocationCell
@synthesize  name;
@synthesize  address;
@synthesize  county;
@synthesize  type;
@synthesize  lastCall;
@synthesize  lastOrderDate;
@synthesize  phoneNumber;

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
    NSMutableDictionary* elementDict = [self convertElementToDict:element];    
    /*
    for (int i=0; i<element.childCount; i++) {
        
        if (![[element childAtIndex:i].name isEqualToString:@"text"]&&[[element childAtIndex:i]stringValue]!=nil) {
            //NSLog(@"child name:%@  %d  child value:%@  %d",[element childAtIndex:i].name,[[element childAtIndex:i].name length],[[element childAtIndex:i]stringValue],[[[element childAtIndex:i]stringValue]length]);
            
            [elementDict setObject:[ArcosUtils convertNilToEmpty:[[element childAtIndex:i]stringValue]] forKey:[ArcosUtils convertNilToEmpty:[element childAtIndex:i].name]];
        }
        
    }
    */
    
    self.name.text=[elementDict objectForKey:@"Name"];
    self.address.text=[elementDict objectForKey:@"Address"];
    self.county.text=[elementDict objectForKey:@"County"];
    self.type.text=[elementDict objectForKey:@"Type"];
    
    NSString* lastCallDateString=[elementDict objectForKey:@"Last_x0020_Call"];
    NSString* lastOrderDateString=[elementDict objectForKey:@"LastOrderDate"];
    NSString* lastCallStr = [lastCallDateString substringWithRange:NSMakeRange(0, 10)];
    if (lastCallStr.length == 10) {
        self.lastCall.text = [self retrieveDate:lastCallStr];
    } else {
        self.lastCall.text = lastCallStr;
    }
    NSString* lastOrderDateStr = [lastOrderDateString substringWithRange:NSMakeRange(0, 10)];
    if (lastOrderDateStr.length == 10) {
        self.lastOrderDate.text = [self retrieveDate:lastOrderDateStr];
    } else {
        self.lastOrderDate.text = lastOrderDateStr;
    }
    self.phoneNumber.text=[elementDict objectForKey:@"PhoneNumber"];
    
}

-(void)dealloc{    
    if (self.name!=nil) {
        self.name=nil;
    }
    if (self.address!=nil) {
        self.address=nil;
    }
    if (self.county!=nil) {
        self.county=nil;
    }
    if (self.type!=nil) {
        self.type=nil;
    }
    if (self.lastCall!=nil) {
        self.lastCall=nil;
    }
    if (self.lastOrderDate!=nil) {
        self.lastOrderDate=nil;
    }
    if (self.phoneNumber!=nil) {
        self.phoneNumber=nil;
    }
    [super dealloc];
}
@end

