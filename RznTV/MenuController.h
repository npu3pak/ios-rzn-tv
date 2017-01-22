//
// Created by Евгений Сафронов on 24.02.15.
// Copyright (c) 2015 rzn.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AppSection;
@protocol PAppSectionContentView;

@interface MenuController : UITableViewController

@property id <PAppSectionContentView> contentView;

@end

@protocol PAppSectionContentView

- (void)showSection:(AppSection *)section;

@end