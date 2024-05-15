//
//  CustomerListingDataManager.h
//  iArcos
//
//  Created by Richard on 09/05/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomerListingDataManager : NSObject {
    BOOL _popoverOpenFlag;
}

@property(nonatomic, assign) BOOL popoverOpenFlag;

@end

