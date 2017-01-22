//
// Created by Евгений Сафронов on 15.07.15.
// Copyright (c) 2015 rzn.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface UIColor (RznTv)

+ (UIColor *)colorFromRgb:(int)rgbValue;

- (UIImage *)coloredImage;

@end