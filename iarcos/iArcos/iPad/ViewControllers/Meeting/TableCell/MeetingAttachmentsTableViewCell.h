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
#import "MeetingAttachmentsTableViewCellDelegate.h"

@interface MeetingAttachmentsTableViewCell : UITableViewCell {
    id<MeetingAttachmentsTableViewCellDelegate> _actionDelegate;
    UILabel* _fileNameLabel;
    UILabel* _miscLabel;
    UIButton* _removeButton;
    UIButton* _removeActiveButton;
    UIButton* _viewButton;
    ArcosAttachmentSummary* _arcosAttachmentSummary;
    NSIndexPath* _myIndexPath;
}

@property(nonatomic, assign) id<MeetingAttachmentsTableViewCellDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UILabel* fileNameLabel;
@property(nonatomic, retain) IBOutlet UILabel* miscLabel;
@property(nonatomic, retain) IBOutlet UIButton* removeButton;
@property(nonatomic, retain) IBOutlet UIButton* removeActiveButton;
@property(nonatomic, retain) IBOutlet UIButton* viewButton;
@property(nonatomic, retain) ArcosAttachmentSummary* arcosAttachmentSummary;
@property(nonatomic, retain) NSIndexPath* myIndexPath;

- (void)configCellWithArcosAttachmentSummary:(ArcosAttachmentSummary*)anArcosAttachmentSummary;
- (IBAction)viewButtonPressed:(id)sender;
- (IBAction)removeButtonPressed:(id)sender;
- (IBAction)removeActionButtonPressed:(id)sender;

@end

