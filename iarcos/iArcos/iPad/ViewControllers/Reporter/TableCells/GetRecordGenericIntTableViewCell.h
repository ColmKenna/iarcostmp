//
//  GetRecordGenericIntTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 20/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "GetRecordGenericBaseTableViewCell.h"
#import "ArcosUtils.h"

@interface GetRecordGenericIntTableViewCell : GetRecordGenericBaseTableViewCell <UITextFieldDelegate>{
    UITextField* _contentString;
}

@property(nonatomic, retain) IBOutlet UITextField* contentString;

- (IBAction)textInputEnded:(id)sender;

@end
