//
// Created by Евгений Сафронов on 24.02.15.
// Copyright (c) 2015 rzn.tv. All rights reserved.
//

#import "AppSectionItem.h"

@implementation AppSectionItem

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.id = [coder decodeObjectForKey:@"self.id"];
        self.title = [coder decodeObjectForKey:@"self.title"];
        self.note = [coder decodeObjectForKey:@"self.note"];
        self.timeStamp = [coder decodeObjectForKey:@"self.timeStamp"];
        self.startDate = [coder decodeObjectForKey:@"self.startDate"];
        self.endDate = [coder decodeObjectForKey:@"self.endDate"];
        self.imageUrl = [coder decodeObjectForKey:@"self.imageUrl"];
        self.thumbUrl = [coder decodeObjectForKey:@"self.thumbUrl"];
        self.contentUrl = [coder decodeObjectForKey:@"self.contentUrl"];
        self.video = [coder decodeObjectForKey:@"self.video"];
        self.siteUrl = [coder decodeObjectForKey:@"self.siteUrl"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.id forKey:@"self.id"];
    [coder encodeObject:self.title forKey:@"self.title"];
    [coder encodeObject:self.note forKey:@"self.note"];
    [coder encodeObject:self.timeStamp forKey:@"self.timeStamp"];
    [coder encodeObject:self.startDate forKey:@"self.startDate"];
    [coder encodeObject:self.endDate forKey:@"self.endDate"];
    [coder encodeObject:self.imageUrl forKey:@"self.imageUrl"];
    [coder encodeObject:self.thumbUrl forKey:@"self.thumbUrl"];
    [coder encodeObject:self.contentUrl forKey:@"self.contentUrl"];
    [coder encodeObject:self.video forKey:@"self.video"];
    [coder encodeObject:self.siteUrl forKey:@"self.siteUrl"];
}

@end