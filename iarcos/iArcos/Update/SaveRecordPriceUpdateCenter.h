//
//  SaveRecordPriceUpdateCenter.h
//  iArcos
//
//  Created by David Kilmartin on 31/07/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "SaveRecordBaseUpdateCenter.h"

@interface SaveRecordPriceUpdateCenter : SaveRecordBaseUpdateCenter {
    NSMutableDictionary* _existingPromotionDict;
}

@property(nonatomic, retain) NSMutableDictionary* existingPromotionDict;

@end
