//
//  PackageDataManager.h
//  iArcos
//
//  Created by Richard on 21/07/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface PackageDataManager : NSObject {
    NSMutableArray* _displayList;
    NSMutableDictionary* _wholesalerIurImageIurHashMap;
    NSMutableDictionary* _pGiurDetailHashMap;
    
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableDictionary* wholesalerIurImageIurHashMap;
@property(nonatomic, retain) NSMutableDictionary* pGiurDetailHashMap;

- (void)retrievePackageDataWithLocationIUR:(NSNumber*)aLocationIUR;
- (void)resetSelectedFlagOnList;
- (void)configSelectedFlagWithIndexPath:(NSIndexPath*)anIndexPath;
- (void)saveButtonPressedProcessor;

@end


