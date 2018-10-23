//
//  CustomerContactActionBaseDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 02/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerContactActionBaseDataManager : NSObject {
    NSNumber* _contactIUR;
    NSMutableArray* _orderedFieldTypeList;
}

@property(nonatomic, retain) NSNumber* contactIUR;
@property(nonatomic, retain) NSMutableArray* orderedFieldTypeList;

//- (void)configWithContactIUR:(NSNumber*)aContactIUR;
- (NSMutableArray*)locLinkLocationListWithContactIUR:(NSNumber*)aContactIUR;
- (int)retrieveFlagSectionIndex;

@end
