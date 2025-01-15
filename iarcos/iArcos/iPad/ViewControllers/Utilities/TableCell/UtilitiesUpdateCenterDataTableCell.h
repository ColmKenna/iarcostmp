//
//  UtilitiesUpdateCenterDataTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 03/12/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadFunctionTableViewCellDelegate.h"
#import "UploadFunctionTableViewCellDelegate.h"
#import "ArcosUtils.h"
#import "WidgetFactory.h"
@protocol UtilitiesUpdateCenterDataTableCellDelegate <NSObject>

-(void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath;
- (UIViewController*)retrieveUtilitiesUpdateCenterParentViewController;
    
@end

@interface UtilitiesUpdateCenterDataTableCell : UITableViewCell<WidgetFactoryDelegate,UIPopoverPresentationControllerDelegate> {
    UIImageView* _icon;
    UILabel* _tableName;
    UILabel* _downloadDate;
    UILabel* _downloadModeName;
    UILabel* _tableRecordQty;
    UILabel* _downloadRecordQty;
    NSIndexPath* _indexPath;
    WidgetFactory* _factory;
//    UIPopoverController* _thePopover;
    WidgetViewController* _globalWidgetViewController;
    id<UtilitiesUpdateCenterDataTableCellDelegate> _delegate;
    id<DownloadFunctionTableViewCellDelegate> _downloadFunctionDelegate;
    id<UploadFunctionTableViewCellDelegate> _uploadFunctionDelegate;

    NSString* _sectionTitle;
    NSNumber* _iur;  // private instance variable for iur
}

@property (nonatomic, retain) IBOutlet UIImageView* icon;
@property (nonatomic, retain) IBOutlet UILabel* tableName; 
@property (nonatomic, retain) IBOutlet UILabel* downloadDate;
@property (nonatomic, retain) IBOutlet UILabel* downloadModeName; 
@property (nonatomic, retain) IBOutlet UILabel* tableRecordQty;
@property (nonatomic, retain) IBOutlet UILabel* downloadRecordQty;
@property (retain, nonatomic) IBOutlet UIProgressView *downloadProgress;
@property (nonatomic, retain) NSIndexPath* indexPath;
@property (nonatomic, retain) WidgetFactory* factory;
//@property (nonatomic, retain) UIPopoverController* thePopover;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;
@property (nonatomic, assign) id<UtilitiesUpdateCenterDataTableCellDelegate> delegate;
@property (nonatomic, assign) id<DownloadFunctionTableViewCellDelegate> downloadFunctionDelegate;
@property (nonatomic, assign) id<UploadFunctionTableViewCellDelegate> uploadFunctionDelegate;
@property (nonatomic, retain) NSString* sectionTitle;
@property (nonatomic, retain) NSNumber* iur;  // add iur as a property
@property (retain, nonatomic) IBOutlet UIButton *downloadButton;
@property (retain, nonatomic) IBOutlet UIButton *uploadButton;

-(void)configCellWithData:(NSMutableDictionary*)aCellData sectionTitle:(NSString*)aSectionTitle;

- (void)showDownloadButton;
- (void)hideDownloadButton;
- (void)showProgressBar;
- (void)hideProgressBar;

- (void)showDownloadDateLabel;
- (void)hideDownloadDateLabel;

- (void)showUploadButton;
- (void)hideUploadButton;

@end
