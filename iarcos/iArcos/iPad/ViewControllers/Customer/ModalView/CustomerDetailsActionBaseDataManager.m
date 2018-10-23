//
//  CustomerDetailsActionBaseDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 03/12/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerDetailsActionBaseDataManager.h"

@implementation CustomerDetailsActionBaseDataManager
@synthesize orderedFieldTypeList = _orderedFieldTypeList;


- (void)dealloc {
    self.orderedFieldTypeList = nil;
    
    [super dealloc];
}

- (NSMutableArray*)buyingGroupLocationListWithLocationIUR:(NSNumber*)aLocationIUR {
    return [NSMutableArray array];
}

- (int)retrieveIURSectionIndex {
    int index = 0;
    for (int i = 0; i < [self.orderedFieldTypeList count]; i++) {
        NSString* auxFieldType = [self.orderedFieldTypeList objectAtIndex:i];
        if ([auxFieldType isEqualToString:@"IUR"]) {
            index = i;
            break;
        }
    }
    return index;
}

@end
