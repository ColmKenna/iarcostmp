//
//  SubReport.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SubReport : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * Subtitle;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * IconNumber;
@property (nonatomic, retain) NSString * EndWhereClause;
@property (nonatomic, retain) NSString * SortField1;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * ReportIUR;
@property (nonatomic, retain) NSString * SelectStatement;
@property (nonatomic, retain) NSString * SQLsortby;
@property (nonatomic, retain) NSString * PropertyProgram;
@property (nonatomic, retain) NSString * WhereClause;
@property (nonatomic, retain) NSString * OrderBy;
@property (nonatomic, retain) NSString * ColumnWidths;
@property (nonatomic, retain) NSNumber * UseasListView;
@property (nonatomic, retain) NSString * SortField2;
@property (nonatomic, retain) NSNumber * SubOrder;
@property (nonatomic, retain) NSString * ReportSource;

@end
