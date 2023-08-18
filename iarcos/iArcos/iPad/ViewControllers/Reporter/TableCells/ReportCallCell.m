//
//  ReportCallCell.m
//  Arcos
//
//  Created by David Kilmartin on 24/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ReportCallCell.h"
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"

@implementation ReportCallCell
@synthesize name;
@synthesize address;
@synthesize type;
@synthesize employee;
@synthesize callDate;
@synthesize value;

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
    self.type.text=[elementDict objectForKey:@"Type"];
    self.value.text=[ArcosUtils convertToFloatString:[elementDict objectForKey:@"Value"]];
    
    NSString* callDateString=[elementDict objectForKey:@"Date"];
    @try {
        NSString* callDateSubString = [callDateString substringWithRange:NSMakeRange(0, 10)];
        if ([callDateSubString isEqualToString:@"1990-01-01"]) {
            self.callDate.text = @"";
        } else {
            NSDate* callDateObject = [ArcosUtils dateFromString:[NSString stringWithFormat:@"%@ 12:00:00", callDateSubString] format:[[GlobalSharedClass shared] stdDateTimeFormat]];
            self.callDate.text = [ArcosUtils stringFromDate:callDateObject format:@"dd-MMM-yy"];
        }
    } @catch (NSException *exception) {
        [ArcosUtils showDialogBox:[exception reason] title:@"" delegate:nil target:[ArcosUtils getRootView] tag:0 handler:nil];
    }
//    self.callDate.text=[callDateString substringWithRange:NSMakeRange(0, 10)];
    
    self.employee.text=[elementDict objectForKey:@"Employee"];
    
}

-(void)dealloc{
    if (self.name != nil) { self.name = nil; }
    if (self.address != nil) { self.address = nil; }
    if (self.type != nil) { self.type = nil; }
    if (self.value != nil) { self.value = nil; }
    if (self.callDate != nil) { self.callDate = nil; }
    if (self.employee != nil) { self.employee = nil; }
    
    
    [super dealloc];
}

@end
