//
//  MeetingPresentersCompositeObject.h
//  iArcos
//
//  Created by Richard on 24/06/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosPresenterForMeeting.h"

@interface MeetingPresentersCompositeObject : NSObject {
    NSNumber* _cellType;
    ArcosPresenterForMeeting* _presenterData;
    NSNumber* _openFlag;
}

@property(nonatomic, retain) NSNumber* cellType;
@property(nonatomic, retain) ArcosPresenterForMeeting* presenterData;
@property(nonatomic, retain) NSNumber* openFlag;

- (instancetype)initHeaderWithData:(ArcosPresenterForMeeting*)aData;
- (instancetype)initPresenterWithData:(ArcosPresenterForMeeting*)aData;

@end


