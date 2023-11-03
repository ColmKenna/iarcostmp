//
//  FlagsSelectedContactDataManager.h
//  iArcos
//
//  Created by Richard on 10/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface FlagsSelectedContactDataManager : NSObject {
    NSMutableArray* _displayList;
    NSMutableArray* _contactOrLocationFlagDictList;
}

@property(nonatomic,retain) NSMutableArray* displayList;
@property(nonatomic,retain) NSMutableArray* contactOrLocationFlagDictList;

- (NSMutableArray*)retrieveFlagDataWithDescrTypeCode:(NSString*)aDescrTypeCode;

@end

