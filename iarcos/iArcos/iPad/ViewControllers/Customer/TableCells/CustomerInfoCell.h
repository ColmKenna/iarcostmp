//
//  CustomerInfoCell.h
//  Arcos
//
//  Created by David Kilmartin on 24/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerInfoCell : UITableViewCell{
    IBOutlet UILabel* infoTitle;
    IBOutlet UILabel* infoValue;
}
@property(nonatomic,retain) IBOutlet UILabel* infoTitle;
@property(nonatomic,retain) IBOutlet UILabel* infoValue;
@end
