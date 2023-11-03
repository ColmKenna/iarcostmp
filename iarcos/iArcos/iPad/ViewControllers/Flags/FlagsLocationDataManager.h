//
//  FlagsLocationDataManager.h
//  iArcos
//
//  Created by Richard on 02/11/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FlagsLocationDataManager : NSObject {
    NSIndexPath* _currentIndexPath;
}

@property(nonatomic, retain) NSIndexPath* currentIndexPath;

@end


