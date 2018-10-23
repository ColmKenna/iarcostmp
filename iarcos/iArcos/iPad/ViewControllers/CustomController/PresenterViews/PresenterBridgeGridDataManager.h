//
//  PresenterBridgeGridDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 31/07/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosMiniToolkit.h"
#import "BranchLeafMiscUtils.h"

@interface PresenterBridgeGridDataManager : NSObject {
    int _numberOfBtn;
    ArcosMiniToolkit* _arcosMiniToolkit;
    NSMutableArray* _displayList;
    BranchLeafMiscUtils* _branchLeafMiscUtils;
}

@property(nonatomic, assign) int numberOfBtn;
@property(nonatomic, retain) ArcosMiniToolkit* arcosMiniToolkit;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) BranchLeafMiscUtils* branchLeafMiscUtils;

- (void)processRawData:(NSMutableArray*)aDataList;


@end
