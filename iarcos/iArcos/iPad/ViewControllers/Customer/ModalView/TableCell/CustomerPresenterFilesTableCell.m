//
//  CustomerPresenterFilesTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 08/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerPresenterFilesTableCell.h"

@implementation CustomerPresenterFilesTableCell
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

- (void) dealloc {
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellData:(NSMutableDictionary*)theCellData {
    self.cellData = theCellData;
    self.fileName = [theCellData objectForKey:@"fileName"];
    self.fileSize = [theCellData objectForKey:@"fileSize"];
}

@end
