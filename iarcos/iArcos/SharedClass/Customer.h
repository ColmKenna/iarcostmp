//
//  Customer.h
//  Arcos
//
//  Created by David Kilmartin on 24/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Customer : NSObject {
    NSString *Name;
    NSString *Address;
    NSNumber* latitude;
    NSNumber* longitude;
}
@property(nonatomic,retain)NSString *Name;
@property(nonatomic,retain)NSString *Address;
@property(nonatomic,retain) NSNumber* latitude;
@property(nonatomic,retain) NSNumber* longitude;


@end
