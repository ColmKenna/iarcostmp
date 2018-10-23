//
//  QueryOrderDetailTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 20/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GenericDoubleTapRecordDelegate.h"
#import "ArcosGenericClass.h"


@interface QueryOrderDetailTableCell : UITableViewCell {
    id<GenericDoubleTapRecordDelegate> _delegate;
    UILabel* _dateLabel;
    UILabel* _timeLabel;
    UITextView* _detailsTextView;
    UILabel* _employeeLabel;
    UILabel* _contactLabel;
    NSIndexPath* _indexPath;
}

@property(nonatomic, assign) id<GenericDoubleTapRecordDelegate> delegate;
@property(nonatomic, retain) IBOutlet UILabel* dateLabel;
@property(nonatomic, retain) IBOutlet UILabel* timeLabel;
@property(nonatomic, retain) IBOutlet UITextView* detailsTextView;
@property(nonatomic, retain) IBOutlet UILabel* employeeLabel;
@property(nonatomic, retain) IBOutlet UILabel* contactLabel;
@property(nonatomic, retain) NSIndexPath* indexPath;

-(void)configCellWithData:(NSNumber*)heightData;

@end
