//
//  CustomerSurveyBaseTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 10/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSurveyTypesTableCellDelegate.h"
#import "GlobalSharedClass.h"

@interface CustomerSurveyBaseTableCell : UITableViewCell {
    id<CustomerSurveyTypesTableCellDelegate> delegate;
    NSMutableDictionary* cellData;
    NSIndexPath* indexPath;
    NSNumber* _locationIUR;
    NSString* _locationName;
    UIButton* _indicatorButton;
    UILabel* _narrative;
}

@property(nonatomic,assign) id<CustomerSurveyTypesTableCellDelegate> delegate;
@property(nonatomic,retain) NSMutableDictionary* cellData;
@property(nonatomic,retain) NSIndexPath* indexPath;
@property(nonatomic,retain) NSNumber* locationIUR;
@property(nonatomic,retain) NSString* locationName;
@property(nonatomic, retain) IBOutlet UIButton* indicatorButton;
@property(nonatomic, retain) IBOutlet UILabel* narrative;

-(void)configCellWithData:(NSMutableDictionary*)theData;
- (void)configNarrativeWithLabel:(UILabel*)aLabel;
- (void)processIndicatorButton;
-(void)handleSingleTapGesture4Narrative:(id)sender;
- (void)configNarrativeSingleTapGesture;


@end
