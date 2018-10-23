//
//  CustomerContactInfoTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 14/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerContactEmailDelegate.h"

@interface CustomerContactInfoTableCell : UITableViewCell {
    id<CustomerContactEmailDelegate> delegate;
    UILabel* fullname;
    UILabel* _accessTimesDays;
    UILabel* contactType;
    UILabel* phoneNumber;
    UILabel* mobileNumber;
    UILabel* _contactNumber;
    UIImageView* email;
    NSMutableDictionary* cellData;
    NSIndexPath* indexPath;
}

@property(nonatomic, assign) id<CustomerContactEmailDelegate> delegate;
@property(nonatomic, retain) IBOutlet UILabel* fullname;
@property(nonatomic, retain) IBOutlet UILabel* accessTimesDays;
@property(nonatomic, retain) IBOutlet UILabel* contactType;
@property(nonatomic, retain) IBOutlet UILabel* phoneNumber;
@property(nonatomic, retain) IBOutlet UILabel* mobileNumber;
@property(nonatomic, retain) IBOutlet UILabel* contactNumber;
@property(nonatomic, retain) IBOutlet UIImageView* email;
@property(nonatomic, retain) NSMutableDictionary* cellData;
@property(nonatomic, retain) NSIndexPath* indexPath;

-(void)configCellWithData:(NSMutableDictionary*)theCellData;
-(void)handleSingleTapGesture:(id)sender;
@end
