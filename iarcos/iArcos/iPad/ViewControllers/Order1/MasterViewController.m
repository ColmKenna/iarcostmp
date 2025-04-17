//
//  MasterViewController.m
//  iArcos
//
//  Created by Colm Kenna on 21/03/2025.
//  Copyright © 2025 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MasterViewController.h"
#import "UIColor+Hex.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.contentInset = UIEdgeInsetsZero;
}

// MARK: - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectionIndexList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *entry = self.sectionIndexList[indexPath.row];
    NSString *title = entry[@"title"];
    NSString *type = entry[@"type"];

    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont systemFontOfSize:16 weight:[type isEqualToString:@"divider"] ? UIFontWeightBold : UIFontWeightRegular];

    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *containerView = [[UIView alloc] init];
    UILabel *headerLabel = [[UILabel alloc] init];
    
    //containerView.layer.cornerRadius = 2.0;
    //containerView.clipsToBounds = YES;
//    containerView.backgroundColor = [UIColor borderColor];

    
    headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    headerLabel.text = @"Master List";
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor borderColor];
    //    headerLabel.backgroundColor = [UIColor systemGroupedBackgroundColor];
    headerLabel.layer.cornerRadius = 10.0;
    headerLabel.clipsToBounds = YES;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"AmazonEmber-Regular" size:18];

    
    [containerView addSubview:headerLabel];

    [NSLayoutConstraint activateConstraints:@[
        [headerLabel.leadingAnchor constraintEqualToAnchor:containerView.layoutMarginsGuide.leadingAnchor],
        [headerLabel.trailingAnchor constraintEqualToAnchor:containerView.layoutMarginsGuide.trailingAnchor],
        [headerLabel.topAnchor constraintEqualToAnchor:containerView.topAnchor],
        [headerLabel.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor],
    ]];

    return containerView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *entry = self.sectionIndexList[indexPath.row];
    NSIndexPath *targetIndexPath = entry[@"indexPath"];

    if (self.detailTableView && targetIndexPath) {
        [self.detailTableView scrollToRowAtIndexPath:targetIndexPath
                                    atScrollPosition:UITableViewScrollPositionTop
                                            animated:YES];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

@end
