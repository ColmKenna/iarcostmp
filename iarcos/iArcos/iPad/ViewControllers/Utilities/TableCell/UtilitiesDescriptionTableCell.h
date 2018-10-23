//
//  UtilitiesDescriptionTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 24/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UtilitiesDescriptionTableCell : UITableViewCell {
    UILabel* _code;
    UILabel* _details;
//    UISwitch* _activeSwitch;
    NSMutableDictionary* cellData;
    NSIndexPath* indexPath;    
}

@property(nonatomic, retain) IBOutlet UILabel* code;
@property(nonatomic, retain) IBOutlet UILabel* details;
//@property(nonatomic, retain) IBOutlet UISwitch* activeSwitch;
@property(nonatomic, retain) NSMutableDictionary* cellData;
@property(nonatomic, retain) NSIndexPath* indexPath;

- (void)configCellData:(NSMutableDictionary*)theCellData;

@end
