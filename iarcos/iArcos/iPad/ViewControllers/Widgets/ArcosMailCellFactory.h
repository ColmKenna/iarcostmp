//
//  ArcosMailCellFactory.h
//  iArcos
//
//  Created by David Kilmartin on 01/02/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosMailBaseTableViewCell.h"

@interface ArcosMailCellFactory : NSObject {
    NSString* _recipientTableViewCellId;
    NSString* _subjectTableViewCellId;
    NSString* _bodyTableViewCellId;
}

@property(nonatomic, retain) NSString* recipientTableViewCellId;
@property(nonatomic, retain) NSString* subjectTableViewCellId;
@property(nonatomic, retain) NSString* bodyTableViewCellId;

+ (instancetype)factory;
- (ArcosMailBaseTableViewCell*)createMailBaseTableCellWithData:(NSMutableDictionary*)aDataDict;
- (NSString*)identifierWithData:(NSMutableDictionary*)aDataDict;

@end
