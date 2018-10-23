//
//  FormColumn.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FormColumn : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * FormIUR;
@property (nonatomic, retain) NSNumber * ForeColor;
@property (nonatomic, retain) NSNumber * LeaveRule;
@property (nonatomic, retain) NSNumber * EntryRule;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSString * Tooltip;
@property (nonatomic, retain) NSNumber * ColWidth;
@property (nonatomic, retain) NSNumber * BackColor;
@property (nonatomic, retain) NSNumber * ColumnType;
@property (nonatomic, retain) NSNumber * ColumnNumber;
@property (nonatomic, retain) NSNumber * Readonly;
@property (nonatomic, retain) NSNumber * ColumnHeader;

@end
