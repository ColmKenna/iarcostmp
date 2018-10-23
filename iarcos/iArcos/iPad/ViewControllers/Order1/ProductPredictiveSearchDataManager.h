//
//  ProductPredictiveSearchDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 24/11/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormRowSearchDelegate.h"

@interface ProductPredictiveSearchDataManager : NSObject <FormRowSearchDelegate> {
    id _target;
    SEL _textDidBeginEditingSelector;
    SEL _textDidEndEditingSelector;
    SEL _textDidChangeSelector;
    SEL _searchButtonClickedSelector;
    SEL _cancelButtonClickedSelector;    
}

@property(nonatomic, assign) id target;
@property(nonatomic, assign) SEL textDidBeginEditingSelector;
@property(nonatomic, assign) SEL textDidEndEditingSelector;
@property(nonatomic, assign) SEL textDidChangeSelector;
@property(nonatomic, assign) SEL searchButtonClickedSelector;
@property(nonatomic, assign) SEL cancelButtonClickedSelector;

- (id)initWithTarget:(id)aTarget;

@end
