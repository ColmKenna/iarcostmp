//
//  CustomerInfoNextCallTableViewCell.h
//  iArcos
//
//  Created by Richard on 14/11/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "CustomerInfoBaseTableViewCell.h"



@interface CustomerInfoNextCallTableViewCell : CustomerInfoBaseTableViewCell {
    UIButton* _actionBtn;
}

@property(nonatomic, retain) IBOutlet UIButton* actionBtn;

@end


