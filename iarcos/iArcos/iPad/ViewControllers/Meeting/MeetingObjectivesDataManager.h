//
//  MeetingObjectivesDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 08/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeetingBaseDataManager.h"

@interface MeetingObjectivesDataManager : MeetingBaseDataManager {
    NSMutableArray* _displayList;
}

@property(nonatomic, retain) NSMutableArray* displayList;


@end

