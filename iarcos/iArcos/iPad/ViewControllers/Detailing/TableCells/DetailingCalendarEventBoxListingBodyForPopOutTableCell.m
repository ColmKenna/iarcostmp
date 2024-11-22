//
//  DetailingCalendarEventBoxListingBodyForPopOutTableCell.m
//  iArcos
//
//  Created by Richard on 21/11/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "DetailingCalendarEventBoxListingBodyForPopOutTableCell.h"

@implementation DetailingCalendarEventBoxListingBodyForPopOutTableCell
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
    if ([cellData objectForKey:@"Date"] == [NSNull null]) {
        self.fieldDescLabel.text = @"";
    } else {
        self.fieldDescLabel.text = [ArcosUtils stringFromDate:[cellData objectForKey:@"Date"] format:[GlobalSharedClass shared].hourMinuteFormat];
    }
    self.titleLabel.text = [cellData objectForKey:@"Subject"];
    self.locationLabel.text = [cellData objectForKey:@"Name"];
    

    
    for (UIGestureRecognizer* recognizer in self.bgView.gestureRecognizers) {
        [self.bgView removeGestureRecognizer:recognizer];
    }
//    self.bgView.backgroundColor = [UIColor colorWithRed:1.0 green:165.0/255.0 blue:0.0 alpha:1.0];
//    self.titleLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
//    self.locationLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.bgView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.titleLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:114.0/255.0 blue:196.0/255.0 alpha:1.0];
    self.locationLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:114.0/255.0 blue:196.0/255.0 alpha:1.0];
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.bgView addGestureRecognizer:doubleTap];
    [doubleTap release];
    
}

- (void)handleDoubleTapGesture:(id)sender {
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self.actionDelegate doubleTapBodyLabelForPopOutWithIndexPath:self.myIndexPath];
    }
}

@end
