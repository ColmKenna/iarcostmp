//
//  MeetingMiscDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 06/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeetingBaseDataManager.h"
#import "ArcosCoreData.h"

@interface MeetingMiscDataManager : MeetingBaseDataManager {
    NSString* _auditorSectionTitle;
    NSString* _detailingSectionTitle;
    NSString* _speakerSectionTitle;
    NSMutableArray* _sectionTitleList;
    NSMutableDictionary* _groupedDataDict;
    
}

@property(nonatomic, retain) NSString* auditorSectionTitle;
@property(nonatomic, retain) NSString* detailingSectionTitle;
@property(nonatomic, retain) NSString* speakerSectionTitle;
@property(nonatomic, retain) NSMutableArray* sectionTitleList;
@property(nonatomic, retain) NSMutableDictionary* groupedDataDict;

- (NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath;

@end

