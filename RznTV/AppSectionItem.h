//
// Created by Евгений Сафронов on 24.02.15.
// Copyright (c) 2015 rzn.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppSectionItem : NSObject <NSCoding>

@property NSNumber *id;
@property NSString *title;
@property NSString *note;
@property NSDate   *timeStamp;
@property NSDate   *startDate;
@property NSDate   *endDate;
@property NSString *imageUrl;
@property NSString *thumbUrl;
@property NSString *contentUrl;
@property NSString *video;
@property NSString *siteUrl;

//Следующие два метода нужны для правильной работы сериализатора RestKit

- (id)initWithCoder:(NSCoder *)coder;

- (void)encodeWithCoder:(NSCoder *)coder;

@end