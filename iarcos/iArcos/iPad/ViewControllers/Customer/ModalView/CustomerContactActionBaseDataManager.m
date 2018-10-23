//
//  CustomerContactActionBaseDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 02/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "CustomerContactActionBaseDataManager.h"

@implementation CustomerContactActionBaseDataManager
@synthesize contactIUR = _contactIUR;
@synthesize orderedFieldTypeList = _orderedFieldTypeList;

- (void)dealloc {
    if (self.contactIUR != nil) { self.contactIUR = nil; }
    if (self.orderedFieldTypeList != nil) { self.orderedFieldTypeList = nil; }    
    
    [super dealloc];
}

- (NSMutableArray*)locLinkLocationListWithContactIUR:(NSNumber*)aContactIUR {
    return [NSMutableArray array];
}

- (int)retrieveFlagSectionIndex {
    int index = 0;
    for (int i = 0; i < [self.orderedFieldTypeList count]; i++) {
        NSString* auxFieldType = [self.orderedFieldTypeList objectAtIndex:i];
        if ([auxFieldType isEqualToString:@"Flags"]) {
            index = i;
            break;
        }
    }
    return index;
}

@end
