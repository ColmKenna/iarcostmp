//
//  TargetTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 30/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TargetBarChartTableViewLabel.h"
#import "ArcosUtils.h"
#import "TargetBaseTableViewCell.h"

@interface TargetTableViewCell : TargetBaseTableViewCell <UITextFieldDelegate> {    
    
    UIView* _templateBarView;
    
    
    UITextField* _targetRealValueTextField;
    
    UITextField* _actualRealValueTextField;
    UIView* _templateDaysView;
}



@property(nonatomic, retain) IBOutlet UIView* templateBarView;


@property(nonatomic, retain) IBOutlet UITextField* targetRealValueTextField;

@property(nonatomic, retain) IBOutlet UITextField* actualRealValueTextField;
@property(nonatomic, retain) IBOutlet UIView* templateDaysView;




@end
