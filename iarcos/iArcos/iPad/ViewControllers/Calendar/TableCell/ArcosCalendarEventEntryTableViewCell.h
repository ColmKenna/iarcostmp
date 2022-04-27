//
//  ArcosCalendarEventEntryTableViewCell.h
//  iArcos
//
//  Created by Richard on 11/04/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"

@interface ArcosCalendarEventEntryTableViewCell : UITableViewCell {
    UILabel* _subjectLabel;
    UILabel* _startDateLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* subjectLabel;
@property(nonatomic, retain) IBOutlet UILabel* startDateLabel;

- (void)configCellWithData:(NSMutableDictionary*)aCellData;

@end

