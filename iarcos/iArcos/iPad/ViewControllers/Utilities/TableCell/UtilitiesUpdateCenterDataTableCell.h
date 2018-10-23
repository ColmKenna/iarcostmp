//
//  UtilitiesUpdateCenterDataTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 03/12/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosUtils.h"
#import "WidgetFactory.h"
@protocol UtilitiesUpdateCenterDataTableCellDelegate <NSObject>

-(void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath;
    
@end

@interface UtilitiesUpdateCenterDataTableCell : UITableViewCell<WidgetFactoryDelegate,UIPopoverControllerDelegate> {
    UIImageView* _icon;
    UILabel* _tableName;
    UILabel* _downloadDate;
    UILabel* _downloadModeName;
    UILabel* _tableRecordQty;
    UILabel* _downloadRecordQty;
    NSIndexPath* _indexPath;
    WidgetFactory* _factory;
    UIPopoverController* _thePopover;
    id<UtilitiesUpdateCenterDataTableCellDelegate> _delegate;
    NSString* _sectionTitle;
}

@property (nonatomic, retain) IBOutlet UIImageView* icon;
@property (nonatomic, retain) IBOutlet UILabel* tableName; 
@property (nonatomic, retain) IBOutlet UILabel* downloadDate;
@property (nonatomic, retain) IBOutlet UILabel* downloadModeName; 
@property (nonatomic, retain) IBOutlet UILabel* tableRecordQty;
@property (nonatomic, retain) IBOutlet UILabel* downloadRecordQty;
@property (nonatomic, retain) NSIndexPath* indexPath;
@property (nonatomic, retain) WidgetFactory* factory;
@property (nonatomic, retain) UIPopoverController* thePopover;
@property (nonatomic, assign) id<UtilitiesUpdateCenterDataTableCellDelegate> delegate;
@property (nonatomic, retain) NSString* sectionTitle;

-(void)configCellWithData:(NSMutableDictionary*)aCellData sectionTitle:(NSString*)aSectionTitle;

@end
