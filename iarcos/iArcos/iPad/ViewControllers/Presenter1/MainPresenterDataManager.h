//
//  MainPresenterDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 29/03/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosAuxiliaryDataProcessor.h"

@interface MainPresenterDataManager : NSObject {
    NSMutableArray* _displayList;
    int _numberOfBtn;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, assign) int numberOfBtn;

- (void)retrieveMainPresenterDataList;

@end
