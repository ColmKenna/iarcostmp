//
//  DashboardMainTemplateDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 11/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DashboardMainTemplateDataObject.h"

@interface DashboardMainTemplateDataManager : NSObject {
    NSMutableArray* _displayList;
}

@property(nonatomic, retain) NSMutableArray* displayList;

- (void)createBasicData;

@end
