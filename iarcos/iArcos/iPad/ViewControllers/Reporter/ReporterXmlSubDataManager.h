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
    int _countSum;
    int _qtySum;
    float _valueSum;
    BOOL _subTableRowPressed;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) CXMLDocument* reportDocument;
@property(nonatomic, assign) BOOL qtyShowFlag;
@property(nonatomic, assign) BOOL valueShowFlag;
@property(nonatomic, assign) int countSum;
@property(nonatomic, assign) int qtySum;
@property(nonatomic, assign) float valueSum;
@property(nonatomic, assign) BOOL subTableRowPressed;

- (void)processRawData:(CXMLDocument*)aReportDocument;

@end


