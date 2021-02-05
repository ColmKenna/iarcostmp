//
//  CustomerBaseTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 09/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerBaseTableCell.h"

@implementation CustomerBaseTableCell
@synthesize delegate = _delegate;
@synthesize cellData;
@synthesize indexPath;
@synthesize employeeSecurityLevel = _employeeSecurityLevel;
@synthesize redAsterixLabel = _redAsterixLabel;

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

- (void)dealloc
{
//    if (self.delegate != nil) {
//        self.delegate = nil;
//    }
    if (self.cellData != nil) {
        self.cellData = nil;
    }
    if (self.indexPath != nil) {
        self.indexPath = nil;
    }
    self.redAsterixLabel = nil;
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData{
    
}

- (void)configRedAsterix {
//    NSMutableAttributedString* attributedFieldDescString = [[NSMutableAttributedString alloc] initWithString:[self.cellData objectForKey:@"fieldDesc"] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0], NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}];
//    NSAttributedString* attributedRedAsterixString = [[NSAttributedString alloc] initWithString:@"*" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0], NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}];
//    [attributedFieldDescString appendAttributedString:attributedRedAsterixString];
//    aFieldDesc.attributedText = attributedFieldDescString;
//    [attributedRedAsterixString release];
//    [attributedFieldDescString release];
    self.redAsterixLabel.hidden = NO;
}

@end
