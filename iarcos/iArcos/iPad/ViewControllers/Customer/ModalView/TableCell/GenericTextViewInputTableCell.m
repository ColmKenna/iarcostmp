//
//  GenericTextViewInputTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 11/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "GenericTextViewInputTableCell.h"

@implementation GenericTextViewInputTableCell
@synthesize delegate = _delegate;
@synthesize cellData = _cellData;
@synthesize indexPath = _indexPath;


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
    if (self.delegate != nil) { self.delegate = nil; }            
    if (self.cellData != nil) { self.cellData = nil; }            
    if (self.indexPath != nil) { self.indexPath = nil; }
            
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    
}

@end
