//
//  ReportContactCell.m
//  Arcos
//
//  Created by David Kilmartin on 24/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ReportContactCell.h"

@implementation ReportContactCell
@synthesize name;
@synthesize address;
@synthesize type;
@synthesize phoneNumber;
@synthesize mobileNumber;
@synthesize lastCall;

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
    NSMutableDictionary* elementDict=[[[NSMutableDictionary alloc]init]autorelease];
    for (int i=0; i<element.childCount; i++) {
        
        if (![[element childAtIndex:i].name isEqualToString:@"text"]&&[[element childAtIndex:i]stringValue]!=nil) {
            //NSLog(@"child name:%@  %d  child value:%@  %d",[element childAtIndex:i].name,[[element childAtIndex:i].name length],[[element childAtIndex:i]stringValue],[[[element childAtIndex:i]stringValue]length]);
            
            [elementDict setObject:[[element childAtIndex:i]stringValue] forKey:[element childAtIndex:i].name];
        }
        
    }
    
    
    self.name.text=[NSString stringWithFormat:@"%@ %@", [elementDict objectForKey:@"Forename"],[elementDict objectForKey:@"Surname"]];
    self.address.text=[elementDict objectForKey:@"Address"];
    self.type.text=[elementDict objectForKey:@"Type"];
    self.phoneNumber.text=[elementDict objectForKey:@"PhoneNumber"];
    self.mobileNumber.text=[elementDict objectForKey:@"MobileNumber"];

    NSString* lastCallString=[elementDict objectForKey:@"Last_x0020_Call"];
    
    self.lastCall.text=[lastCallString substringWithRange:NSMakeRange(0, 10)];
    

}

-(void)dealloc{
    if (self.name != nil) {self.name = nil; }
    if (self.address != nil) {self.address = nil; }
    if (self.type != nil) {self.type = nil; }
    if (self.phoneNumber != nil) {self.phoneNumber = nil; }
    if (self.mobileNumber != nil) {self.mobileNumber = nil; }
    if (self.lastCall != nil) {self.lastCall = nil; }
    
    [super dealloc];
}
@end
