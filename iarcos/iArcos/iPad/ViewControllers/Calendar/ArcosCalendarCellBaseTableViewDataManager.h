//
//  ArcosCalendarCellBaseTableViewDataManager.h
//  iArcos
//
//  Created by Richard on 09/04/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCalendarEventEntryTableViewCell.h"

@interface ArcosCalendarCellBaseTableViewDataManager : NSObject <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray* _displayList;
}

@property(nonatomic, retain) NSMutableArray* displayList;

@end

