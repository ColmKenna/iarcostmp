//
//  DashboardGenericTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 15/05/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "DashboardGenericTableViewCell.h"

@implementation DashboardGenericTableViewCell
//@synthesize labelViewList = _labelViewList;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
//    for (int i = 0; i < [self.labelViewList count]; i++) {
//        UILabel* auxLabel = [self.labelViewList objectAtIndex:i];
//        [auxLabel removeFromSuperview];
//    }
//    self.labelViewList = nil;
    
    NSLog(@"prior %lu %@", (unsigned long)[self.contentView.constraints count], self.contentView.constraints);
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSLog(@"rear %lu %@", (unsigned long)[self.contentView.constraints count], self.contentView.constraints);
    [super dealloc];
}

- (void)configCellWithDataList:(NSMutableArray*)aDataList {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray* keyList = [NSMutableArray arrayWithCapacity:[aDataList count]];
    NSMutableArray* objectList = [NSMutableArray arrayWithCapacity:[aDataList count]];
    for (int i = 0; i < [aDataList count]; i++) {
        [keyList addObject:[NSString stringWithFormat:@"key%d",i]];
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"DashboardGenericTableViewLabel" owner:self options:nil];
        DashboardGenericTableViewLabel* auxLabel = nil;        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[DashboardGenericTableViewLabel class]]) {
                auxLabel = (DashboardGenericTableViewLabel*)nibItem;                
            }
        }
        if (auxLabel != nil) {
            [objectList addObject:auxLabel];
        }        
    }
    if ([keyList count] != [objectList count]) return;
    
    NSDictionary* layout = [NSDictionary dictionaryWithObjects:objectList forKeys:keyList];
    for (int i = 0; i < [aDataList count]; i++) {
        NSMutableDictionary* cellData = [aDataList objectAtIndex:i];
        
        UILabel* auxLabel = [objectList objectAtIndex:i];
        auxLabel.text = [cellData objectForKey:@"fieldDesc"];
        auxLabel.textAlignment = [[cellData objectForKey:@"fieldAlignment"] intValue];
        switch (i) {
            case 0:
                auxLabel.backgroundColor = [UIColor redColor];
                break;
            case 1:
                auxLabel.backgroundColor = [UIColor greenColor];
                break;
            case 2:
                auxLabel.backgroundColor = [UIColor cyanColor];
                break;
                
            default:
                break;
        }
        NSString* auxKey = [keyList objectAtIndex:i];
        [self.contentView addSubview:auxLabel];
        [auxLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSString* leadingFormat = [NSString stringWithFormat:@"|-(0)-[%@]", auxKey];
        if (i > 0) {
            NSString* auxPriorKey = [keyList objectAtIndex:i-1];
            leadingFormat = [NSString stringWithFormat:@"[%@]-(0)-[%@]", auxPriorKey, auxKey];
//            leadingFormat = [NSString stringWithFormat:@"[%@]-(0)-[%@(==%@)]", auxPriorKey, auxKey, auxPriorKey];
        }
//        if (i == [aDataList count] - 1) {
//            NSString* trailingFormat = [NSString stringWithFormat:@"[%@]-(0)-|", auxKey];
//            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:trailingFormat options:0 metrics:0 views:layout]];
//        }
        NSString* verticalFormat = [NSString stringWithFormat:@"V:|-(0)-[%@]-(0)-|", auxKey];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:leadingFormat options:0 metrics:0 views:layout]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalFormat options:0 metrics:0 views:layout]];
        float widthPercentage = [[cellData objectForKey:@"fieldPercent"] floatValue];
        NSLayoutConstraint* widthLayoutConstraints = [NSLayoutConstraint constraintWithItem:auxLabel                                                                                    attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:auxLabel.superview attribute:NSLayoutAttributeWidth multiplier:widthPercentage constant:0.f];
        [self.contentView addConstraint:widthLayoutConstraints];
    }
}

@end
