//
//  SettingNumberInputCell.m
//  Arcos
//
//  Created by David Kilmartin on 05/09/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "SettingNumberInputCell.h"
#import "GlobalSharedClass.h"

@implementation SettingNumberInputCell
@synthesize label;
@synthesize textfield;
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
-(IBAction)textInputStart:(id)sender{
    [self.delegate editStartForIndexpath:self.indexPath];

}
-(IBAction)textInputEnd:(id)sender{
    UITextField* tf=(UITextField*)sender;
    if (![[GlobalSharedClass shared]isNumeric:tf.text]) {
        // open an alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" 
                                                        message:@"The input is not valid" delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];	
        [alert release];
    }else{
        [self.delegate inputFinishedWithData:[NSNumber numberWithInt:[tf.text intValue]] forIndexpath:self.indexPath];
    }
}
-(void)configCellWithData:(NSMutableDictionary*)theData{
    self.cellData=theData;
    self.label.text=[theData objectForKey:@"Label"];
    self.textfield.text=[[theData objectForKey:@"Value"]stringValue];

}
- (void)dealloc
{
    if (self.label != nil) { self.label = nil; }
    if (self.textfield != nil) { self.textfield = nil; }        
    
    [super dealloc];
}

@end
