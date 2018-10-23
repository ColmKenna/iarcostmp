//
//  GenericGroupedImageTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 12/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GenericGroupedImageTableCell : UITableViewCell {
    UIImageView* _myImageView;
    UILabel* _myTextLabel;
}

@property(nonatomic, retain) IBOutlet UIImageView* myImageView;
@property(nonatomic, retain) IBOutlet UILabel* myTextLabel;

- (void)configImageView;

@end
