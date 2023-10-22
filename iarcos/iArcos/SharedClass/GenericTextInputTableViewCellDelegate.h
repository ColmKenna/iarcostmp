//
//  GenericTextInputTableViewCellDelegate.h
//  iArcos
//
//  Created by Richard on 17/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol GenericTextInputTableViewCellDelegate <NSObject>
- (void)inputFinishedWithData:(NSString*)aData forIndexPath:(NSIndexPath*)anIndexPath;
@end

