//
//  SettingNumberInputCell.h
//  Arcos
//
//  Created by David Kilmartin on 05/09/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingInputCell.h"


@interface SettingNumberInputCell : SettingInputCell {
    IBOutlet UILabel* label;
    IBOutlet UITextField* textfield;
}
@property(nonatomic,retain) IBOutlet UILabel* label;
@property(nonatomic,retain) IBOutlet UITextField* textfield;

-(IBAction)textInputEnd:(id)sender;
-(IBAction)textInputStart:(id)sender;

@end
