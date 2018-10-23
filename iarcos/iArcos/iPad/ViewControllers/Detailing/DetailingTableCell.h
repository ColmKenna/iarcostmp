//
//  DetailingTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 05/10/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingInputCell.h"

@interface DetailingTableCell : SettingInputCell {
    NSNumber* _locationIUR;
    NSNumber* _orderNumber;
    NSString* _locationName;
}

@property(nonatomic, retain) NSNumber* locationIUR;
@property(nonatomic, retain) NSNumber* orderNumber;
@property(nonatomic, retain) NSString* locationName;

- (void)layoutMySubviews:(NSString*)anActionType;

@end
