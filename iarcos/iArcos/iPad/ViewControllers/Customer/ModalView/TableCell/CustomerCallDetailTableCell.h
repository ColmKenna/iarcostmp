//
//  CustomerCallDetailTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 01/12/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomerCallDetailTableCell : UITableViewCell {
    IBOutlet UILabel* description;
    IBOutlet UILabel* details;
    
}

@property (nonatomic, retain) IBOutlet UILabel* description;
@property (nonatomic, retain) IBOutlet UILabel* details;

@end
