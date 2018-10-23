//
//  CustomerDetailsIURTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 06/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerDetailsIURTableCell : UITableViewCell {
    IBOutlet UILabel* detail;
    NSString* descrDetailIUR;
    NSString* active;
}

@property(nonatomic, retain) IBOutlet UILabel* detail;
@property(nonatomic, retain) NSString* descrDetailIUR;
@property(nonatomic, retain) NSString* active;

@end
