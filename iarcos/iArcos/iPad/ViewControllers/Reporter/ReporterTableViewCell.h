//
//  ReporterTableViewCell.h
//  Arcos
//
//  Created by David Kilmartin on 06/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwoDatePickerWidgetViewController.h"
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"
#import "CustomerSelectionListingTableViewController.h"

@protocol ReporterTableViewCellDelegate<NSObject>

- (void)dateSelectedFromDate:(NSDate*)aStartDate ToDate:(NSDate*)anEndDate indexPath:(NSIndexPath*)anIndexPath;
- (void)didSelectCustomerSelectionListingRecord:(NSMutableDictionary*)aCustDict indexPath:(NSIndexPath*)anIndexPath;
@end

@interface ReporterTableViewCell : UITableViewCell<TwoDatePickerWidgetDelegate, CustomerSelectionListingDelegate,UIPopoverControllerDelegate> {
    UIButton* _mainButton;
    UIImageView* _subBgImage;
    UIImageView* _dividerImage;
//    IBOutlet UIImageView* mainImage;
    IBOutlet UITextView* title;
    IBOutlet UITextView* myDescription;
    IBOutlet UILabel* extraDesc;
    IBOutlet UIImageView* bgImageView;
    UIButton* _startEndDateBgButton;
    UILabel* _startDateLabel;
    UILabel* _endDateLabel;
    BOOL _isEventSet;
    UIPopoverController* _thePopover;
    UILabel* _startDateTitleLabel;
    UILabel* _endDateTitleLabel;
    NSIndexPath* _indexPath;
//    NSDate* _startDate;
//    NSDate* _endDate;
    NSMutableDictionary* _dateDict;
    id<ReporterTableViewCellDelegate> _delegate;
    UIButton* _locationBgButton;
    UILabel* _locationTitleLabel;
    UILabel* _locationLabel;
    UIPopoverController* _locationPopover;
    NSMutableArray* _locationList;
}

@property(nonatomic,retain) IBOutlet UIButton* mainButton;
@property(nonatomic,retain) IBOutlet UIImageView* subBgImage;
@property(nonatomic,retain) IBOutlet UIImageView* dividerImage;
//@property(nonatomic,retain) IBOutlet UIImageView* mainImage;
@property(nonatomic,retain) IBOutlet UITextView* title;
@property(nonatomic,retain) IBOutlet UITextView* myDescription;
@property(nonatomic,retain) IBOutlet UILabel* extraDesc;
@property(nonatomic,retain) IBOutlet UIImageView* bgImageView;
@property(nonatomic,retain) IBOutlet UIButton* startEndDateBgButton;
@property(nonatomic,retain) IBOutlet UILabel* startDateLabel;
@property(nonatomic,retain) IBOutlet UILabel* endDateLabel;
@property(nonatomic,assign) BOOL isEventSet;
@property(nonatomic, retain) UIPopoverController* thePopover;
@property(nonatomic, retain) IBOutlet UILabel* startDateTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* endDateTitleLabel;
@property(nonatomic, retain) NSIndexPath* indexPath;
//@property(nonatomic,retain) NSDate* startDate;
//@property(nonatomic,retain) NSDate* endDate;
@property(nonatomic, retain) NSMutableDictionary* dateDict;
@property(nonatomic, assign) id<ReporterTableViewCellDelegate> delegate;
@property(nonatomic, retain) IBOutlet UIButton* locationBgButton;
@property(nonatomic, retain) IBOutlet UILabel* locationTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* locationLabel;
@property(nonatomic, retain) UIPopoverController* locationPopover;
@property(nonatomic, retain) NSMutableArray* locationList;

-(void)configCellWithData:(NSMutableDictionary*)aDateDict;

@end
