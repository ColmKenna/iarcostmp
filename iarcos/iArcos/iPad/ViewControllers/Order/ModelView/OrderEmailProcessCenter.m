//
//  OrderEmailProcessCenter.m
//  Arcos
//
//  Created by David Kilmartin on 31/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "OrderEmailProcessCenter.h"

@implementation OrderEmailProcessCenter
@synthesize orderHeader = _orderHeader;
@synthesize orderLines = _orderLines;


-(id)initWithOrderHeader:(NSMutableDictionary*)anOrderHeader{
    self = [super init];
    if (self != nil) {
        self.orderHeader = anOrderHeader;
    }
    return self;
}

-(void)dealloc {
    if (self.orderHeader != nil) { self.orderHeader = nil; }
    self.orderLines = nil;
    
    [super dealloc];
}

-(NSString*)buildEmailMessageWithController {
//    NSLog(@"OrderEmailProcessCenter:%@", self.orderHeader);
//    NSMutableArray* orderLines = nil;
    NSNumber* coordinateType = [self.orderHeader objectForKey:@"CoordinateType"];
    if ([coordinateType intValue] == 0) {
        self.orderLines = [[ArcosCoreData sharedArcosCoreData]allOrderLinesWithOrderNumber:[self.orderHeader objectForKey:@"OrderNumber"] withSortKey:@"OrderLine" locationIUR:[self.orderHeader objectForKey:@"LocationIUR"] packageIUR:[self.orderHeader objectForKey:@"PosteedIUR"]];
    } else if ([coordinateType intValue] == 1) {
        self.orderLines = [self.orderHeader objectForKey:@"RemoteOrderline"];
    }
    
    NSMutableString *body = [NSMutableString string];
    BOOL exclusiveValueFlag = [[ArcosConfigDataManager sharedArcosConfigDataManager] excludeValueFromOrderEmailFlag];
    
    [body appendString:@"<html><body><table width='100%' height='100%'>"];
    
    //order header
    [body appendString:@"<tr><td width='100%' height='40'><table width='100%' height='100%'>"];
    
    [body appendString:@"<tr>"];
    [body appendString:@"<td width='60%'>"];
    [body appendString:[self.orderHeader objectForKey:@"CustName"]];    
    [body appendString:@"</td>"];
    [body appendString:@"<td width='20%' align='left'>"];
    [body appendString:@"Order Date:</td>"];
    [body appendString:@"<td width='20%'><b>"];
    [body appendString:[self.orderHeader objectForKey:@"orderDateText"]];    
    [body appendString:@"</b></td>"];
    [body appendString:@"</tr>"];
    
    [body appendString:@"<tr>"];
    [body appendString:@"<td width='60%'>"];
    [body appendString:[self.orderHeader objectForKey:@"Address1"]];
    [body appendString:@"</td>"];
    [body appendString:@"<td width='20%' align='left'>"];
    NSString* orderNumberTitle = @"Order Number";
    NSNumber* orderHeaderIUR = [self.orderHeader objectForKey:@"OrderHeaderIUR"];
    if (orderHeaderIUR != nil && [orderHeaderIUR intValue] == 0) {
        orderNumberTitle = @"Docket No.";
    }
    [body appendString:[NSString stringWithFormat:@"%@:</td>", orderNumberTitle]];
    [body appendString:@"<td width='20%'><b>"];
    NSNumber* docketIUR = [self.orderHeader objectForKey:@"DocketIUR"];
    NSNumber* theOrderNumber = [self.orderHeader objectForKey:@"OrderNumber"];
    if ([docketIUR intValue]>0) {
        [body appendString:[docketIUR stringValue]];
    }else {
        [body appendString:[theOrderNumber stringValue]];
    }
        
    [body appendString:@"</b></td>"];
    [body appendString:@"</tr>"];
    
    [body appendString:@"<tr>"];
    [body appendString:@"<td width='60%'>"];
    [body appendString:[self.orderHeader objectForKey:@"Address2"]];
    [body appendString:@"</td>"];    
    [body appendString:@"<td width='20%' align='left'>"];
    [body appendString:@"Reference:</td>"];
    [body appendString:@"<td width='20%'><b>"];
    [body appendString:[self.orderHeader objectForKey:@"custRef"]];    
    [body appendString:@"</b></td>"];
    [body appendString:@"</tr>"];
    
    [body appendString:@"<tr>"];
    [body appendString:@"<td width='60%'>"];
    [body appendString:[self.orderHeader objectForKey:@"Address3"]];
    [body appendString:@"</td>"];    
    [body appendString:@"<td width='20%' align='left'>"];
    [body appendString:@"Location Code:</td>"];
    [body appendString:@"<td width='20%'><b>"];
    [body appendString:[ArcosUtils convertNilToEmpty:[self.orderHeader objectForKey:@"LocationCode"]]];
    [body appendString:@"</b></td>"];
    [body appendString:@"</tr>"];
    
    [body appendString:@"<tr>"];
    [body appendString:@"<td width='60%'>"];
    [body appendString:[self.orderHeader objectForKey:@"Address4"]];
    [body appendString:@"</td>"];    
    [body appendString:@"<td width='20%' align='left'>"];
    [body appendString:@"Contact:</td>"];
    [body appendString:@"<td width='20%'><b>"];
    [body appendString:[ArcosUtils convertUnAssignedToBlank:[ArcosUtils convertNilToEmpty:[self.orderHeader objectForKey:@"contactText"]]]];
    [body appendString:@"</b></td>"];
    [body appendString:@"</tr>"];
    
    
    [body appendString:@"</table></td></tr>"];
    
    [body appendString:@"<tr><td height='30' width='100%'><table width='100%' height='100%'>"];
    [body appendString:@"<tr><td colspan='6' width='100%'><hr></td></tr>"];
    [body appendString:@"<tr>"];
    [body appendString:@"<td width='7%'>QTY</td>"];
    [body appendString:@"<td width='7%'>BON</td>"];
    [body appendString:@"<td width='10%'>CODE</td>"];
    [body appendString:@"<td width='8%'>DISC%</td>"];
    [body appendString:@"<td width='58%'>DETAILS</td>"];
    NSString* valueTitleStr = @"";
    if (!exclusiveValueFlag) {
        valueTitleStr = @"VALUE";
    }
    [body appendString:@"<td width='10%' align='right'>"];
    [body appendString:valueTitleStr];
    [body appendString:@"</td>"];
    [body appendString:@"</tr>"];    
    [body appendString:@"<tr><td colspan='6' width='100%'><hr></td></tr>"];
    [body appendString:@"</table></td></tr>"];
    
    [body appendString:@"<tr><td height='30' width='100%'><table width='100%' height='100%' style='table-layout:fixed'>"];
    int totalQty = 0;
    int totalBonus = 0;
    for(NSMutableDictionary* aDict in self.orderLines) {
        totalQty += [[aDict objectForKey:@"Qty"] intValue];
        totalBonus += [[aDict objectForKey:@"Bonus"] intValue];
        NSString* qtyString = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%@", [aDict objectForKey:@"Qty"]]];
        NSString* instockString = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%@", [aDict objectForKey:@"units"]]];
        NSString* bonusString = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%@",[aDict objectForKey:@"Bonus"]]];
        NSString* focString = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%@", [aDict objectForKey:@"FOC"]]];
        if (![instockString isEqualToString:@""]) {
            qtyString = [NSString stringWithFormat:@"%@/%@",qtyString,instockString];
        }
        if (![focString isEqualToString:@""]) {
            bonusString = [NSString stringWithFormat:@"%@/%@",bonusString,focString];
        }
        if ([[aDict objectForKey:@"StockAvailable"] intValue] == 0) {
            [body appendString:@"<tr style='color:#FF0000;'>"];
        } else {
            [body appendString:@"<tr style='color:#000000;'>"];
        }
        [body appendString:@"<td width='7%'>"];
        [body appendString:qtyString];
        [body appendString:@"</td>"];
        [body appendString:@"<td width='7%'>"];
        [body appendString:bonusString];
        [body appendString:@"</td>"];
        [body appendString:@"<td width='10%' style='word-wrap:break-word'>"];
        [body appendString:[NSString stringWithFormat:@"%@",[aDict objectForKey:@"ProductCode"]]];
        [body appendString:@"</td>"];        
        [body appendString:@"<td width='8%'>"];
        [body appendString:[ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%@",[aDict objectForKey:@"DiscountPercent"]]]];
        [body appendString:@"</td>"];
        [body appendString:@"<td width='58%'>"];
        [body appendString:[NSString stringWithFormat:@"%@ %@ %@",[aDict objectForKey:@"Description"], [aDict objectForKey:@"ProductSize"], [aDict objectForKey:@"EAN"]]];
        [body appendString:@"</td>"];
        [body appendString:@"<td width='10%' align='right'>"];
        if (!exclusiveValueFlag) {
            [body appendString:[NSString stringWithFormat:@"%1.2f",[[aDict objectForKey:@"LineValue"] floatValue]]];
        }
        [body appendString:@"</td>"];    
        [body appendString:@"</tr>"];
        
    }
    [body appendString:@"</table></td></tr>"];
    
    
    [body appendString:@"<tr><td height='100%' width='100%'><table width='100%' height='100%'>"];
    
    
    [body appendString:@"</table></td></tr>"];
    
    [body appendString:@"<tr><td height='30' width='100%'><table width='100%' height='100%'>"];
    [body appendString:@"<tr><td width='100%' colspan='6'><hr></td></tr>"];
    [body appendString:@"<tr>"];
    [body appendString:@"<td width='7%'>"];
    [body appendString:[ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", totalQty]]];        
    [body appendString:@"</td>"];
    [body appendString:@"<td width='7%'>"];
    [body appendString:[ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", totalBonus]]];        
    [body appendString:@"</td>"];
    [body appendString:@"<td width='66%' colspan='3'>DELIVERY BY: <b>"];
    NSDictionary* wholesalerDict = [self.orderHeader objectForKey:@"wholesaler"];
    //[self.orderHeader objectForKey:@"wholesalerText"]
    [body appendString:[ArcosUtils convertNilToEmpty:[wholesalerDict objectForKey:@"Address4"]]];    
    [body appendString:@"</b></td>"];
    if (!exclusiveValueFlag) {
        [body appendString:@"<td width='20%' align='right'>TOTAL:   <b>"];
        NSString* totalValue = @"";
        if ([[self.orderHeader objectForKey:@"NumberOflines"]intValue]>0) {
            totalValue = [self.orderHeader objectForKey:@"totalGoodsText"];
        }else{
            totalValue = @"Call Only";
        }
        [body appendString:[NSString stringWithFormat:@" %@", totalValue]];
    } else {
        [body appendString:@"<td width='30%' align='right'><b>"];
    }
    
    [body appendString:@"</b></td></tr>"];
    [body appendString:@"</table></td></tr>"];
    
    [body appendString:@"</table></body></html>"];
//    [controller setMessageBody:body isHTML:YES];
	return body;
}

-(NSString*)employeeName{
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    return [NSString stringWithFormat:@"%@ %@", [employeeDict objectForKey:@"ForeName"], [employeeDict objectForKey:@"Surname"]];
}

-(NSString*)companyName {
    NSDictionary* configDict = [[ArcosCoreData sharedArcosCoreData] configWithIUR:[NSNumber numberWithInt:0]];
    return [configDict objectForKey:@"StandardLocationCode"];
}
/*
-(BOOL)checkCanSendMailStatus {
    if (![MFMailComposeViewController canSendMail]) {
//        UIAlertView *v = [[UIAlertView alloc] initWithTitle: @"No Mail Account" message: @"Please set up a Mail account in order to send email" delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil, nil];
//        [v show];
//        [v release];
        return NO;
    }
    return YES;
}*/

@end
