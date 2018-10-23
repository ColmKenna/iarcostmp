//
//  SettingSwitchInputCell.h
//  Arcos
//
//  Created by David Kilmartin on 05/09/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingInputCell.h"


@interface SettingSwitchInputCell : SettingInputCell {
    
    IBOutlet UILabel* label;
    IBOutlet UISwitch* switchBut;
}
@property(nonatomic,retain) IBOutlet UILabel* label;
@property(nonatomic,retain) IBOutlet UISwitch* switchBut;

-(IBAction)swithValueChange:(id)sender;
-(IBAction)swithTouchDown:(id)sender;

@end
