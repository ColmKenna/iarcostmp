//
//  WeeklyMainEmailProcessCenter.m
//  iArcos
//
//  Created by David Kilmartin on 29/06/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "WeeklyMainEmailProcessCenter.h"

@implementation WeeklyMainEmailProcessCenter

- (NSString*)buildEmailMessageWithDataManager:(WeeklyMainTemplateDataManager*)aWeeklyMainTemplateDataManager {
    NSMutableString* body = [NSMutableString string];
    
    [body appendString:@"<html><body leftmargin='0' rightmargin='0' topmargin='0' marginwidth='0' marginheight='0' width='100%' height='100%'><table width='100%'  border='1' cellpadding='0' cellspacing='0'>"];
    for (int i = 0; i < [aWeeklyMainTemplateDataManager.sectionTitleList count]; i++) {
        NSString* sectionTitle = [aWeeklyMainTemplateDataManager.sectionTitleList objectAtIndex:i];
        [body appendString:@"<tr><td width='100%' height='40' bgcolor='#808080' colspan='3'><b><font color='#FFFFFF'>"];
        [body appendString:sectionTitle];
        [body appendString:@"</font></b></td></tr>"];
        [body appendString:@"<tr><td width='100%' height='100' valign='top' colspan='3'>"];
        NSMutableDictionary* cellData = [aWeeklyMainTemplateDataManager.groupedDataDict objectForKey:sectionTitle];
        [body appendString:[cellData objectForKey:@"Narrative"]];
        [body appendString:@"</td></tr>"];
    }
    for (int j = 0; j < [aWeeklyMainTemplateDataManager.sortedWeekDayDescList count]; j++) {
//        int firstIndex = j * 2;
//        int secondIndex = j * 2 + 1;
        [body appendString:@"<tr><td width='30%' height='40'>"];
        [body appendString:[aWeeklyMainTemplateDataManager.sortedWeekDayDescList objectAtIndex:j]];
        [body appendString:@"</td>"];
        [body appendString:@"<td width='35%' height='40'>"];
        NSMutableArray* sortedDayPartsTagArray = [aWeeklyMainTemplateDataManager.sortedDayPartsTagArrayList objectAtIndex:j];
        NSNumber* firstDaysOfWeekKey = [sortedDayPartsTagArray objectAtIndex:0];
        NSMutableDictionary* firstDaysOfWeekDataDict =  [aWeeklyMainTemplateDataManager.dayPartsGroupedDataDict objectForKey:firstDaysOfWeekKey];
        NSMutableDictionary* firstDayPartsDict = [firstDaysOfWeekDataDict objectForKey:@"Data"];
        [body appendString:[firstDayPartsDict objectForKey:@"Title"]];        
        [body appendString:@"</td>"];
        
        [body appendString:@"<td width='35%' height='40'>"];
        NSNumber* secondDaysOfWeekKey = [sortedDayPartsTagArray objectAtIndex:1];
        NSMutableDictionary* secondDaysOfWeekDataDict =  [aWeeklyMainTemplateDataManager.dayPartsGroupedDataDict objectForKey:secondDaysOfWeekKey];
        NSMutableDictionary* secondDayPartsDict = [secondDaysOfWeekDataDict objectForKey:@"Data"];
        [body appendString:[secondDayPartsDict objectForKey:@"Title"]];        
        [body appendString:@"</td>"];        
        [body appendString:@"</tr>"];
    }
    
    [body appendString:@"</table></body></html>"];    
    return body;
}

@end
