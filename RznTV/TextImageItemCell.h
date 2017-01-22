//
// Created by Евгений Сафронов on 25.02.15.
// Copyright (c) 2015 rzn.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AppSectionItem;
@class IPInsetLabel;
@class DLImageView;

@interface TextImageItemCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UIImageView *previewImage;
@property(strong, nonatomic) IBOutlet IPInsetLabel *timestamp;
@property(strong, nonatomic) IBOutlet IPInsetLabel *title;
@property(strong, nonatomic) IBOutlet IPInsetLabel *note;

- (void)showPreviewItem:(AppSectionItem *)item;

@end