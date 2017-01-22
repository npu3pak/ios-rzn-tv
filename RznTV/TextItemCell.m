//
// Created by Евгений Сафронов on 25.02.15.
// Copyright (c) 2015 rzn.tv. All rights reserved.
//

#import "TextItemCell.h"
#import "AppSectionItem.h"
#import "IPInsetLabel.h"
#import "NSDate+RznTv.h"


@implementation TextItemCell

- (void)showPreviewItem:(AppSectionItem *)item {
    self.title.text = item.title;
    self.note.text = item.note;
    self.note.verticalTextAlignment = IPInsetLabelVerticalTextAlignmentTop;
    self.timestamp.text = item.timeStamp.readableStringValue;
}

@end