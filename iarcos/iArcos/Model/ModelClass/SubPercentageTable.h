//
//  SubPercentageTable.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SubPercentageTable : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * Percentage;
@property (nonatomic, retain) NSNumber * LinkIUR;
@property (nonatomic, retain) NSNumber * TotalValue;
@property (nonatomic, retain) NSNumber * LocationIUR;
@property (nonatomic, retain) NSNumber * rowguid;

@end
