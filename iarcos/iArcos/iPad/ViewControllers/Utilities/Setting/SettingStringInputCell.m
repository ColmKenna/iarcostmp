//
//  SettingStringInputCell.m
//  Arcos
//
//  Created by David Kilmartin on 05/09/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "SettingStringInputCell.h"


@implementation SettingStringInputCell
@synthesize  label;
@synthesize  textfield;

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

-(IBAction)textInputEnd:(id)sender{
    UITextField* tf=(UITextField*)sender;
    [self.delegate inputFinishedWithData:tf.text forIndexpath:self.indexPath];
}
-(IBAction)textInputStart:(id)sender{
    [self.delegate editStartForIndexpath:self.indexPath];
}
- (void)dealloc
{
    if (self.label != nil) { self.label = nil; }
    if (self.textfield != nil) { self.textfield = nil; }        
    
    [super dealloc];
}
-(void)configCellWithData:(NSMutableDictionary*)theData{
    if ([[theData objectForKey:@"Label"] isEqualToString:@"SQL Password"]) {
        [self.textfield setSecureTextEntry:YES];
    } else {
        [self.textfield setSecureTextEntry:NO];
    }
    self.cellData=theData;
    self.label.text=[theData objectForKey:@"Label"];
    self.textfield.text=[theData objectForKey:@"Value"];
    
}
@end
