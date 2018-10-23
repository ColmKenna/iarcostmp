//
//  QueryOrderTaskDateTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 28/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "QueryOrderTaskDateTableCell.h"

@implementation QueryOrderTaskDateTableCell
@synthesize fieldDesc = _fieldDesc;
@synthesize contentString = _contentString;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    self.fieldDesc = nil;
    self.contentString = nil;
    
    [super dealloc];
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configCellWithData:(NSMutableDictionary*)theData{
    self.cellData = theData;
    self.fieldDesc.text = [theData objectForKey:@"fieldDesc"];
    self.contentString.text = [theData objectForKey:@"contentString"];
    
    NSString* securityLevel = [theData objectForKey:@"securityLevel"];
    if (self.employeeSecurityLevel >= [securityLevel intValue]) {
        self.contentString.enabled = YES;
        self.contentString.textColor = [UIColor blueColor];
    } else {
        self.contentString.enabled = NO;
        self.contentString.textColor = [UIColor blackColor];
    }
}

@end
