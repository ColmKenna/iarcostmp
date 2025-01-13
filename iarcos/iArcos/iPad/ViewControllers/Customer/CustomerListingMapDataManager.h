//
//  CustomerListingMapDataManager.h
//  iArcos
//
//  Created by Richard on 09/01/2025.
//  Copyright © 2025 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomerListingMapDataManager : NSObject {
    NSMutableArray* _displayList;
}

@property (nonatomic, retain) NSMutableArray* displayList;

@end

