//
//  ReporterXmlSubDataManager.h
//  iArcos
//
//  Created by Richard on 21/01/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXMLDocument.h"
#import "CXMLElement.h"
#import "ArcosUtils.h"

@interface ReporterXmlSubDataManager : NSObject {
    NSMutableArray* _displayList;
    CXMLDocument* _reportDocument;
    BOOL _qtyShowFlag;
    BOOL _valueShowFlag;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) CXMLDocument* reportDocument;
@property(nonatomic, assign) BOOL qtyShowFlag;
@property(nonatomic, assign) BOOL valueShowFlag;

- (void)processRawData:(CXMLDocument*)aReportDocument;

@end


