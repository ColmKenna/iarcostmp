//
//  FlagsMainTemplateDataManager.h
//  iArcos
//
//  Created by Richard on 05/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FlagsMainTemplateDataManager : NSObject {
    NSMutableDictionary* _contactOrderCart;
}

@property(nonatomic, retain) NSMutableDictionary* contactOrderCart;

- (void)saveContactToOrderCart:(NSMutableDictionary*)aContactDict;
- (NSMutableArray*)retrieveSelectedContactListProcessor;

@end

