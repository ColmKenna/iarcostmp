//
//  GenericUITableDetailTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 26/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenericUITableDetailTableCell : UITableViewCell {
    UILabel* attributeName;
    UILabel* attributeValue;
}

@property(nonatomic, retain) IBOutlet UILabel* attributeName;
@property(nonatomic, retain) IBOutlet UILabel* attributeValue;

@end
