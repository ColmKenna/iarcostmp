//
//  ReporterXmlSubTableHeaderView.h
//  iArcos
//
//  Created by Richard on 21/01/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReporterXmlSubTableHeaderView : UIView {
    UILabel* _countLabel;
    UILabel* _descriptionLabel;
    UILabel* _qtyLabel;
    UILabel* _valueLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* countLabel;
@property(nonatomic, retain) IBOutlet UILabel* descriptionLabel;
@property(nonatomic, retain) IBOutlet UILabel* qtyLabel;
@property(nonatomic, retain) IBOutlet UILabel* valueLabel;

@end


