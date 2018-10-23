//
//  ReportTableCellProtocol.h
//  Arcos
//
//  Created by David Kilmartin on 27/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"

@protocol ReportTableCellProtocol <NSObject>
-(void)setData:(NSMutableDictionary*)data;
-(void)setDataXML:(CXMLElement*)element;
@end
