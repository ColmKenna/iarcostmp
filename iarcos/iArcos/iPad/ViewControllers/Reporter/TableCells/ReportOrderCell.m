//
//  ReportOrderCell.m
//  Arcos
//
//  Created by David Kilmartin on 24/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ReportOrderCell.h"
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"

@implementation ReportOrderCell
@synthesize  name;
@synthesize  address;
@synthesize  type;
@synthesize  value;
@synthesize  orderDate;
@synthesize  employee;
@synthesize deliveryDate;
@synthesize goodsLabel = _goodsLabel;
@synthesize vatLabel = _vatLabel;

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
            
            [elementDict setObject:[[element childAtIndex:i]stringValue] forKey:[element childAtIndex:i].name];
        }
        
    }
    */
    
    self.name.text=[elementDict objectForKey:@"Name"];
    self.address.text=[elementDict objectForKey:@"Address"];
    self.type.text=[elementDict objectForKey:@"CustomerRef"];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showTotalVATInvoiceFlag]) {
        self.goodsLabel.hidden = NO;
        self.vatLabel.hidden = NO;
        self.goodsLabel.text = [ArcosUtils convertToFloatString:[elementDict objectForKey:@"Value"]];
        self.vatLabel.text = [ArcosUtils convertToFloatString:[elementDict objectForKey:@"TotalVat"]];
        NSNumber* goodsNumber = [ArcosUtils convertStringToFloatNumber:[ArcosUtils convertBlankToZero:[ArcosUtils convertNilToEmpty:[elementDict objectForKey:@"Value"]]]];
        NSNumber* vatNumber = [ArcosUtils convertStringToFloatNumber:[ArcosUtils convertBlankToZero:[ArcosUtils convertNilToEmpty:[elementDict objectForKey:@"TotalVat"]]]];
        self.value.text = [NSString stringWithFormat:@"%1.2f", ([goodsNumber floatValue] + [vatNumber floatValue])];
    } else {
        self.goodsLabel.hidden = YES;
        self.vatLabel.hidden = YES;
        self.value.text = [ArcosUtils convertToFloatString:[elementDict objectForKey:@"Value"]];
    }
    
    
    NSString* orderDateString=[elementDict objectForKey:@"Date"];
    NSString* deliveryDateString=[elementDict objectForKey:@"DeliveryDate"];
    NSString* orderDateStringTen = [orderDateString substringWithRange:NSMakeRange(0, 10)];
    NSString* deliveryDateStringTen = [deliveryDateString substringWithRange:NSMakeRange(0, 10)];
    NSDate* orderDateObj = [ArcosUtils dateFromString:orderDateStringTen format:@"yyyy-MM-dd"];
    NSDate* deliveryDateObj = [ArcosUtils dateFromString:deliveryDateStringTen format:@"yyyy-MM-dd"];
    self.orderDate.text = [ArcosUtils stringFromDate:orderDateObj format:[GlobalSharedClass shared].dateFormat];
    self.deliveryDate.text = [ArcosUtils stringFromDate:deliveryDateObj format:[GlobalSharedClass shared].dateFormat];

    self.employee.text=[elementDict objectForKey:@"Employee"];
    
}
-(void)dealloc{    
    if (self.name!=nil) {
        self.name=nil;
    }
    if (self.address!=nil) {
        self.address=nil;
    }
    if (self.type!=nil) {
        self.type=nil;
    }
    if (self.value!=nil) {
        self.value=nil;
    }
    if (self.orderDate!=nil) {
        self.orderDate=nil;
    }
    if (self.employee!=nil) {
        self.employee=nil;
    }
    if (self.deliveryDate != nil) {
        self.deliveryDate = nil;
    }
    self.goodsLabel = nil;
    self.vatLabel = nil;
    [super dealloc];
}
@end
