//
//  CustomerNewsTaskTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 24/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosUtils.h"
//#import "ArcosGenericClass.h"

@protocol CustomerNewsTaskTableCellDelegate <NSObject>

- (void)selectNewsTableCellRecord:(NSIndexPath*)anIndexPath;
- (void)selectTaskTableCellRecord:(NSIndexPath*)anIndexPath;

@end

@interface CustomerNewsTaskTableCell : UITableViewCell <UITextViewDelegate>{
    id<CustomerNewsTaskTableCellDelegate> _actionDelegate;
    UILabel* _myTitle;
    UITextView* _myDetails;
    UILabel* _linkAddress;
    NSNumber* _type;
//    ArcosGenericClass* _arcosGenericClass;
    NSIndexPath* _indexPath;
}

@property(nonatomic, assign) id<CustomerNewsTaskTableCellDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UILabel* myTitle;
@property(nonatomic, retain) IBOutlet UITextView* myDetails;
@property(nonatomic, retain) IBOutlet UILabel* linkAddress;
@property(nonatomic, retain) NSNumber* type;
//@property(nonatomic, retain) ArcosGenericClass* arcosGenericClass;
@property(nonatomic, retain) NSIndexPath* indexPath;

-(void)configCellWithData:(NSNumber*)heightData;

@end
