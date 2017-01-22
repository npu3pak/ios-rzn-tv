//
// Created by Евгений Сафронов on 04.03.15.
// Copyright (c) 2015 rzn.tv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppSection;
@class AppSectionItem;


@interface DataSource : NSObject

+ (instancetype) sharedDataSource;

- (NSArray *)sections;

- (int)loadItemsForSection:(AppSection *)section lastKnownId:(NSNumber *)lastKnownId page:(NSNumber *)page useCache:(BOOL)useCache successCallback:(void (^)(NSArray *, int))responseCallback errorCallback:(void (^)(NSString *, int))faultCallback;

- (void)loadItemWebContentForItem:(AppSectionItem *)item useCache:(BOOL)useCache successCallback:(void (^)(NSString *))responseCallback errorCallback:(void (^)(NSString *))faultCallback;

@end