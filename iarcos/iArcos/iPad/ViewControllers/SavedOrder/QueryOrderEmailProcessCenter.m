//
//  QueryOrderEmailProcessCenter.m
//  Arcos
//
//  Created by David Kilmartin on 03/06/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "QueryOrderEmailProcessCenter.h"

@implementation QueryOrderEmailProcessCenter

-(NSString*)buildEmailMessageWithTaskObject:(ArcosGenericClass*)cellData memoDataList:(NSMutableArray*)memoList {
    NSMutableString* body = [NSMutableString string];
    
    [body appendString:@"<html><body><table width='100%' height='100%'>"];
    
    [body appendString:@"<tr><td width='100%' height='40'><table width='100%' height='100%'>"];
    
    [body appendString:@"<tr>"];
    [body appendString:@"<td width='100%'><b>"];
    [body appendString:cellData.Field5];
    [body appendString:@"</b></td>"];
    [body appendString:@"</tr>"];
    
    [body appendString:@"</table></td></tr>"];
    
    [body appendString:@"<tr><td height='30' width='100%'><table width='100%' height='100%'>"];
    NSUInteger memoLength = [memoList count];
    for (int i = 0; i < memoLength; i++) {
        [body appendString:@"<tr><td colspan='2' width='100%'><hr></td></tr>"];
        ArcosGenericClass* arcosGenericClass = [memoList objectAtIndex:i];
        NSString* datetimeString = @"";
        @try {
            NSDate* startDate = [ArcosUtils dateFromString:[arcosGenericClass Field1] format:@"yyyy-MM-dd'T'HH:mm:ss"];
            datetimeString = [ArcosUtils stringFromDate:startDate format:@"dd/MM/yyyy HH:mm"];
        }
        @catch (NSException *exception) {}
        
        [body appendString:@"<tr>"];
        [body appendString:@"<td width='5%'></td>"];
        [body appendString:@"<td width='95%' align='right'>"];
        [body appendString:datetimeString];
        [body appendString:@"</td>"];
        [body appendString:@"</tr>"];
        
        [body appendString:@"<tr>"];
        [body appendString:@"<td width='5%'></td>"];
        [body appendString:@"<td width='95%' align='left'>"];
        [body appendString:[arcosGenericClass Field2]];
        [body appendString:@"</td>"];
        [body appendString:@"</tr>"];
        
    }
    [body appendString:@"</table></td></tr>"];
    
    
    
    [body appendString:@"<tr><td height='100%' width='100%'><table width='100%' height='100%'>"];
    [body appendString:@"</table></td></tr>"];
    [body appendString:@"</table></body></html>"];
    return body;
}

@end
