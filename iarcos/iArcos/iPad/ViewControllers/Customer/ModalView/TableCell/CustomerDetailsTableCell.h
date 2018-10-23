//
//  CustomerDetailsTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 03/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerDetailsTableCell : UITableViewCell {
    IBOutlet UILabel* fieldDesc;
    IBOutlet UITextField* contentString;
    NSString* fieldType;
    NSString* actualContent;
    NSString* originalIndex;
}

@property (nonatomic,retain) IBOutlet UILabel* fieldDesc;
@property (nonatomic,retain) IBOutlet UITextField* contentString;
@property (nonatomic,retain) NSString* fieldType;
@property (nonatomic,retain) NSString* actualContent;
@property (nonatomic,retain) NSString* originalIndex;

@end
