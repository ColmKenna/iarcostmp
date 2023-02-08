//
//  ArcosCalendarEventEntryDetailListingTableViewCell.h
//  iArcos
//
//  Created by Richard on 02/02/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"

@interface ArcosCalendarEventEntryDetailListingTableViewCell : UITableViewCell {
    UILabel* _timeLabel;
    UILabel* _nameLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* timeLabel;
@property(nonatomic, retain) IBOutlet UILabel* nameLabel;

- (void)configCellWithData:(NSMutableDictionary*)aData;

@end


