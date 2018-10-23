//
//  IURList.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface IURList : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * MasterIUR;
@property (nonatomic, retain) NSNumber * RecordIUR;

@end
