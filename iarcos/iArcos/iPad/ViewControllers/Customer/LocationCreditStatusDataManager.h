//
//  LocationCreditStatusDataManager.h
//  iArcos
//
//  Created by Richard on 27/11/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface LocationCreditStatusDataManager : NSObject {
    NSMutableArray* _locationIURList;
    NSMutableDictionary* _locationIURHashMap;
}

@property(nonatomic,retain) NSMutableArray* locationIURList;
@property(nonatomic,retain) NSMutableDictionary* locationIURHashMap;

- (void)configImageWithLocationStatusButton:(UIButton*)aLocationStatusButton creditStatusButton:(UIButton*)aCreditStatusButton lsiur:(NSNumber*)aLsiur csiur:(NSNumber*)aCsiur;

@end


