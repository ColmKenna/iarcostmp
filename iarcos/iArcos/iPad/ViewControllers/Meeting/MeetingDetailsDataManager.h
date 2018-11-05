//
//  MeetingDetailsDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MeetingDetailsDataManager : NSObject {
    NSMutableArray* _displayList;
}

@property(nonatomic, retain) NSMutableArray* displayList;

- (void)createBasicData;

@end

