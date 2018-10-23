//
//  ConTeamLink.h
//  Arcos
//
//  Created by David Kilmartin on 01/07/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ConTeamLink : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * rowguid;
@property (nonatomic, retain) NSNumber * TeamIUR;
@property (nonatomic, retain) NSNumber * ContactIUR;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSString * TeamLeader;
@property (nonatomic, retain) NSString * DefaultTeam;

@end
