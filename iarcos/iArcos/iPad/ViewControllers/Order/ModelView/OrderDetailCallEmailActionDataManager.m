//
//  OrderDetailCallEmailActionDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 29/01/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "OrderDetailCallEmailActionDataManager.h"

@implementation OrderDetailCallEmailActionDataManager
@synthesize orderHeader = _orderHeader;
@synthesize callEmailProcessCenter = _callEmailProcessCenter;

- (id)initWithOrderHeader:(NSMutableDictionary*)anOrderHeader {
    self = [super init];
    if (self != nil) {
        self.orderHeader = anOrderHeader;
        self.callEmailProcessCenter = [[[CallEmailProcessCenter alloc] initWithOrderHeader:anOrderHeader] autorelease];
    }
    return self;
}
- (void)dealloc {
    if (self.orderHeader != nil) { self.orderHeader = nil; }
    if (self.callEmailProcessCenter != nil) { self.callEmailProcessCenter = nil; }
    
    [super dealloc];
}

#pragma mark - OrderDetailEmailActionDelegate
- (NSMutableDictionary*)didSelectEmailRecipientRowWithCellData:(NSDictionary*)aCellData taskData:(NSMutableArray*)aTaskObjectList {
    NSMutableDictionary* mailDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [mailDict setObject:[NSString stringWithFormat:@"Call made by %@", [self.orderHeader objectForKey:@"Employee"]] forKey:@"Subject"];
    [mailDict setObject:[self.callEmailProcessCenter buildCallEmailMessageWithController:aTaskObjectList] forKey:@"Body"];
    return mailDict;
}

- (NSString*)retrieveFileName {
    return @"";
}
- (NSString*)retrieveCsvFileName {
    return @"";
}
/*
- (void)didSelectEmailRecipientRow:(MFMailComposeViewController*)aMailController cellData:(NSDictionary*)aCellData {
    [aMailController setToRecipients:[NSArray arrayWithObjects:[aCellData objectForKey:@"Email"] , nil]];
    [aMailController setSubject:[NSString stringWithFormat:@"%@ Call made by %@", [self.callEmailProcessCenter companyName], [self.callEmailProcessCenter employeeName]]];    
    [self.callEmailProcessCenter buildCallEmailMessageWithController:aMailController];
}

- (void)emailButtonPressed:(MFMailComposeViewController*)aMailController {
    NSLog(@"OrderDetailCallEmailActionDataManager");
    NSNumber *locationIUR = [self.orderHeader objectForKey:@"LocationIUR"];
    
    NSMutableDictionary* locationDict = [[[ArcosCoreData sharedArcosCoreData]locationWithIUR:locationIUR]objectAtIndex:0];
    NSString* locationEmail = [locationDict objectForKey:@"Email"];
    if (locationEmail != nil) {
        [aMailController setToRecipients:[NSArray arrayWithObjects:locationEmail, nil]]; 
    }
    [aMailController setSubject:[NSString stringWithFormat:@"Call made by %@ on %@ to %@", [self.callEmailProcessCenter employeeName], [self.orderHeader objectForKey:@"orderDateText"], [self.orderHeader objectForKey:@"contactText"]]];
    [self.callEmailProcessCenter buildCallEmailMessageWithController:aMailController];
}

- (void)wholesalerEmailButtonPressed:(MFMailComposeViewController*)aMailController  {
    
}

- (void)contactEmailButtonPressed:(MFMailComposeViewController*)aMailController  {
    if ([self.orderHeader objectForKey:@"contactText"] != @"None") {
        NSMutableDictionary* contactDict = [self.orderHeader objectForKey:@"contact"];
        NSString* contactEmail = [contactDict objectForKey:@"Email"];               
        if (contactEmail != nil) {
            NSArray *toRecipients = [NSArray arrayWithObjects:contactEmail, nil];
            [aMailController setToRecipients:toRecipients]; 
        }
        
    }
    [aMailController setSubject:[NSString stringWithFormat:@"Call made by %@ on %@ to %@", [self.callEmailProcessCenter employeeName], [self.orderHeader objectForKey:@"orderDateText"], [self.orderHeader objectForKey:@"contactText"]]];
    [self.callEmailProcessCenter buildCallEmailMessageWithController:aMailController];
}
*/

@end
