//
//  CheckLocationIURTemplateDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 20/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CheckLocationIURTemplateDelegate <NSObject>
- (void)succeedToCheckSameLocationIUR:(NSIndexPath*)indexPath;
- (void)succeedToCheckNewLocationIUR:(NSIndexPath*)indexPath;
- (void)failToCheckLocationIUR:(NSString*)aTitle;
@end
