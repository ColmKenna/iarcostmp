//
//  MeetingDetailsDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeetingBaseDataManager.h"

@interface MeetingDetailsDataManager : MeetingBaseDataManager {
    NSMutableArray* _displayList;
    NSMutableDictionary* _headOfficeDataObjectDict;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableDictionary* headOfficeDataObjectDict;

- (void)createBasicData;

@end

