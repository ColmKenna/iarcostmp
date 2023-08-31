//
//  CustomerSurveyTypesTableCellDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 10/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomerSurveyTypesTableCellDelegate <NSObject>

-(void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath;
@optional
//-(void)popoverShows:(UIPopoverController*)aPopover;
-(void)showSurveyDetail;
- (void)pressPhotoButtonDelegateWithIndexPath:(NSIndexPath*)anIndexpath;
- (void)pressPreviewButtonDelegateWithIndexPath:(NSIndexPath*)anIndexpath;
- (NSMutableDictionary*)retrieveRankingHashMap;
- (void)refreshSurveyList;
- (UITableView*)retrieveSurveyTableView;
- (UIViewController*)retrieveParentViewController;
@end
