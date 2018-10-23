//
//  NextCheckoutReadOnlyTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 25/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutReadOnlyTableViewCell.h"

@implementation NextCheckoutReadOnlyTableViewCell

- (void)configCellWithData:(NSMutableDictionary *)aCellData {
    [super configCellWithData:aCellData];
    self.fieldValueLabel.text = [aCellData objectForKey:@"FieldData"];
}

@end
