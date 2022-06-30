//
//  ArcosCalendarEventEntryDetailTableViewCellFactory.h
//  iArcos
//
//  Created by Richard on 13/05/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCalendarEventEntryDetailBaseTableViewCell.h"

@interface ArcosCalendarEventEntryDetailTableViewCellFactory : NSObject {
    NSString* _textFieldTableCellId;
    NSString* _textViewTableCellId;
    NSString* _switchTableCellId;
    NSString* _dateTableCellId;
    NSString* _datetimeTableCellId;
    NSString* _deleteTableCellId;
}

@property(nonatomic, retain) NSString* textFieldTableCellId;
@property(nonatomic, retain) NSString* textViewTableCellId;
@property(nonatomic, retain) NSString* switchTableCellId;
@property(nonatomic, retain) NSString* dateTableCellId;
@property(nonatomic, retain) NSString* datetimeTableCellId;
@property(nonatomic, retain) NSString* deleteTableCellId;

- (ArcosCalendarEventEntryDetailBaseTableViewCell*)createEventEntryDetailBaseTableCellWithData:(NSMutableDictionary*)aData;
- (NSString*)identifierWithData:(NSMutableDictionary*)aData;

@end


