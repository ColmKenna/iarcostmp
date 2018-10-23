//
//  SavedOrderDetailDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 21/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SavedOrderDetailDataManager : NSObject {
    BOOL _sendingSuccessFlag;
}

@property(nonatomic, assign) BOOL sendingSuccessFlag;

- (void)normaliseData;

@end
