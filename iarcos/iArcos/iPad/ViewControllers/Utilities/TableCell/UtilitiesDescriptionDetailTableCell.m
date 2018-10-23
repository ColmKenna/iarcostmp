//
//  UtilitiesDescriptionDetailTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 24/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "UtilitiesDescriptionDetailTableCell.h"

@implementation UtilitiesDescriptionDetailTableCell
@synthesize code = _code;
@synthesize details = _details;
//@synthesize activeSwitch = _activeSwitch;
@synthesize cellData;
@synthesize indexPath;

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

- (void) dealloc {
    if (self.code != nil) { self.code = nil; }
    if (self.details != nil) { self.details = nil; }   
//    if (self.activeSwitch != nil) { self.activeSwitch = nil; }
    if (self.cellData != nil) { self.cellData = nil; }
    if (self.indexPath != nil) { self.indexPath = nil; }
    
    [super dealloc];
}

- (void)configCellData:(NSMutableDictionary*)theCellData {
    self.cellData = theCellData;
    self.code.text = [theCellData objectForKey:@"DescrDetailCode"];
    self.details.text = [theCellData objectForKey:@"Detail"];
    NSNumber* active = [theCellData objectForKey:@"Active"];
    if ([active intValue] == 1) {
        self.code.textColor = [UIColor blackColor];
        self.details.textColor = [UIColor blackColor];
//        self.activeSwitch.on = YES;
    } else {
        self.code.textColor = [UIColor redColor];
        self.details.textColor = [UIColor redColor];
//        self.activeSwitch.on = NO;
    }
}

@end
