//
// Created by Евгений Сафронов on 24.02.15.
// Copyright (c) 2015 rzn.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface AppSection : NSObject

typedef enum {
    TextList, TextImageList, ImageGrid, VideoWithoutPreview, Video
} SectionPreviewType;

@property NSString *title;
@property NSString *requestPath;
@property UIImage *icon;
@property SectionPreviewType previewType;

- (instancetype)initWithTitle:(NSString *)title requestPath:(NSString *)requestPath icon:(UIImage *)icon sectionType:(SectionPreviewType)sectionType;

+ (instancetype)sectionWithTitle:(NSString *)title requestPath:(NSString *)requestPath icon:(UIImage *)icon sectionType:(SectionPreviewType)sectionType;


@end