//
//  ReportCellFactory.m
//  Arcos
//
//  Created by David Kilmartin on 27/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ReportCellFactory.h"

@implementation ReportCellFactory

-(id)init{
    self=[super init];
    if (self!=nil) {
        
    }
    return self;
}

+(id)Factory{
    return [[[self alloc]init]autorelease];
}

-(NSString*)cellIdentifierWithReportCode:(NSString*)code{
    NSString* identifier=@"";
    
    if ([code isEqualToString:@"2.00"]) {//location report
        return @"ReportLocationCell";
        
    }else if ([code isEqualToString:@"2.01"]) {//contact report
        return @"ReportContactCell";
        
    }else if ([code isEqualToString:@"2.02"]) {//calls report
        return @"ReportCallCell";
        
    }else if ([code isEqualToString:@"2.03"]) {//orders report
        return @"ReportOrderCell";
        
    }else if ([code isEqualToString:@"2.13"]) {//invoices report
        return @"ReportInvoiceCell";
        
    }else if ([code isEqualToString:@"2.04"]) {//product report
        return @"ReportProductCell";
        
    }else if ([code isEqualToString:@"2.19"]) {//meeting report
        return @"IdReportMeetingTableViewCell";
        
    }else{
        return @"ReportGenericCell";
    }
    
    return identifier;
}

-(int)viewTagWithCode:(NSString*)code{
    if ([code isEqualToString:@"2.00"]) {//location report
        return 0;
        
    }else if ([code isEqualToString:@"2.01"]) {//contact report
        return 1;
        
    }else if ([code isEqualToString:@"2.02"]) {//calls report
        return 2;
        
    }else if ([code isEqualToString:@"2.03"]) {//orders report
        return 3;
        
    }else if ([code isEqualToString:@"2.13"]) {//invoices report
        return 4;
        
    }else if ([code isEqualToString:@"2.04"]) {//product report
        return 5;
        
    }else if ([code isEqualToString:@"2.19"]) {//meeting report
        return 6;
        
    }else{
        return 88;
    }
}
-(UIView*)headViewWithReportCode:(NSString*)code{
    int tag=[self viewTagWithCode:code];
    
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"ReportTableHeaders" owner:self options:nil];
    
    UIView* aView = nil;
    for (id nibItem in nibContents) {
        
        if ([nibItem isKindOfClass:[UIView class]]) {
            aView=(UIView*)nibItem;
            if (aView.tag==tag) {
                break;
            }
        }
    }
    
    return aView;
}

@end
