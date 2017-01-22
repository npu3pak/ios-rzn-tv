//
// Created by Евгений Сафронов on 24.02.15.
// Copyright (c) 2015 rzn.tv. All rights reserved.
//

#import <MMDrawerController/MMDrawerController.h>
#import "MenuController.h"
#import "AppSection.h"
#import "UIViewController+MMDrawerController.h"
#import "DataSource.h"

@implementation MenuController {
    NSArray *_sections;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _sections = [[DataSource sharedDataSource] sections];

    if (_sections.count > 0) {
        [self.contentView showSection:_sections[0]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppSection *section = _sections[(NSUInteger) indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"navigationCell"];
    cell.textLabel.text = section.title;
    cell.imageView.image = section.icon;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppSection *section = _sections[(NSUInteger) indexPath.row];
    [self.contentView showSection:section];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end