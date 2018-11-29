//
//  MeetingBudgetTableCellFactory.h
//  iArcos
//
//  Created by David Kilmartin on 27/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeetingBudgetBaseTableViewCell.h"

@interface MeetingBudgetTableCellFactory : NSObject {
    NSString* _integerTableCellId;
    NSString* _decimalTableCellId;
}

@property(nonatomic, retain) NSString* integerTableCellId;
@property(nonatomic, retain) NSString* decimalTableCellId;

- (MeetingBudgetBaseTableViewCell*)createMeetingBudgetBaseTableCellWithData:(NSMutableDictionary*)aData;
- (NSString*)identifierWithData:(NSMutableDictionary*)aData;

@end

