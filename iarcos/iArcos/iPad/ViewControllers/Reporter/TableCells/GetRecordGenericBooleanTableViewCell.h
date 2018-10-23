//
//  GetRecordGenericBooleanTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 20/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "GetRecordGenericBaseTableViewCell.h"

@interface GetRecordGenericBooleanTableViewCell : GetRecordGenericBaseTableViewCell {
    UISwitch* _contentString;
}

@property(nonatomic, retain) IBOutlet UISwitch* contentString;

- (IBAction)switchValueChanged:(id)sender;

@end
