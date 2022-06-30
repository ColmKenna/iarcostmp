//
//  ArcosCalendarCellBaseTableViewDataManagerDelegate.h
//  iArcos
//
//  Created by Richard on 20/06/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ArcosCalendarCellBaseTableViewDataManagerDelegate <NSObject>


- (void)eventEntryInputFinishedWithIndexPath:(NSIndexPath*)anIndexPath dataList:(NSMutableArray*)aDataList sourceView:(UIView*)aView;




@end

