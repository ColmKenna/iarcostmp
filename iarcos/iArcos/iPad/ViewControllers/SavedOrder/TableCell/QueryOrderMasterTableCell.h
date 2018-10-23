//
//  QueryOrderMasterTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 20/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol QueryOrderMasterTableCellDelegate <NSObject>

- (void)selectQueryOrderMasterTableCellRecord:(NSIndexPath*)anIndexPath;
- (void)doubleTapQueryOrderMasterTableCellRecord:(NSIndexPath*)anIndexPath;

@end


@interface QueryOrderMasterTableCell : UITableViewCell<UITextViewDelegate> {
    id<QueryOrderMasterTableCellDelegate> _delegate;
    UILabel* _nameLabel;
    UILabel* _addressLabel;
    UITextView* _detailsTextView;
    UILabel* _dateLabel;
    UILabel* _timeLabel;
    NSIndexPath* _indexPath;
//    BOOL _isNotFirstCalled;
    UIImageView* _closeImageView;
}

@property(nonatomic, assign) id<QueryOrderMasterTableCellDelegate> delegate;
@property(nonatomic, retain) IBOutlet UILabel* nameLabel;
@property(nonatomic, retain) IBOutlet UILabel* addressLabel;
@property(nonatomic, retain) IBOutlet UITextView* detailsTextView;
@property(nonatomic, retain) IBOutlet UILabel* dateLabel;
@property(nonatomic, retain) IBOutlet UILabel* timeLabel;
@property(nonatomic, retain) NSIndexPath* indexPath;
@property(nonatomic, retain) IBOutlet UIImageView* closeImageView;
//@property(nonatomic, assign)

-(void)configCellWithData:(NSNumber*)heightData;

@end
