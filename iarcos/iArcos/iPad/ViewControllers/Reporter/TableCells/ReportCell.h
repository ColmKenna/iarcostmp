//
//  ReportCell.h
//  Arcos
//
//  Created by David Kilmartin on 24/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportTableCellProtocol.h"
#import "ArcosUtils.h"

@interface ReportCell : UITableViewCell<ReportTableCellProtocol>{
}

- (NSString*)retrieveDate:(NSString*)aDateStr;

@end
