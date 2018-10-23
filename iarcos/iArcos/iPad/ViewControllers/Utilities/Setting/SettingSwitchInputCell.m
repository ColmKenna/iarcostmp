//
//  SettingSwitchInputCell.m
//  Arcos
//
//  Created by David Kilmartin on 05/09/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "SettingSwitchInputCell.h"


@implementation SettingSwitchInputCell
@synthesize label;
@synthesize switchBut;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)swithTouchDown:(id)sender{
}
-(void)swithValueChange:(id)sender{
    UISwitch* sw=(UISwitch*)sender;
    [self.delegate inputFinishedWithData:[NSNumber numberWithBool:sw.on] forIndexpath:self.indexPath];
}
-(void)configCellWithData:(NSMutableDictionary*)theData{
    self.cellData=theData;
    self.label.text=[theData objectForKey:@"Label"];
    self.switchBut.on=[[theData objectForKey:@"Value"]boolValue];
}
- (void)dealloc
{
    if (self.label != nil) { self.label = nil; }
    if (self.switchBut != nil) { self.switchBut = nil; }        
    
    [super dealloc];
}

@end
