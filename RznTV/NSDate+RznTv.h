//
// Created by Евгений Сафронов on 15.07.15.
// Copyright (c) 2015 rzn.tv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (RznTv)

- (NSString *)readableStringValue;

- (NSString *)stringValue;

+ (NSDate *)dateFromString:(NSString *)value;

@end