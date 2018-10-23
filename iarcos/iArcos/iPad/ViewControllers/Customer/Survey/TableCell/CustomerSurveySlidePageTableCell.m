//
//  CustomerSurveySlidePageTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 16/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveySlidePageTableCell.h"

@implementation CustomerSurveySlidePageTableCell
@synthesize responseLimit;

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
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary *)theData {
    self.cellData = theData;
    self.responseLimit.text = [theData objectForKey:@"Title"];
}


@end
