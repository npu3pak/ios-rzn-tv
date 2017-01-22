//
// Created by Евгений Сафронов on 24.02.15.
// Copyright (c) 2015 rzn.tv. All rights reserved.
//

#import "AppSection.h"
#import "AppSectionItem.h"

@implementation AppSection

- (instancetype)initWithTitle:(NSString *)title requestPath:(NSString *)requestPath icon:(UIImage *)icon sectionType:(SectionPreviewType)sectionType {
    self = [super init];
    if (self) {
        self.title = title;
        self.requestPath = requestPath;
        self.icon = icon;
        self.previewType = sectionType;
    }

    return self;
}

+ (instancetype)sectionWithTitle:(NSString *)title requestPath:(NSString *)requestPath icon:(UIImage *)icon sectionType:(SectionPreviewType)sectionType {
    return [[self alloc] initWithTitle:title requestPath:requestPath icon:icon sectionType:sectionType];
}

@end