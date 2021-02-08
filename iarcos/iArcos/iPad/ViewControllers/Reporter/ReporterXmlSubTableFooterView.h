//
//  ReporterXmlSubTableFooterView.h
//  iArcos
//
//  Created by Richard on 06/02/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReporterXmlSubTableFooterView : UIView {
    UILabel* _countSumLabel;
    UILabel* _totalLabel;
    UILabel* _qtySumLabel;
    UILabel* _valueSumLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* countSumLabel;
@property(nonatomic, retain) IBOutlet UILabel* totalLabel;
@property(nonatomic, retain) IBOutlet UILabel* qtySumLabel;
@property(nonatomic, retain) IBOutlet UILabel* valueSumLabel;

@end


