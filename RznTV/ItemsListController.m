//
// Created by Евгений Сафронов on 24.02.15.
// Copyright (c) 2015 rzn.tv. All rights reserved.
//

#import <MMDrawerController/MMDrawerBarButtonItem.h>
#import "ItemsListController.h"
#import "AppSection.h"
#import "UIViewController+MMDrawerController.h"
#import "AppSectionItem.h"
#import "TextItemCell.h"
#import "TextImageItemCell.h"
#import "ItemWebDetailsController.h"
#import "UserPreferences.h"
#import "NSDate-Utilities.h"
#import "UITableView+NXEmptyView.h"
#import "DataSource.h"
#import "NSDate+RznTv.h"
#import "Constants.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>

#define LAST_UPDATE_TIMESTAMP_PREF_KEY @"LastUpdateTimestamp"
#define INFINITE_SCROLLING_CONTROL_VERTICAL_OFFSET 100.0

@implementation ItemsListController {
    NSMutableArray *_items;
    AppSection *_section;
    AppSectionItem *_selectedItem;
    int _lastRequestedPage;
    int _lastRequestId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lastRequestId = -1;
    _lastRequestedPage = 1;
    _items = [NSMutableArray new];
    [self showBarItems];
    [self addPullToRefresh];
    [self addEmptyListView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addInfiniteScrolling];
}

- (void)showBarItems {
    MMDrawerBarButtonItem *drawerItem = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(showDrawer)];
    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SettingsImage"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(showSettings)];
    [self.navigationItem setLeftBarButtonItem:drawerItem];
    [self.navigationItem setRightBarButtonItem:settingsItem];
}

- (void)showDrawer {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)addEmptyListView {
    self.tableView.nxEV_emptyView = [[NSBundle mainBundle] loadNibNamed:@"EmptyTableView" owner:self options:nil][0];
}

- (void)addPullToRefresh {
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(loadFirstPage) forControlEvents:UIControlEventValueChanged];
}

- (void)addInfiniteScrolling {
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    refreshControl.triggerVerticalOffset = INFINITE_SCROLLING_CONTROL_VERTICAL_OFFSET;
    [refreshControl addTarget:self action:@selector(loadNextPage) forControlEvents:UIControlEventValueChanged];
    self.tableView.bottomRefreshControl = refreshControl;
}

- (void)loadNextPage {
    [self loadNextPageFromCache:YES];
}

#pragma mark Загрузка данных

- (void)showSection:(AppSection *)section {
    if ([_section isEqual:section]) return;

    _section = section;
    self.title = section.title;
    [_items removeAllObjects];
    [self.tableView reloadData];
    [self.refreshControl beginRefreshing];
    //Иногда refreshControl заедает
    [self.tableView.bottomRefreshControl endRefreshing];
    self.tableView.separatorColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self loadFirstPage];
}

- (void)loadFirstPage {
    _lastRequestedPage = 1;
    NSString *lastUpdateString = [UserPreferences getStringWithKey:LAST_UPDATE_TIMESTAMP_PREF_KEY withDefault:nil];
    NSDate *lastUpdateTimestamp = [NSDate dateFromString:lastUpdateString];
    BOOL isOldCache = [NSDate.date hoursAfterDate:lastUpdateTimestamp] > CACHE_OBSOLESCENCE_HOURS;

    BOOL useCache = _items.count == 0 && !isOldCache; //Если список загружается в первый раз или мы обновлялись давно - пользуемся кэшем
    if (!useCache) {
        [UserPreferences setString:NSDate.date.stringValue withKey:LAST_UPDATE_TIMESTAMP_PREF_KEY];
    }
    [self loadNextPageFromCache:useCache];
}

- (void)loadNextPageFromCache:(BOOL)useCache {
    void (^errorCallback)(NSString *, int) = ^(NSString *string, int requestId) {
        if (_lastRequestId == requestId) {
            [self.refreshControl endRefreshing];
            [self.tableView.bottomRefreshControl endRefreshing];
            [self showLoadingError];
        }
    };

    void (^successCallback)(NSArray *, int) = ^(NSArray *array, int requestId) {
        [self.refreshControl endRefreshing];
        [self.tableView.bottomRefreshControl endRefreshing];

        if (_lastRequestId == requestId) {
            if (_lastRequestedPage == 1) {
                [_items removeAllObjects];
                self.tableView.separatorColor = [UIColor lightGrayColor];
            }
            _lastRequestedPage++;
            [_items addObjectsFromArray:array];
            [self.tableView reloadData];
        }
    };

    NSNumber *lastKnownId = _lastRequestedPage == 1 ? nil : [[_items lastObject] id];
    _lastRequestId = [[DataSource sharedDataSource] loadItemsForSection:_section lastKnownId:lastKnownId page:@(_lastRequestedPage) useCache:useCache successCallback:successCallback errorCallback:errorCallback];
}

#pragma mark Отображение данных

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (_section.previewType) {
        case TextList:
        case VideoWithoutPreview:
            return 115;
        case TextImageList:
        case ImageGrid:
        case Video:
            return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 140 : 125;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppSectionItem *item = _items[(NSUInteger) indexPath.row];
    switch (_section.previewType) {
        case TextList:
        case VideoWithoutPreview: {
            TextItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
            [cell showPreviewItem:item];
            return cell;
        }

        case TextImageList:
        case ImageGrid:
        case Video: {
            NSString *cellId = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"textImagePhoneCell" : @"textImageCell";
            TextImageItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            [cell showPreviewItem:item];
            return cell;
        }
    }

    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)showLoadingError {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                    message:@"Проверьте подключение к сети и повторите попытку"
                                                   delegate:nil
                                          cancelButtonTitle:@"Закрыть"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    AppSectionItem *item = _items[(NSUInteger) indexPath.row];
    if (_section.previewType == VideoWithoutPreview || _section.previewType == Video) {
        [self showVideoContent:item];
    } else {
        [self showWebContent:item];
    }
}

#pragma mark Переход к другим окнам

- (void)showSettings {
    [self performSegueWithIdentifier:@"ShowSettings" sender:self];
}

- (void)showVideoContent:(AppSectionItem *)previewItem {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:previewItem.video]];
}

- (void)showWebContent:(AppSectionItem *)previewItem {
    _selectedItem = previewItem;
    [self performSegueWithIdentifier:@"ShowDetailsController" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowDetailsController"]) {
        ItemWebDetailsController *detailsController = segue.destinationViewController;
        detailsController.sectionItem = _selectedItem;
    }
}

@end