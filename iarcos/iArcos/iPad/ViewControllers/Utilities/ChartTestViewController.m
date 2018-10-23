//
//  ChartTestViewController.m
//  iArcos
//
//  Created by David Kilmartin on 10/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "ChartTestViewController.h"

@interface ChartTestViewController ()

@end

@implementation ChartTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc {
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];    
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
