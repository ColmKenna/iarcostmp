//
//  CustomerSurveyBaseTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 10/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyBaseTableCell.h"
#import "ArcosCoreData.h"

@implementation CustomerSurveyBaseTableCell
@synthesize delegate;
@synthesize cellData;
@synthesize indexPath;
@synthesize locationIUR = _locationIUR;
@synthesize locationName = _locationName;
@synthesize indicatorButton = _indicatorButton;

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

-(void)configCellWithData:(NSMutableDictionary*)theData{
    
}

- (void)configNarrativeWithLabel:(UILabel*)aLabel {
    aLabel.textColor = [UIColor blackColor];
    if ([[self.cellData objectForKey:@"Highlight"] boolValue] && [[self.cellData objectForKey:@"active"] boolValue]) {
        NSString* tmpAnswer = [self.cellData objectForKey:@"Answer"];
        if ([tmpAnswer isEqualToString:@""] || [tmpAnswer isEqualToString:[GlobalSharedClass shared].unknownText]) {
            aLabel.textColor = [UIColor redColor];
        }
    }
}

- (void)dealloc {
//    if (self.delegate != nil) { self.delegate = nil; }
    if (self.cellData != nil) { self.cellData = nil; }
    if (self.indexPath != nil) { self.indexPath = nil; }
    if (self.locationIUR != nil) { self.locationIUR = nil; }
    if (self.locationName != nil) { self.locationName = nil; }
    self.indicatorButton = nil;
    
    [super dealloc];
}

- (void)processIndicatorButton {
    UIImage* indicatorImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:[NSNumber numberWithInt:142]];
    if (![[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[self.cellData objectForKey:@"tooltip"]]] isEqualToString:@""] && indicatorImage != nil) {
        [self.indicatorButton setImage:indicatorImage forState:UIControlStateNormal];
    } else {
        [self.indicatorButton setImage:nil forState:UIControlStateNormal];
    }
}

@end
