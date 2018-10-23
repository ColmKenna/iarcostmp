//
//  SettingInputCell.m
//  Arcos
//
//  Created by David Kilmartin on 05/09/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "SettingInputCell.h"


@implementation SettingInputCell
@synthesize delegate;
@synthesize cellData;
@synthesize indexPath;
@synthesize isEditable;

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
-(void)disableEditing{
    
}
- (void)dealloc
{
//    if (self.delegate != nil) { self.delegate = nil; }
    if (self.cellData != nil) { self.cellData = nil; }
    if (self.indexPath != nil) { self.indexPath = nil; }        
    
    [super dealloc];
}
-(void)configCellWithData:(NSMutableDictionary*)theData{
    
}
-(void)cancelAction{
    
}
@end
