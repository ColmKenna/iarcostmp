//
//  MeetingCostingsDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 13/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeetingBaseDataManager.h"

@interface MeetingCostingsDataManager : MeetingBaseDataManager {
    NSMutableArray* _displayList;
}

@property(nonatomic, retain) NSMutableArray* displayList;

- (void)dataMeetingBaseInputFinishedWithData:(id)aData atIndexPath:(NSIndexPath*)anIndexPath;
- (void)displayListHeadOfficeAdaptor;

@end

