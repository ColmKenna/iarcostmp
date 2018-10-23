//
//  SettingTableCellFactory.h
//  Arcos
//
//  Created by David Kilmartin on 05/09/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingInputCell.h"

@interface SettingTableCellFactory : NSObject {
    
}
+(id)factory;
-(SettingInputCell*)createSettingInputCellWithData:(NSMutableDictionary*)data;
-(SettingInputCell*)createStirngInputCell;
-(SettingInputCell*)createNumberInputCell;
-(SettingInputCell*)createSwithInputCell;
-(SettingInputCell*)createSelectionInputCell;
-(NSString*)identifierWithData:(NSMutableDictionary*)data;


@end
