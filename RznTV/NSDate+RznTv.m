//
// Created by Евгений Сафронов on 15.07.15.
// Copyright (c) 2015 rzn.tv. All rights reserved.
//

#import "NSDate+RznTv.h"
#import "NSDate-Utilities.h"

@implementation NSDate (RznTv)

- (NSString *)readableStringValue {
    if (self.isToday) {
        return @"Сегодня";
    }
    if (self.isYesterday) {
        return @"Вчера";
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)stringValue {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    return [dateFormatter stringFromDate:self];
}

+ (NSDate *)dateFromString:(NSString *)value {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    return [dateFormatter dateFromString:value];
}

@end