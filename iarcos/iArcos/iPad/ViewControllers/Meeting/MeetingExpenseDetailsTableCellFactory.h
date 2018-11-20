//
//  MeetingExpenseDetailsTableCellFactory.h
//  iArcos
//
//  Created by David Kilmartin on 19/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeetingExpenseDetailsBaseTableViewCell.h"


@interface MeetingExpenseDetailsTableCellFactory : NSObject {
    NSString* _iurTableCellId;
    NSString* _dateTableCellId;
    NSString* _textTableCellId;
    NSString* _decimalTableCellId;
}

@property(nonatomic, retain) NSString* iurTableCellId;
@property(nonatomic, retain) NSString* dateTableCellId;
@property(nonatomic, retain) NSString* textTableCellId;
@property(nonatomic, retain) NSString* decimalTableCellId;

- (MeetingExpenseDetailsBaseTableViewCell*)createMeetingExpenseDetailsBaseTableCellWithData:(NSMutableDictionary*)aData;
- (NSString*)identifierWithData:(NSMutableDictionary*)aData;

@end

