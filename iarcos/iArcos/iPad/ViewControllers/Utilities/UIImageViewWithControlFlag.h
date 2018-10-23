//
//  UIImageViewWithControlFlag.h
//  Arcos
//
//  Created by David Kilmartin on 19/06/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageViewWithControlFlag : UIImageView {
    BOOL _isInMiniMode;
    BOOL _isLocked;
}

@property (nonatomic, assign) BOOL isInMiniMode;
@property (nonatomic, assign) BOOL isLocked;

@end
