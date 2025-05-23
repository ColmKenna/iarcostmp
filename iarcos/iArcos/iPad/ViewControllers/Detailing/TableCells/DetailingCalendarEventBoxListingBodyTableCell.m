//
//  DetailingCalendarEventBoxListingBodyTableCell.m
//  iArcos
//
//  Created by Richard on 07/03/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DetailingCalendarEventBoxListingBodyTableCell.h"

@implementation DetailingCalendarEventBoxListingBodyTableCell
@synthesize fieldDescLabel = _fieldDescLabel;
@synthesize bgView = _bgView;
@synthesize titleLabel = _titleLabel;
@synthesize locationLabel = _locationLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.fieldDescLabel = nil;
    self.bgView = nil;
    self.titleLabel = nil;
    self.locationLabel = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    [super configCellWithData:aCellData];
    NSDictionary* cellData = [aCellData objectForKey:@"FieldValue"];
//    NSString* subjectStr = [ArcosUtils convertNilToEmpty:[cellData objectForKey:@"subject"]];
//    NSDictionary* locationDict = [cellData objectForKey:@"location"];
//    NSString* locationStr = [ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"displayName"]];
//    
//    NSDictionary* cellStartDict = [cellData objectForKey:@"start"];
//    NSString* tmpCellStartDateStr = [cellStartDict objectForKey:@"dateTime"];
//    NSDate* tmpCellStartDate = [ArcosUtils dateFromString:tmpCellStartDateStr format:[GlobalSharedClass shared].datetimeCalendarFormat];
    if ([cellData objectForKey:@"Date"] == [NSNull null]) {
        self.fieldDescLabel.text = @"";
    } else {
        self.fieldDescLabel.text = [ArcosUtils stringFromDate:[cellData objectForKey:@"Date"] format:[GlobalSharedClass shared].hourMinuteFormat];
    }
    self.titleLabel.text = [cellData objectForKey:@"Subject"];
    self.locationLabel.text = [cellData objectForKey:@"Name"];
    
    
//    self.fieldDescLabel.text = [ArcosUtils stringFromDate:tmpCellStartDate format:[GlobalSharedClass shared].hourMinuteFormat];
    
//    self.fieldValueLabel.text = [ArcosUtils trim:[NSString stringWithFormat:@"%@ %@", subjectStr, locationStr]];
//    self.titleLabel.text = subjectStr;
//    self.locationLabel.text = locationStr;
//    NSNumber* tmpLocationIUR = [self.actionDelegate retrieveDetailingCalendarEventBoxListingTableCellLocationIURWithEventDict:cellData];
    NSNumber* tmpLocationIUR = [cellData objectForKey:@"LocationIUR"];
    for (UIGestureRecognizer* recognizer in self.bgView.gestureRecognizers) {
        [self.bgView removeGestureRecognizer:recognizer];
    }
    if ([tmpLocationIUR intValue] != 0 && [tmpLocationIUR isEqualToNumber:[self.actionDelegate retrieveDetailingCalendarEventBoxListingTableCellLocationIUR]]) {
//        self.fieldValueLabel.backgroundColor = [UIColor colorWithRed:1.0 green:165.0/255.0 blue:0.0 alpha:1.0];
        self.bgView.backgroundColor = [UIColor colorWithRed:1.0 green:165.0/255.0 blue:0.0 alpha:1.0];
        self.titleLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.locationLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
        doubleTap.numberOfTapsRequired = 2;
        [self.bgView addGestureRecognizer:doubleTap];
        [doubleTap release];
    } else {
//        self.fieldValueLabel.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:114.0/255.0 blue:196.0/255.0 alpha:1.0];
        self.bgView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.titleLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:114.0/255.0 blue:196.0/255.0 alpha:1.0];
        self.locationLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:114.0/255.0 blue:196.0/255.0 alpha:1.0];
    }
    
}

- (void)handleDoubleTapGesture:(id)sender {
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self.actionDelegate doubleTapBodyLabelWithIndexPath:self.myIndexPath];
    }
}

@end
