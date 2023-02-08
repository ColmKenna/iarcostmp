//
//  ArcosCalendarEventEntryDetailListingDataManager.h
//  iArcos
//
//  Created by Richard on 02/02/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosUtils.h"
#import "ArcosCalendarEventEntryDetailListingTableViewCell.h"
#import "GlobalSharedClass.h"

@interface ArcosCalendarEventEntryDetailListingDataManager : NSObject <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray* _journeyDictList;
    NSMutableArray* _eventDictList;
    NSMutableArray* _displayList;
}

@property(nonatomic, retain) NSMutableArray* journeyDictList;
@property(nonatomic, retain) NSMutableArray* eventDictList;
@property(nonatomic, retain) NSMutableArray* displayList;

- (void)processDataListWithDateFormatText:(NSString*)aDateFormatText;

@end

