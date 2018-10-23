//
//  CustomerSurveyDetailsResponseBaseTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 22/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosGenericClass.h"
#import "CustomerSurveyDetailsResponseTableCellDelegate.h"

@interface CustomerSurveyDetailsResponseBaseTableCell : UITableViewCell {
    id<CustomerSurveyDetailsResponseTableCellDelegate> _delegate;
    ArcosGenericClass* _cellData;
    NSIndexPath* _indexPath;
}

@property(nonatomic, assign) id<CustomerSurveyDetailsResponseTableCellDelegate> delegate;
@property(nonatomic, retain) ArcosGenericClass* cellData;
@property(nonatomic, retain) NSIndexPath* indexPath;

- (void)configCellWithData:(ArcosGenericClass*)aCellData;

@end
