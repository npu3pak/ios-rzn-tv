//
// Created by Евгений Сафронов on 25.02.15.
// Copyright (c) 2015 rzn.tv. All rights reserved.
//

#import "TextImageItemCell.h"
#import "AppSectionItem.h"
#import "IPInsetLabel.h"
#import "NSDate+RznTv.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation TextImageItemCell {
    AppSectionItem *_item;
}

- (void)showPreviewItem:(AppSectionItem *)item {
    _item = item;
    self.title.text = item.title;
    self.note.text = item.note;
    self.note.verticalTextAlignment = IPInsetLabelVerticalTextAlignmentTop;
    self.timestamp.text = item.timeStamp.readableStringValue;
    [self.previewImage sd_setImageWithURL:[NSURL URLWithString:_item.thumbUrl]];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.previewImage setImage:nil];
}

@end