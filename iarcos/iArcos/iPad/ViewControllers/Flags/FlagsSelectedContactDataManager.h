//
//  FlagsSelectedContactDataManager.h
//  iArcos
//
//  Created by Richard on 10/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FlagsSelectedContactDataManager : NSObject {
    NSMutableArray* _displayList;
}

@property(nonatomic,retain) NSMutableArray* displayList;

@end

