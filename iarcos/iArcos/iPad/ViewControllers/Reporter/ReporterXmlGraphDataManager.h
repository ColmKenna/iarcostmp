//
//  ReporterXmlGraphDataManager.h
//  iArcos
//
//  Created by Richard on 25/01/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXMLDocument.h"
#import "CXMLElement.h"
#import "ArcosUtils.h"

@interface ReporterXmlGraphDataManager : NSObject {
    NSMutableArray* _displayList;
    CXMLDocument* _reportDocument;
    NSString* _identifier;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) CXMLDocument* reportDocument;
@property(nonatomic, retain) NSString* identifier;

- (void)processRawData:(CXMLDocument*)aReportDocument;

@end

