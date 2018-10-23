//
//  UtilitiesConfigurationDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 24/04/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "ArcosConfigDataManager.h"

@interface UtilitiesConfigurationDataManager : NSObject {
    NSMutableArray* _displayList;
    NSMutableArray* _originalDisplayList;
    NSMutableArray* _changedList;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* originalDisplayList;
@property(nonatomic, retain) NSMutableArray* changedList;

- (void)retrieveDescrDetailIOData;
- (void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath *)theIndexpath;
- (void)retrieveChangedList;
- (void)saveChangedList;


@end
