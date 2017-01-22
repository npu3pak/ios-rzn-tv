//
// Created by Евгений Сафронов on 04.03.15.
// Copyright (c) 2015 rzn.tv. All rights reserved.
//

#import <RestKit/Network/RKObjectRequestOperation.h>
#import "DataSource.h"
#import "AppSection.h"
#import "AppSectionItem.h"
#import "AppSectionItemsResponse.h"
#import "RKRelationshipMapping.h"
#import "RKResponseDescriptor.h"
#import "PINCache.h"


@implementation DataSource

#pragma mark Реализация синглтона

+ (id)sharedDataSource {
    static DataSource *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

#pragma mark Секции для меню

- (NSArray *)sections {
    return @[
            [AppSection sectionWithTitle:@"Новости" requestPath:@"news" icon:[UIImage imageNamed:@"nav_news"] sectionType:TextImageList],
            [AppSection sectionWithTitle:@"Статьи" requestPath:@"articles" icon:[UIImage imageNamed:@"nav_article"] sectionType:TextImageList],
            [AppSection sectionWithTitle:@"Интервью" requestPath:@"talks" icon:[UIImage imageNamed:@"nav_interview"] sectionType:TextImageList],
            [AppSection sectionWithTitle:@"Анонсы" requestPath:@"announcements" icon:[UIImage imageNamed:@"nav_notice"] sectionType:ImageGrid],
            [AppSection sectionWithTitle:@"Видеоновости" requestPath:@"video" icon:[UIImage imageNamed:@"nav_videonews"] sectionType:VideoWithoutPreview],
            [AppSection sectionWithTitle:@"Видеоинтервью" requestPath:@"video_int" icon:[UIImage imageNamed:@"nav_videointerview"] sectionType:VideoWithoutPreview],
    ];
}

#pragma mark Список элементов

- (int)loadItemsForSection:(AppSection *)section
               lastKnownId:(NSNumber *)lastKnownId
                      page:(NSNumber *)page
                  useCache:(BOOL)useCache
           successCallback:(void (^)(NSArray *, int))responseCallback
             errorCallback:(void (^)(NSString *, int))errorCallback {
    if (!page) {
        page = @1;
    }
    int requestId = rand();

    NSString *cacheKey = [NSString stringWithFormat:@"PreviewItems_%@_lastid_%@_page_%@", section.requestPath, lastKnownId.stringValue, page.stringValue];

    if (!useCache) {
        [self loadItemsFromNetworkForSection:section lastKnownId:lastKnownId page:page responseCallback:responseCallback faultCallback:errorCallback requestId:requestId cacheKey:cacheKey];
        return requestId;
    }

    [[PINCache sharedCache] objectForKey:cacheKey block:^(PINCache *cache, NSString *key, id object) {
        if (object) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                responseCallback(object, requestId);
            }];
        } else {
            [self loadItemsFromNetworkForSection:section lastKnownId:lastKnownId page:page responseCallback:responseCallback faultCallback:errorCallback requestId:requestId cacheKey:cacheKey];
        }
    }];

    return requestId;
}

- (void)loadItemsFromNetworkForSection:(AppSection *)section lastKnownId:(NSNumber *)lastKnownId page:(NSNumber *)page responseCallback:(void (^)(NSArray *, int))responseCallback faultCallback:(void (^)(NSString *, int))errorCallback requestId:(int)requestId cacheKey:(NSString *)cacheKey {
    RKObjectMapping *itemMapping = [RKObjectMapping mappingForClass:[AppSectionItem class]];
    [itemMapping addAttributeMappingsFromDictionary:@{
            @"id" : @"id",
            @"title" : @"title",
            @"description" : @"note",
            @"timestamp" : @"timeStamp",
            @"datestart" : @"startDate",
            @"dateend" : @"endDate",
            @"imageurl" : @"imageUrl",
            @"thumburl" : @"thumbUrl",
            @"contenturl" : @"contentUrl",
            @"video" : @"video",
            @"siteurl" : @"siteUrl"
    }];

    RKObjectMapping *listMapping = [RKObjectMapping mappingForClass:[AppSectionItemsResponse class]];
    [listMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"results" toKeyPath:@"items" withMapping:itemMapping]];

    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:listMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];

    NSString *params = lastKnownId
            ? [NSString stringWithFormat:@"format=json&last_known_id=%@&page=%@", lastKnownId.stringValue, page.stringValue]
            : [NSString stringWithFormat:@"format=json&page=%@", page.stringValue];

    NSString *urlString = [NSString stringWithFormat:@"http://rzn.tv/m/%@?%@", section.requestPath, params];

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];

    void (^successCallback)(RKObjectRequestOperation *, RKMappingResult *) = ^(RKObjectRequestOperation *requestOperation, RKMappingResult *result) {
        AppSectionItemsResponse *response = result.firstObject;
        [[PINCache sharedCache] setObject:[self fixContentUrls:response.items section:section] forKey:cacheKey block:^(PINCache *cache, NSString *key, id object) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [NSThread sleepForTimeInterval:1.0f];
                responseCallback(object, requestId);
            }];
        }];
    };

    void (^failureCallback)(RKObjectRequestOperation *, NSError *) = ^(RKObjectRequestOperation *operation, NSError *error) {
        if (error.code == 1004) { //Пустой ответ
            responseCallback(@[], requestId);
        } else {
            errorCallback(@"Не удалось загрузить данные. Проверьте подключение к сети и повторите попытку", requestId);
        }
    };

    [operation setCompletionBlockWithSuccess:successCallback failure:failureCallback];
    [operation start];
}

- (NSArray *)fixContentUrls:(NSArray *)items section:(AppSection *)section {
    NSMutableArray *fixedItems = [NSMutableArray new];
    for (AppSectionItem *item in items) {
        item.contentUrl = [NSString stringWithFormat:@"http://rzn.tv/m/%@/%@/", section.requestPath, item.id.stringValue];
        [fixedItems addObject:item];
    }
    return fixedItems;
}

#pragma mark Содержимое элемента

- (void)loadItemWebContentForItem:(AppSectionItem *)item
                         useCache:(BOOL)useCache
                  successCallback:(void (^)(NSString *))responseCallback
                    errorCallback:(void (^)(NSString *))errorCallback {

    if (!useCache) {
        [self loadWebPageFromNetwork:item responseCallback:responseCallback faultCallback:errorCallback];
        return;
    }

    [[PINCache sharedCache] objectForKey:item.contentUrl block:^(PINCache *cache, NSString *key, id object) {
        if (object) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                responseCallback(object);
            }];
        } else {
            [self loadWebPageFromNetwork:item responseCallback:responseCallback faultCallback:errorCallback];
        }
    }];
}

- (void)loadWebPageFromNetwork:(AppSectionItem *)item responseCallback:(void (^)(NSString *))responseCallback faultCallback:(void (^)(NSString *))errorCallback {
    NSURL *url = [NSURL URLWithString:item.contentUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    void (^successCallback)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        [[PINCache sharedCache] setObject:string forKey:item.contentUrl block:^(PINCache *cache, NSString *key, id object) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                responseCallback(string);
            }];
        }];
    };

    void (^failureCallback)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        errorCallback(@"Не удалось загрузить данные. Проверьте подключение к сети и повторите попытку");
    };
    [requestOperation setCompletionBlockWithSuccess:successCallback failure:failureCallback];
    [requestOperation start];
}

@end