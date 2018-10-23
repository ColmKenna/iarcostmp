//
//  CustomerWeeklyEmailProcessCenter.m
//  Arcos
//
//  Created by David Kilmartin on 10/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerWeeklyEmailProcessCenter.h"

@implementation CustomerWeeklyEmailProcessCenter

-(NSString*)buildEmailMessageWithDataManager:(CustomerWeeklyMainDataManager*)customerWeeklyMainDataManager {
    NSMutableString* body = [NSMutableString string];
    
    [body appendString:@"<html><body leftmargin='0' rightmargin='0' topmargin='0' marginwidth='0' marginheight='0' width='100%' height='100%'><table width='100%'  border='1' cellpadding='0' cellspacing='0'>"];
    for (int i = 0; i < [customerWeeklyMainDataManager.sectionTitleList count]; i++) {
        NSString* sectionTitle = [customerWeeklyMainDataManager.sectionTitleList objectAtIndex:i];
        [body appendString:@"<tr><td width='100%' height='40' bgcolor='#808080'><b><font color='#FFFFFF'>"];
        [body appendString:sectionTitle];
        [body appendString:@"</font></b></td></tr>"];
        [body appendString:@"<tr><td width='100%' height='100' valign='top'>"];
        NSMutableDictionary* cellData = [customerWeeklyMainDataManager.groupedDataDict objectForKey:sectionTitle];
        [body appendString:[cellData objectForKey:@"Narrative"]];
        [body appendString:@"</td></tr>"];
    }    
    
    [body appendString:@"</table></body></html>"];    
    return body;
}

@end
