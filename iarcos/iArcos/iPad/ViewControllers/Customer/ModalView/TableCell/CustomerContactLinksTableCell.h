//
//  CustomerContactLinksTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 02/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerContactLinksTableCell : UITableViewCell {
    UILabel* _linkText;
}

@property(nonatomic, retain) IBOutlet UILabel* linkText;

@end
