//
//  DescrType.h
//  Arcos
//
//  Created by David Kilmartin on 23/04/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DescrType : NSManagedObject

@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSNumber * Active;
@property (nonatomic, retain) NSNumber * ParentTypeCode;
@property (nonatomic, retain) NSString * Details;
@property (nonatomic, retain) NSString * DescrTypeCode;
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * AllowCreateOnFly;
@property (nonatomic, retain) NSNumber * Imageiur;

@end
