//
//  TargetTableCellFactory.h
//  iArcos
//
//  Created by David Kilmartin on 03/10/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TargetBaseTableViewCell.h"

@interface TargetTableCellFactory : NSObject {
    NSString* _monthTableCellId;
    NSString* _yearTableCellId;
}

@property(nonatomic, retain) NSString* monthTableCellId;
@property(nonatomic, retain) NSString* yearTableCellId;

- (TargetBaseTableViewCell*)createTargetBaseTableCellWithData:(NSMutableDictionary*)aData;
- (NSString*)identifierWithData:(NSMutableDictionary*)aData;

@end
