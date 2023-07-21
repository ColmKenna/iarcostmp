//
//  SettingTableViewCellDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 05/09/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SettingTableViewCellDelegate 
-(void)editStartForIndexpath:(NSIndexPath*)theIndexpath;
-(void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath;
-(void)invalidDataForIndexpath:(NSString*)theIndexpath;
-(void)popoverShows:(UIPopoverController*)aPopover;
@optional
-(UIViewController*)retrieveParentViewController;
- (void)presenterHeaderPressedWithIndexPath:(NSIndexPath*)anIndexpath;
- (void)shownButtonPressedWithValue:(BOOL)aValue atIndexPath:(NSIndexPath*)anIndexPath;
- (BOOL)presenterParentHasShownChild:(NSNumber*)aDescrDetailIUR;
@end
