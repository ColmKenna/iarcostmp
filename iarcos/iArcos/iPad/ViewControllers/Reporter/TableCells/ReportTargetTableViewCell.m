//
//  ReportTargetTableViewCell.m
//  iArcos
//
//  Created by Richard on 24/05/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "ReportTargetTableViewCell.h"

@implementation ReportTargetTableViewCell
@synthesize descriptionLabel = _descriptionLabel;
@synthesize q1TargetLabel = _q1TargetLabel;
@synthesize q1ActualLabel = _q1ActualLabel;
@synthesize q1PercentageLabel = _q1PercentageLabel;
@synthesize q2TargetLabel = _q2TargetLabel;
@synthesize q2ActualLabel = _q2ActualLabel;
@synthesize q2PercentageLabel = _q2PercentageLabel;
@synthesize q3TargetLabel = _q3TargetLabel;
@synthesize q3ActualLabel = _q3ActualLabel;
@synthesize q3PercentageLabel = _q3PercentageLabel;
@synthesize q4TargetLabel = _q4TargetLabel;
@synthesize q4ActualLabel = _q4ActualLabel;
@synthesize q4PercentageLabel = _q4PercentageLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.descriptionLabel = nil;
    self.q1TargetLabel = nil;
    self.q1ActualLabel = nil;
    self.q1PercentageLabel = nil;
    self.q2TargetLabel = nil;
    self.q2ActualLabel = nil;
    self.q2PercentageLabel = nil;
    self.q3TargetLabel = nil;
    self.q3ActualLabel = nil;
    self.q3PercentageLabel = nil;
    self.q4TargetLabel = nil;
    self.q4ActualLabel = nil;
    self.q4PercentageLabel = nil;
    
    [super dealloc];
}

- (void)setDataXML:(CXMLElement*)element {
    NSMutableDictionary* elementDict = [self convertElementToDict:element];
    self.descriptionLabel.text = [elementDict objectForKey:@"Title"];
    self.q1TargetLabel.text = [elementDict objectForKey:@"Target1"];
    self.q1ActualLabel.text = [elementDict objectForKey:@"Actual1"];
    self.q1PercentageLabel.text = [elementDict objectForKey:@"ActualPercentage1"];
    self.q2TargetLabel.text = [elementDict objectForKey:@"Target2"];
    self.q2ActualLabel.text = [elementDict objectForKey:@"Actual2"];
    self.q2PercentageLabel.text = [elementDict objectForKey:@"ActualPercentage2"];
    self.q3TargetLabel.text = [elementDict objectForKey:@"Target3"];
    self.q3ActualLabel.text = [elementDict objectForKey:@"Actual3"];
    self.q3PercentageLabel.text = [elementDict objectForKey:@"ActualPercentage3"];
    self.q4TargetLabel.text = [elementDict objectForKey:@"Target4"];
    self.q4ActualLabel.text = [elementDict objectForKey:@"Actual4"];
    self.q4PercentageLabel.text = [elementDict objectForKey:@"ActualPercentage4"];
}

@end
