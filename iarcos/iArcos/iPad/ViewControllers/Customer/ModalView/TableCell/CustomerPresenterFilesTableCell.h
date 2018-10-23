//
//  CustomerPresenterFilesTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 08/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerPresenterFilesTableCell : UITableViewCell {
    IBOutlet UILabel* fileName;
    IBOutlet UILabel* fileSize;
    IBOutlet UILabel* md5;
    NSMutableDictionary* cellData;
    NSIndexPath* indexPath;
}

@property(nonatomic, retain) IBOutlet UILabel* fileName;
@property(nonatomic, retain) IBOutlet UILabel* fileSize;
@property(nonatomic, retain) IBOutlet UILabel* md5;
@property(nonatomic, retain) NSMutableDictionary* cellData;
@property(nonatomic, retain) NSIndexPath* indexPath;

- (void)configCellData:(NSMutableDictionary*)theCellData;

@end
