//
//  UtilitiesPresenterDetailTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 20/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "UtilitiesPresenterDetailTableCell.h"

@implementation UtilitiesPresenterDetailTableCell
@synthesize fileName;
@synthesize fileSize;
@synthesize md5;
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
    if (self.fileName != nil) { self.fileName = nil; }
    if (self.fileSize != nil) { self.fileSize = nil; }
    if (self.md5 != nil) { self.md5 = nil; }
    if (self.cellData != nil) { self.cellData = nil; }    
    if (self.indexPath != nil) { self.indexPath = nil; }            
    
    [super dealloc];
}

- (void)configCellData:(NSMutableDictionary*)theCellData {
    self.cellData = theCellData;
    self.fileName = [theCellData objectForKey:@"fileName"];
    self.fileSize = [theCellData objectForKey:@"fileSize"];
}

@end
