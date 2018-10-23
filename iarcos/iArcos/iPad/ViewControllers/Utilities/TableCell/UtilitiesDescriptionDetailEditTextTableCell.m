//
//  UtilitiesDescriptionDetailEditTextTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 25/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "UtilitiesDescriptionDetailEditTextTableCell.h"

@implementation UtilitiesDescriptionDetailEditTextTableCell
@synthesize narrative = _narrative;
@synthesize contentString;

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

- (void)dealloc {
    self.narrative = nil;
    if (self.contentString != nil) { self.contentString = nil; }            
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary *)theData {
    self.cellData = theData;
    self.contentString.text = [theData objectForKey:@"contentString"];
}

-(IBAction)textInputEnd:(id)sender {
    UITextField* tf = (UITextField*)sender;
    if (self.cellData == nil) {
        self.cellData = [NSMutableDictionary dictionary];
    }
    [self.cellData setObject:tf.text forKey:@"contentString"];
    [self.cellData setObject:tf.text forKey:@"actualContent"];
    
    [self.delegate inputFinishedWithData:tf.text actualContent:tf.text WithIndexPath:self.indexPath];
}

@end
