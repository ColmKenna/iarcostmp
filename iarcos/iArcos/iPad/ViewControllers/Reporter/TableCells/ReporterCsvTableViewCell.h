//
//  ReporterCsvTableViewCell.h
//  iArcos
//
//  Created by Richard on 18/06/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReporterCsvTableViewCell : UITableViewCell {
    NSMutableArray* _cellLabelList;
}

@property(nonatomic, retain) NSMutableArray* cellLabelList;

@end

