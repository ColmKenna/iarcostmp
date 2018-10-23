//
//  DetailingTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 05/10/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosCoreData.h"
#import "DetailingTableCellFactory.h"
#import "DetailingTableCell.h"
#import "ArcosArrayOfCallTran.h"
#import "OrderSharedClass.h"
#import "CoreLocationController.h"
#import "DetailingDataManager.h"
#import "ArcosSystemCodesUtils.h"
#import "UIViewController+ArcosStackedController.h"
#import "ArcosConfigDataManager.h"
@class ArcosRootViewController;
typedef enum {
    DetailingRequestSourceListings = 0,
    DetailingRequestSourceCustomer,
    DetailingRequestSourceCall
} DetailingRequestSource;

@interface DetailingTableViewController : UITableViewController <SettingTableViewCellDelegate,UIActionSheetDelegate,CoreLocationControllerDelegate>{
    DetailingRequestSource _requestSource;
    NSMutableArray* detailingSelections;
    NSMutableArray* detailingSelectionNames;
    DetailingTableCellFactory* cellFactory;
    UIPopoverController* _tablecellPopover;
    NSMutableDictionary* orderHeader;
    ArcosArrayOfCallTran* calltrans;
    NSNumber* orderNumber;
    BOOL isEditable;
    BOOL anySampleOrQA;
    
    //location controller
    CoreLocationController *CLController;
    NSNumber* _locationDefaultContactIUR;
    NSNumber* _locationIUR;
    NSString* _locationName;
    DetailingDataManager* _detailingDataManager;
    ArcosRootViewController* _rootView;
//    ArcosConfigDataManager* _arcosConfigDataManager;
    NSNumber* _coordinateType;    
}
@property(nonatomic,assign) DetailingRequestSource requestSource;
@property(nonatomic,retain)    NSMutableArray* detailingSelections;
@property(nonatomic,retain)   NSMutableArray* detailingSelectionNames;
@property(nonatomic,retain) DetailingTableCellFactory* cellFactory;
@property(nonatomic,retain) UIPopoverController* tablecellPopover;
@property(nonatomic,retain) NSMutableDictionary* orderHeader;
@property(nonatomic,retain) ArcosArrayOfCallTran* calltrans;
@property(nonatomic,retain)     NSNumber* orderNumber;
@property(nonatomic,assign)     BOOL isEditable;
@property (nonatomic, retain) CoreLocationController *CLController;
@property (nonatomic, retain) NSNumber* locationDefaultContactIUR;
@property (nonatomic, retain) NSNumber* locationIUR;
@property (nonatomic, retain) NSString* locationName;
@property (nonatomic, retain) DetailingDataManager* detailingDataManager;
@property (nonatomic, retain) ArcosRootViewController* rootView;
//@property (nonatomic, retain) ArcosConfigDataManager* arcosConfigDataManager;
@property (nonatomic, retain) NSNumber* coordinateType;

@end
