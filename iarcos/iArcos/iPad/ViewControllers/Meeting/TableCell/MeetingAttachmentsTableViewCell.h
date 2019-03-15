//
//  MeetingAttachmentsTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 15/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosAttachmentSummary.h"
#import "ArcosCoreData.h"

@interface MeetingAttachmentsTableViewCell : UITableViewCell {
    UILabel* _fileNameLabel;
    UILabel* _miscLabel;
    UIButton* _removeButton;
    UIButton* _removeActiveButton;
    UIButton* _viewButton;
}

@property(nonatomic, retain) IBOutlet UILabel* fileNameLabel;
@property(nonatomic, retain) IBOutlet UILabel* miscLabel;
@property(nonatomic, retain) IBOutlet UIButton* removeButton;
@property(nonatomic, retain) IBOutlet UIButton* removeActiveButton;
@property(nonatomic, retain) IBOutlet UIButton* viewButton;

- (void)configCellWithArcosAttachmentSummary:(ArcosAttachmentSummary*)anArcosAttachmentSummary;


@end

