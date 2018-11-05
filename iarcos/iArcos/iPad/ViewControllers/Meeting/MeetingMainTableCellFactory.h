//
//  MeetingMainTableCellFactory.h
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeetingBaseTableViewCell.h"

@interface MeetingMainTableCellFactory : NSObject {
    NSString* _datetimeTableCellId;
    NSString* _stringTableCellId;
    NSString* _locationTableCellId;
    NSString* _employeeTableCellId;
    NSString* _textViewTableCellId;
    NSString* _iurTableCellId;
}

@property(nonatomic, retain) NSString* datetimeTableCellId;
@property(nonatomic, retain) NSString* stringTableCellId;
@property(nonatomic, retain) NSString* locationTableCellId;
@property(nonatomic, retain) NSString* employeeTableCellId;
@property(nonatomic, retain) NSString* textViewTableCellId;
@property(nonatomic, retain) NSString* iurTableCellId;

- (MeetingBaseTableViewCell*)createMeetingBaseTableCellWithData:(NSMutableDictionary*)aData;
- (NSString*)identifierWithData:(NSMutableDictionary*)aData;

@end

