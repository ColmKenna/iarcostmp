//
//  CompositeIndexResult.h
//  iArcos
//
//  Created by David Kilmartin on 11/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompositeIndexResult : NSObject {
    NSString* _sectionTitle;
    NSIndexPath* _indexPath;
}

@property(nonatomic, retain) NSString* sectionTitle;
@property(nonatomic, retain) NSIndexPath* indexPath;

@end
