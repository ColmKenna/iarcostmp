//
//  DashboardGenericTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 15/05/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardGenericTableViewLabel.h"

@interface DashboardGenericTableViewCell : UITableViewCell {
//    NSMutableArray* _labelViewList;
}

//@property(nonatomic, retain) NSMutableArray* labelViewList;

- (void)configCellWithDataList:(NSMutableArray*)aDataList;

@end
