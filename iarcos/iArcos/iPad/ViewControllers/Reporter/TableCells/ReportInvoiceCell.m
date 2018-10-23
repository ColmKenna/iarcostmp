//
//  ReportInvoiceCell.m
//  Arcos
//
//  Created by David Kilmartin on 24/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ReportInvoiceCell.h"
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"

@implementation ReportInvoiceCell
@synthesize  name;
@synthesize  address;
@synthesize  type;
@synthesize  value;
@synthesize  customerRef;
@synthesize  employee;
@synthesize  date;
@synthesize  wholesaler;
@synthesize details;

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
    
    
    self.name.text=[elementDict objectForKey:@"Location"];
    self.address.text=[elementDict objectForKey:@"Address"];
    self.customerRef.text=[elementDict objectForKey:@"CustomerRef"];
    self.value.text=[ArcosUtils convertToFloatString:[elementDict objectForKey:@"TotalGoods"]];
    self.employee.text=[elementDict objectForKey:@"Employee"];
    self.wholesaler.text=[elementDict objectForKey:@"Wholesaler"];
    self.details.text = [elementDict objectForKey:@"Details"];
    
    NSString* deliveryString=[elementDict objectForKey:@"Date"];
    deliveryString = [deliveryString substringWithRange:NSMakeRange(0, 10)];
    NSDate* deliveryDateObj = [ArcosUtils convertDatetimeStringToDate:deliveryString];
    self.date.text = [ArcosUtils stringFromDate:deliveryDateObj format:[GlobalSharedClass shared].dateFormat];
//    self.date.text=[deliveryString substringWithRange:NSMakeRange(0, 10)];
    
}

-(void)dealloc{
    if (self.name != nil) { self.name = nil; }
    if (self.address != nil) { self.address = nil; }
    if (self.value != nil) { self.value = nil; }
    if (self.customerRef != nil) { self.customerRef = nil; }
    if (self.employee != nil) { self.employee = nil; }
    if (self.date != nil) { self.date = nil; }
    if (self.wholesaler != nil) { self.wholesaler = nil; }
    if (self.details != nil) { self.details = nil; }    
    
    [super dealloc];
}
@end
