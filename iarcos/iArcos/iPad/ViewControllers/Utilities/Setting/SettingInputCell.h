//
//  SettingInputCell.h
//  Arcos
//
//  Created by David Kilmartin on 05/09/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingTableViewCellDelegate.h"

@interface SettingInputCell : UITableViewCell {
    id<SettingTableViewCellDelegate>delegate;
    NSMutableDictionary* cellData;
    NSIndexPath* indexPath;
    BOOL isEditable;

}
@property(nonatomic,assign)    id<SettingTableViewCellDelegate>delegate;
@property(nonatomic,retain)     NSMutableDictionary* cellData;
@property(nonatomic,retain) NSIndexPath* indexPath;
@property(nonatomic,assign)    BOOL isEditable;

-(void)configCellWithData:(NSMutableDictionary*)theData;
-(void)cancelAction;
-(void)disableEditing;
@end
