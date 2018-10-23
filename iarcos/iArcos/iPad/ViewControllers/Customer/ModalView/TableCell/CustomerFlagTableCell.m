//
//  CustomerFlagTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 11/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerFlagTableCell.h"

@implementation CustomerFlagTableCell
@synthesize flagText = _flagText;
@synthesize myImageView = _myImageView;

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

- (void)configCellWithData:(NSMutableDictionary*)theData {
    self.cellData = theData;
    self.flagText.text = [theData objectForKey:@"Detail"];
/**    
    if ([[theData objectForKey:@"LocationFlag"] intValue] == 0) {
        self.accessoryType = UITableViewCellAccessoryNone;
    } else {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    if ([[theData objectForKey:@"Active"] intValue] == 0) {
        self.flagText.textColor = [UIColor redColor];
    } else {
        self.flagText.textColor = [UIColor blackColor];
    }
*/        
}

- (void)dealloc
{        
    if (self.flagText != nil) { self.flagText = nil; }
    self.myImageView = nil;
            
    [super dealloc];
}

@end
