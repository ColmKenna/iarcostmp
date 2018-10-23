//
//  PaginatedRequestObject.h
//  Arcos
//
//  Created by David Kilmartin on 19/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaginatedRequestObject : NSObject {
    NSString* _selectStateMent;
    NSString* _fromStatement;
    NSString* _orderBy;
}

@property(nonatomic, retain) NSString* selectStateMent;
@property(nonatomic, retain) NSString* fromStatement;
@property(nonatomic, retain) NSString* orderBy;    

@end
