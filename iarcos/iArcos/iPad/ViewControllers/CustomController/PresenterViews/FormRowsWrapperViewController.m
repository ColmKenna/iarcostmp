//
//  FormRowsWrapperViewController.m
//  iArcos
//
//  Created by David Kilmartin on 13/06/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "FormRowsWrapperViewController.h"

@interface FormRowsWrapperViewController ()

@end

@implementation FormRowsWrapperViewController
@synthesize myDelegate = _myDelegate;
@synthesize actionDelegate = _actionDelegate;
@synthesize customiseTemplateView = _customiseTemplateView;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize formRowsTableViewController = _formRowsTableViewController;
@synthesize layoutDict = _layoutDict;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.formRowsTableViewController = [[[FormRowsTableViewController alloc] initWithNibName:@"FormRowsTableViewController" bundle:nil] autorelease];
        self.formRowsTableViewController.isStandardOrderPadFlag = YES;
        self.formRowsTableViewController.actionDelegate = self;
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.formRowsTableViewController] autorelease];
        self.layoutDict = @{@"AuxFormRows" : self.globalNavigationController.view};
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
    [singleTap release];
    
    [self addChildViewController:self.globalNavigationController];
    [self.customiseTemplateView addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self];
    [self.globalNavigationController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.customiseTemplateView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[AuxFormRows]-(0)-|" options:0 metrics:0 views:self.layoutDict]];
    [self.customiseTemplateView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[AuxFormRows]-(0)-|" options:0 metrics:0 views:self.layoutDict]];
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:self.customiseTemplateView.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(10.0f, 10.0f)];
    
    CAShapeLayer* maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.customiseTemplateView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.customiseTemplateView.layer.mask = maskLayer;
    [maskLayer release];
}

- (void)dealloc {
    for (UIGestureRecognizer* recognizer in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:recognizer];
    }    
    [self.globalNavigationController willMoveToParentViewController:nil];
    [self.globalNavigationController.view removeFromSuperview];
    [self.globalNavigationController removeFromParentViewController];
    self.globalNavigationController = nil;
    self.formRowsTableViewController = nil;    
    self.layoutDict = nil;
    self.customiseTemplateView = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
     
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)handleSingleTapGesture:(id)sender {
    [self.myDelegate didDismissCustomisePartialPresentView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint touchPoint = [touch locationInView:self.customiseTemplateView];
    return ![self.customiseTemplateView hitTest:touchPoint withEvent:nil];
}

#pragma mark FormRowsTableViewControllerDelegate
- (void)didPressCheckoutButton {
    [self.actionDelegate didPressCheckoutButton];
}

@end
