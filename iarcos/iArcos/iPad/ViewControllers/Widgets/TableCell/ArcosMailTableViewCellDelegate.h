//
//  ArcosMailTableViewCellDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 06/02/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ArcosMailTableViewCellDelegate <NSObject>

- (void)updateMailBodyHeight:(NSIndexPath*)anIndexPath;
- (void)updateSubjectText:(NSString*)aText;

@end
