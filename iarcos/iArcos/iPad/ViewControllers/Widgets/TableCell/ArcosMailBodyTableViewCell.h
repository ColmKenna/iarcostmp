//
//  ArcosMailBodyTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 01/02/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosMailBaseTableViewCell.h"
#import "ArcosMailDataUtils.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ArcosMailBodyTableViewCell : ArcosMailBaseTableViewCell <UITextViewDelegate, UIWebViewDelegate>{
    UITextView* _fieldContent;
    UIWebView* _myWebView;
    JSContext* _myContext;
}

@property(nonatomic, retain) IBOutlet UITextView* fieldContent;
@property(nonatomic, retain) IBOutlet UIWebView* myWebView;
@property(nonatomic, retain) JSContext* myContext;

- (void)cleanData;

@end
