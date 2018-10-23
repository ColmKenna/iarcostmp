//
//  ReportCellFactory.h
//  Arcos
//
//  Created by David Kilmartin on 27/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ReportCellFactory : NSObject

-(NSString*)cellIdentifierWithReportCode:(NSString*)code;
-(UIView*)headViewWithReportCode:(NSString*)code;
-(int)viewTagWithCode:(NSString*)code;
@end
