//
//  LocalConfig.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LocalConfig : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSString * MachineName;
@property (nonatomic, retain) NSString * LastUser;
@property (nonatomic, retain) NSNumber * DefaultIndicator2;
@property (nonatomic, retain) NSNumber * DefaultIndicator4;
@property (nonatomic, retain) NSNumber * DefaultIndicator3;
@property (nonatomic, retain) NSNumber * DefaultIndicator1;
@property (nonatomic, retain) NSNumber * LastOrderNumber;
@property (nonatomic, retain) NSNumber * DefaultIndicator5;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * lastIUR;

@end
