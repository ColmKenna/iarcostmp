//
//  UtilitiesMemoryTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 20/03/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UtilitiesMemoryTableCell : UITableViewCell {
    UILabel* _memoryType;
    UILabel* _memorySize;
}

@property(nonatomic, retain) IBOutlet UILabel* memoryType;
@property(nonatomic, retain) IBOutlet UILabel* memorySize;

@end
