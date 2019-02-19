//
//  TargetTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 30/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "TargetTableViewCell.h"

@implementation TargetTableViewCell

@synthesize templateBarView = _templateBarView;

@synthesize targetRealValueTextField = _targetRealValueTextField;

@synthesize actualRealValueTextField = _actualRealValueTextField;
@synthesize templateDaysView = _templateDaysView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)dealloc {    
    
    [self.templateBarView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.templateBarView = nil;
    
    self.targetRealValueTextField = nil;
    
    self.actualRealValueTextField = nil;
    [self.templateDaysView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.templateDaysView = nil;
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)configCellWithData:(NSMutableDictionary*)aDataDict {
    [super configCellWithData:aDataDict];
}

- (void)constructLeftBarChartWithData:(NSMutableDictionary*)aDataDict {
    [self constructBarChartWithData:aDataDict];
    [self constructDaysChartWithData:aDataDict];
}

- (void)constructBarChartWithData:(NSMutableDictionary*)aDataDict {
    self.actualRealValueTextField.text = [NSString stringWithFormat:@"%1.0f", [[self.cellDataDict objectForKey:@"Actual"] floatValue]];
    self.targetRealValueTextField.text = [NSString stringWithFormat:@"%1.0f", [[self.cellDataDict objectForKey:@"Target"] floatValue]];
    [self.templateBarView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    float actualValue = fabsf([[aDataDict objectForKey:@"Actual"] floatValue]);
    float targetValue = fabsf([[aDataDict objectForKey:@"Target"] floatValue]);
    float auxActualPercentage = 0.0;
    if (targetValue == 0) {
        if (actualValue == 0) {
            auxActualPercentage = 0.5;
        } else {
            auxActualPercentage = 1.0;
        }        
    } else {
        auxActualPercentage = actualValue / targetValue;
    }     
    float actualPercentage = roundf(auxActualPercentage * 1000) * 0.001;
    [self configActualRealValueTextFieldPosition:actualPercentage];
    float unfinishedTargetPercentage = 1 - actualPercentage;
    NSMutableArray* barDataList = [NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:actualPercentage], [NSNumber numberWithFloat:unfinishedTargetPercentage], nil];
    NSMutableArray* keyList = [NSMutableArray arrayWithCapacity:[barDataList count]];
    NSMutableArray* objectList = [NSMutableArray arrayWithCapacity:[barDataList count]];
    for (int i = 0; i < [barDataList count]; i++) {
        [keyList addObject:[NSString stringWithFormat:@"key%d",i]];        
        TargetBarChartTableViewLabel* auxLabel = [self retrieveCustomiseLabel];
        if (auxLabel != nil) {
            [objectList addObject:auxLabel];
        }
    }
    if ([keyList count] != [objectList count]) return;
    NSDictionary* layout = [NSDictionary dictionaryWithObjects:objectList forKeys:keyList];
    for (int i = 0; i < [barDataList count]; i++) {
        NSNumber* barData = [barDataList objectAtIndex:i];
        
        UILabel* auxLabel = [objectList objectAtIndex:i];
        auxLabel.text = [NSString stringWithFormat:@"%1.1f%%", [barData floatValue] * 100];
        
        switch (i) {
            case 0:
                auxLabel.backgroundColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:0.0 alpha:1.0];
                break;
            case 1:
                auxLabel.backgroundColor = [UIColor redColor];
                break;
                
            default:
                break;
        }
        NSString* auxKey = [keyList objectAtIndex:i];
        [self.templateBarView addSubview:auxLabel];
        [auxLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSString* leadingFormat = [NSString stringWithFormat:@"|-(0)-[%@]", auxKey];
        if (i > 0) {
            NSString* auxPriorKey = [keyList objectAtIndex:i-1];
            leadingFormat = [NSString stringWithFormat:@"[%@]-(0)-[%@]", auxPriorKey, auxKey];
        }
        NSString* verticalFormat = [NSString stringWithFormat:@"V:|-(0)-[%@]-(0)-|", auxKey];
        [self.templateBarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:leadingFormat options:0 metrics:0 views:layout]];
        [self.templateBarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalFormat options:0 metrics:0 views:layout]];
        float widthPercentage = [barData floatValue];
        NSLayoutConstraint* widthLayoutConstraints = [NSLayoutConstraint constraintWithItem:auxLabel                                                                                    attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:auxLabel.superview attribute:NSLayoutAttributeWidth multiplier:widthPercentage constant:0.f];
        [self.templateBarView addConstraint:widthLayoutConstraints];
    }
}

- (void)constructDaysChartWithData:(NSMutableDictionary*)aDataDict {
    [self.templateDaysView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    float daysGoneValue = fabsf([[aDataDict objectForKey:@"DaysGone"] floatValue]);
    float daysLeftValue = fabsf([[aDataDict objectForKey:@"DaysLeft"] floatValue]);
    float daysTotalValue = daysGoneValue + daysLeftValue;
    float auxDaysGonePercentage = 0.0;
    if (daysTotalValue == 0) {
        if (daysGoneValue == 0) {
            auxDaysGonePercentage = 0.5;
        } else {
            auxDaysGonePercentage = 1.0;
        }        
    } else {
        auxDaysGonePercentage = daysGoneValue / daysTotalValue;
    }     
    float daysGonePercentage = roundf(auxDaysGonePercentage * 1000) * 0.001;
    float daysLeftPercentage = 1 - daysGonePercentage;
    NSMutableArray* daysTextList = [NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:daysGoneValue], [NSNumber numberWithFloat:daysLeftValue], nil];
    NSMutableArray* daysDataList = [NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:daysGonePercentage], [NSNumber numberWithFloat:daysLeftPercentage], nil];
    NSMutableArray* daysKeyList = [NSMutableArray arrayWithCapacity:[daysDataList count]];
    NSMutableArray* daysObjectList = [NSMutableArray arrayWithCapacity:[daysDataList count]];
    for (int i = 0; i < [daysDataList count]; i++) {
        [daysKeyList addObject:[NSString stringWithFormat:@"daysKey%d",i]];        
        TargetBarChartTableViewLabel* auxLabel = [self retrieveCustomiseLabel];
        if (auxLabel != nil) {
            [daysObjectList addObject:auxLabel];
        }
    }
    if ([daysKeyList count] != [daysObjectList count]) return;
    NSDictionary* layout = [NSDictionary dictionaryWithObjects:daysObjectList forKeys:daysKeyList];
    for (int i = 0; i < [daysDataList count]; i++) {
        NSNumber* daysData = [daysDataList objectAtIndex:i];
        NSNumber* daysText = [daysTextList objectAtIndex:i];
        UILabel* auxLabel = [daysObjectList objectAtIndex:i];
        auxLabel.layer.borderColor = [UIColor blackColor].CGColor;
        auxLabel.layer.borderWidth = 1.0f;        
        
        switch (i) {
            case 0:
                auxLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
                auxLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
                auxLabel.font = [UIFont systemFontOfSize:10.0];
                auxLabel.text = [NSString stringWithFormat:@"%1.1f%% (%1.0f Days Gone)", [daysData floatValue] * 100, [daysText floatValue]];
                break;
            case 1:
                auxLabel.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:211.0/255.0 blue:211.0/255.0 alpha:1.0];
                auxLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
                auxLabel.font = [UIFont systemFontOfSize:10.0];
                auxLabel.text = [NSString stringWithFormat:@"%1.1f%% (%1.0f Days Left)", [daysData floatValue] * 100, [daysText floatValue]];
                break;
                
            default:
                break;
        }
        NSString* auxDaysKey = [daysKeyList objectAtIndex:i];
        [self.templateDaysView addSubview:auxLabel];
        [auxLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSString* leadingFormat = [NSString stringWithFormat:@"|-(0)-[%@]", auxDaysKey];
        if (i > 0) {
            NSString* auxPriorDaysKey = [daysKeyList objectAtIndex:i-1];
            leadingFormat = [NSString stringWithFormat:@"[%@]-(0)-[%@]", auxPriorDaysKey, auxDaysKey];
        }
        NSString* verticalFormat = [NSString stringWithFormat:@"V:|-(0)-[%@]-(0)-|", auxDaysKey];
        [self.templateDaysView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:leadingFormat options:0 metrics:0 views:layout]];
        [self.templateDaysView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalFormat options:0 metrics:0 views:layout]];
        float widthPercentage = [daysData floatValue];
        NSLayoutConstraint* widthLayoutConstraints = [NSLayoutConstraint constraintWithItem:auxLabel                                                                                    attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:auxLabel.superview attribute:NSLayoutAttributeWidth multiplier:widthPercentage constant:0.f];
        [self.templateDaysView addConstraint:widthLayoutConstraints];
    }
    
}

- (void)configActualRealValueTextFieldPosition:(float)anActualPercentage {
//    NSLog(@"xz %f %f", self.templateBarView.frame.size.width, self.targetRealValueTextField.center.x);
//    NSLog(@"az %f", self.templateBarView.bounds.size.width);
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    float auxWidth = 712.0;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        auxWidth = 456.0;
    }
    float positionDiff = 0.0f;
    if ([ArcosUtils systemMajorVersion] >= 11) {
        positionDiff = 1.0f;
    }
    auxWidth = auxWidth - positionDiff;
    float actualCenterX = auxWidth * anActualPercentage + 34.0;
    float maxActualCenterX = auxWidth + 34.0 - 65.0;
    float actualCenterY = self.targetRealValueTextField.center.y;
    if (actualCenterX >= maxActualCenterX) {
        actualCenterX = auxWidth + 34.0;
        actualCenterY = self.targetRealValueTextField.center.y - 23.0;
    }
    
    self.actualRealValueTextField.center = CGPointMake(actualCenterX, actualCenterY);
}

- (TargetBarChartTableViewLabel*)retrieveCustomiseLabel {
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"TargetBarChartTableViewLabel" owner:self options:nil];
    TargetBarChartTableViewLabel* auxLabel = nil;        
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[TargetBarChartTableViewLabel class]]) {
            auxLabel = (TargetBarChartTableViewLabel*)nibItem;                
        }
    }
    return auxLabel;
}



#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}


@end
